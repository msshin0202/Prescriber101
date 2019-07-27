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
            if guide is [String] {
                // image source in this array
                if let imageString = guide[0] as? String {
                    guidelineImage.image = UIImage(named: imageString)
                }
                
            } else if guide is [Dictionary<String, String>] {
                // create NSMutableAttributedString
                var guidelineArray = [NSMutableAttributedString]()
                for guideContent in guide {
                    if let guideDict = guideContent as? Dictionary<String, String> {
                        guard let guideText = guideDict["Text"] else {
                            fatalError("Guide text not formmatted correctly")
                        }
                        guard let guideLink = guideDict["Link"] else {
                            fatalError("Guide link not formmated correctly")
                        }
                        let clickableLink = NSMutableAttributedString(string: guideText)
                        clickableLink.addAttribute(.link, value: guideLink, range: NSRange(location: 0, length: clickableLink.length))
                        guidelineArray.append(clickableLink)
                        print(clickableLink)
                    }
                }
                guidelineTextView.attributedText = retrieveDisplayText(for: guidelineArray)
            }
        }
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
    
    @IBAction func guidelineImageTapped(recognizer: UITapGestureRecognizer) {
        
        guard let guidelines = selectedDrug?.guidelines else {
            fatalError("Error retrieving guidelines")
        }
        
        for guide in guidelines {
            if guide is [String] {
                // image source in this array
                guard let imageLink = guide[1] as? String else {
                    fatalError("Unable to retrieve image link")
                }
                
                if let sourceURL = NSURL(string: imageLink) as URL? {
                    UIApplication.shared.open(sourceURL)
                }
                
            }
        }
    }
}
