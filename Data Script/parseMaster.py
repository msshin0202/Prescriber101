#!/usr/bin/python

import os
import plistlib
import xlrd
from datetime import datetime
import html
from bs4 import BeautifulSoup

loc = ("./Prescriber101.xlsx")

wb = xlrd.open_workbook(loc)
sheet = wb.sheet_by_index(0)

master = []
drugInfo = []

row = 0
col = 0
while col < sheet.ncols:
    cellVal = sheet.cell_value(row,col)
    drugInfo.append(cellVal)
    col += 1

row = 1
col = 0

while row < sheet.nrows:
    drugDict = {}
    for info in drugInfo:
        content = sheet.cell_value(row, col)
        if info == "Prescription Guide" or info == "Contributor(s)" or info == "Note(s)":
            content = content.replace("<br>", "")
            contentArray = content.split("\n")
            for element in contentArray:
                if element is "":
                    contentArray.remove(element)
            content = contentArray
        if info == "Updated Date":
            content = xlrd.xldate.xldate_as_datetime(content, wb.datemode)
        if info == "Relevant Evidence (i.e. studies, trials)":
            evidenceArray = []
            soup = BeautifulSoup(content, 'html.parser')
            ahref = soup.findAll('a', href=True)
            for ref in ahref:
                text = ref.get_text()
                link = ref['href']
                evidenceDict = {}
                evidenceDict["Text"] = text
                evidenceDict["Link"] = link
                evidenceArray.append(evidenceDict)
            content = evidenceArray
        if info == "Guideline (with appropriate links)":
            guidelineArray = []
            soup = BeautifulSoup(content, 'html.parser')
            ahref = soup.find_all('a', href=True)
            for ref in ahref:
                pdfText = ref.get_text()
                if pdfText == '':
                    images = ref.findAll('img')
                    arrayInfo = "Images"
                    imagesArray = []
                    for image in images:
                        src = image['src']
                        imagesArray.append(src)
                        imagesArray.append(ref['href'])
                    guidelineArray.append(imagesArray)
                else:
                    pdfArray = []
                    pdfDict = {}
                    link = ref['href']
                    pdfDict.update({"Text": pdfText})
                    pdfDict.update({"Link": link})
                    pdfArray.append(pdfDict)
                    guidelineArray.append(pdfArray)
            content = guidelineArray
        drugDict.update({info: content})
        col += 1
    master.append(drugDict)
    row += 1
    col = 0

fileName=open('master.plist','wb')
plistlib.dump(master, fileName)
fileName.close()
