//
//  DrugViewController.swift
//  Prescriber101
//
//  Created by Minsoo Matthew Shin on 2019-01-13.
//  Copyright © 2019 Minsoo Shin. All rights reserved.
//

import UIKit
import WebKit
import os

class DrugViewController: UIViewController {
    
    @IBOutlet var backgroundColorViews: [UIView]!
    @IBOutlet weak var indicationStackView: UIStackView!
    @IBOutlet weak var dosageStackView: UIStackView!
    @IBOutlet weak var relevantEvidenceStackView: UIStackView!
    @IBOutlet weak var guidelineStackView: UIStackView!
    @IBOutlet weak var lastUpdatedStackView: UIStackView!
    @IBOutlet weak var contributorsStackView: UIStackView!
    @IBOutlet weak var guidelineTextView: UITextView!
    @IBOutlet weak var relevantEvidenceTextView: UITextView!
    
    @IBOutlet weak var indicationLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var guidelineImage: UIImageView!
    @IBOutlet weak var contributorsLabel: UILabel!
    
    
    var selectedDrug: Drug?
    var relevantEvidenceLinks = [NSMutableAttributedString]()
    var papersLinks = [NSMutableAttributedString]()
    var sourceLinks = [NSMutableAttributedString]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in backgroundColorViews {
            view.backgroundColor = UIColor.clear
        }
        
        guard let drug = selectedDrug else { fatalError("Drug data not received properly") }
        
        self.title = "\(drug.generic) (\(drug.brand))"
        
        hideEmptyInfo(for: drug)
        displayDrugInfo(for: drug)
        
    }
    
    private func hideEmptyInfo(for drug: Drug) {
        if drug.prescriptionGuide.isEmpty {
            dosageStackView.isHidden = true
        }
        if drug.relevantEvidence.isEmpty {
            relevantEvidenceStackView.isHidden = true
        }
        if drug.guidelines.isEmpty {
            guidelineStackView.isHidden = true
        }
        if drug.contributors.isEmpty {
            contributorsStackView.isHidden = true
        }
    }
    
    private func displayDrugInfo(for drug: Drug) {
        // display drug indication
        indicationLabel.text = drug.indication
        
        // display dosage info
        dosageLabel.text = retrieveDisplayText(drugData: drug.prescriptionGuide)
        
        // display relevant evidence information
        relevantEvidenceTextView.attributedText = retrieveDisplayText(for: drug.relevantEvidence)
        
        // display guideline image with link
        displayGuidelineImage(for: drug)
        
        // display last updated information
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

        let dateString = formatter.string(from: drug.updatedDate)
        if let intermediateDate = formatter.date(from: dateString) {
            formatter.dateFormat = "dd-MMM-yy"
            let finalDate = formatter.string(from: intermediateDate)
            lastUpdatedLabel.text = finalDate
        }

        // display contributor(s) information
        contributorsLabel.text = retrieveDisplayText(drugData: drug.contributors)
        
    }
    
    private func displayGuidelineImage(for drug: Drug) {
        guard let guidelines = selectedDrug?.guidelines else {
            fatalError("Error retrieving guidelines")
        }
        
        for guide in guidelines {
            if guide.count == 1 {
                // image source in this array
                guidelineImage.image = UIImage(named: guide[0].string)
            } else {
                // create NSMutableAttributedString
                // let clickableLink = NSMutableAttributedString(string: text)
                // clickableLink.addAttribute(.link, value: link, range: NSRange(location: 0, length: clickableLink.length - 1))
            }
        }
        
//        for (_, info) in guidelines.enumerated() {
//            guard let guidelineText = info["Text"] else {
//                fatalError("Error retrieving type of guideline source")
//            }
//
//            switch guidelineText {
//            case "Diabetes":
//                sourceImage.image = UIImage(named: "diabetesCanada")
//            default:
//                fatalError("Error displaying source image for given text.")
//            }
//
//        }
    }
    
    private func retrieveRelevantEvidenceText(drugData: [[NSMutableAttributedString]]) -> NSMutableAttributedString {
        //implement
        return NSMutableAttributedString()
    }
    
    private func retrieveDisplayText (for links: [NSMutableAttributedString]) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString()
        for (index, link) in links.enumerated() {
            if index == links.endIndex - 1 {
                attributedText.append(link)
            } else {
                attributedText.append(link)
                attributedText.append(NSAttributedString(string: "\n"))
            }
        }
        return attributedText
    }
    
    private func setLinks(drugData: [Dictionary<String, Any>], textView: UITextView) -> [NSMutableAttributedString] {
        var mutableArray = [NSMutableAttributedString]()
        for (_, info) in drugData.enumerated() {
            
            guard let descriptionString = info["Text"] as? String else {
                os_log("Unexpected format of text description")
                return mutableArray
            }
            
            guard let sourceString = info["Source"] as? String else {
                os_log("Unexpected format of source description")
                return mutableArray
            }
            
            let descriptionMutableString = NSMutableAttributedString(string: descriptionString)
            let nsurl = NSURL(string: sourceString)!
            descriptionMutableString.setAttributes([.link: nsurl], range: (descriptionString as NSString).range(of: descriptionString))
            
            textView.linkTextAttributes = [
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ]
            textView.attributedText = descriptionMutableString
            mutableArray.append(descriptionMutableString)
        }
        
        return mutableArray
    }
    
    private func retrieveDisplayText(drugData: [String]) -> String {
        var drugInfoToBeDisplayed = ""
        
        for (index, info) in drugData.enumerated() {
            if index == drugData.endIndex - 1 {
                drugInfoToBeDisplayed.append("\(info)")
            } else {
                drugInfoToBeDisplayed.append("\(info)\n")
            }
        }
        return drugInfoToBeDisplayed
    }
    
    // MARK: IBActions
    
    @IBAction func sourceLinkTapped(recognizer: UITapGestureRecognizer) {
        guard let guidelines = selectedDrug?.guidelines else {
            fatalError("Error retrieving guidelines")
        }
        
        for (_, info) in guidelines.enumerated() {
//
//            guard let guidelineSource = info["Source"] else {
//                fatalError("Error retrieving guideline URL")
//            }
//
//            if let sourceURL = NSURL(string: guidelineSource) as URL? {
//                UIApplication.shared.open(sourceURL)
//            }
            
        }
        guidelineImage.contentMode = .scaleAspectFit
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
