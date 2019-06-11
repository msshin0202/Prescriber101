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
    @IBOutlet weak var doseRouteScheduleStackView: UIStackView!
    @IBOutlet weak var adjustmentStackView: UIStackView!
    @IBOutlet weak var contraindicationStackView: UIStackView!
    @IBOutlet weak var trialsStackView: UIStackView!
    @IBOutlet weak var papersStackView: UIStackView!
    @IBOutlet weak var sourceStackView: UIStackView!
    @IBOutlet weak var trialsTextView: UITextView!
    @IBOutlet weak var papersTextView: UITextView!
    
    @IBOutlet weak var doseRouteScheduleLabel: UILabel!
    @IBOutlet weak var adjustmentsLabel: UILabel!
    @IBOutlet weak var contraindicationsLabel: UILabel!
    @IBOutlet weak var sourceImage: UIImageView!
    
    
    var selectedDrug: Drug?
    var trialsLinks = [NSMutableAttributedString]()
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
        if drug.doseRouteSchedule.isEmpty {
            doseRouteScheduleStackView.isHidden = true
        }
        if drug.adjustment.isEmpty {
            adjustmentStackView.isHidden = true
        }
        if drug.contraindication.isEmpty {
            contraindicationStackView.isHidden = true
        }
        if drug.supportingTrials.isEmpty {
            trialsStackView.isHidden = true
        }
        if drug.landmarkPapers.isEmpty {
            papersStackView.isHidden = true
        }
        if drug.guidelines.isEmpty {
            sourceStackView.isHidden = true
        }
    }
    
    private func displaySourceImage(for drug: Drug) {
        guard let guidelines = selectedDrug?.guidelines else {
            fatalError("Error retrieving guidelines")
        }
        
        for (_, info) in guidelines.enumerated() {
            guard let guidelineText = info["Text"] else {
                fatalError("Error retrieving type of guideline source")
            }
            
            switch guidelineText {
            case "Diabetes":
                sourceImage.image = UIImage(named: "diabetesCanada")
            default:
                fatalError("Error displaying source image for given text.")
            }
            
            // need to decide whether source image will be one or many and change code based on decision.
//            guard let guidelineSource = info["Source"] else {
//                fatalError("Error retrieving guideline URL")
//            }
            
        }
    }
    
    private func displayDrugInfo(for drug: Drug) {
        // display dose route schedule
        doseRouteScheduleLabel.text = retrieveDisplayText(drugData: drug.doseRouteSchedule)
        
        // display adjustments/caution info
        adjustmentsLabel.text = retrieveDisplayText(drugData: drug.adjustment)
        
        // display contraindications information
        contraindicationsLabel.text = retrieveDisplayText(drugData: drug.contraindication)
        
        // display trials information
        trialsLinks = setLinks(drugData: drug.supportingTrials, textView: trialsTextView)
        trialsTextView.attributedText = retrieveDisplayText(for: trialsLinks)
        
        // display papers information
        papersLinks = setLinks(drugData: drug.landmarkPapers, textView: papersTextView)
        papersTextView.attributedText = retrieveDisplayText(for: papersLinks)
        
        // display source information
        displaySourceImage(for: drug)
        
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
            
            guard let guidelineSource = info["Source"] else {
                fatalError("Error retrieving guideline URL")
            }
            
            if let sourceURL = NSURL(string: guidelineSource) as URL? {
                UIApplication.shared.open(sourceURL)
            }
            
        }
        sourceImage.contentMode = .scaleAspectFit
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
