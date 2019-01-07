//
//  Drug.swift
//  Prescriber101
//
//  Created by Minsoo Matthew Shin on 2018-12-27.
//  Copyright © 2018 Minsoo Shin. All rights reserved.
//

import Foundation

class Drug {
    
    var indication: String
    var generic: String
    var brand: String
    var doseRouteSchedule: [String]
    var adjustment: [String]
    var contraindication: [String]
    var notes: [String]
    var guidelineSource: NSURL
    var guidelineType: String
    var supportingTrialText: String
    var supportingTrialSource: NSURL
    var landmarkPapers: [Dictionary<String, Any>]
    var keyTerms: [String]
    
    init(indication: String, generic: String, brand: String, doseRouteSchedule: [String], adjustment: [String], contraindication: [String], notes: [String], guideline: Dictionary<String, String>, supportingTrial: Dictionary<String, String>, landmarkPapers: [Dictionary<String,String>], keyTerms: [String]) {
        
        // Convert guideline source to NSURL from String
        guard let guidelineSource = guideline["Source"] else {
            fatalError("Guideline source not found in plist")
        }
        guard let guidelineSourceNSURL = NSURL(string: guidelineSource) else {
            fatalError("Error creating NSURL for guideline")
        }

        guard let guidelineType = guideline["Type"] else {
            fatalError("Guideline type not found in plist")
        }
        
        // Convert supporting trial source to NSURL from String
        guard let supportingTrialSource = supportingTrial["Source"] else {
            fatalError("Supporting trial source not found in plist")
        }
        guard let supportingTrialSourceNSURL = NSURL(string: supportingTrialSource) else {
            fatalError("Error creating NSURL for supporting trial")
        }
        
        guard let supportingTrialText = supportingTrial["Text"] else {
            fatalError("Supporting trial text not found in plist")
        }
        
        
        // Convert landmark papers source to NSURL from String into a dictionary
        var landmarkPapersArray = [Dictionary<String, Any>]()
        for eachPaper in landmarkPapers {
            guard let newPaperText =  eachPaper["Text"] else {
                fatalError("Unable to get display text from paper text")
            }
            guard let newPaperSource = eachPaper["Source"] else {
                fatalError("Unable to get source from paper")
            }
            guard let paperSourceNSURL = NSURL(string: newPaperSource) else {
                fatalError("Unable to convert source String to NSURL")
            }
            let landmarkPaperDictionary = ["Text": newPaperText, "Source": paperSourceNSURL] as [String : Any]
            landmarkPapersArray.append(landmarkPaperDictionary)
        }
        
        self.indication = indication
        self.generic = generic
        self.brand = brand
        self.guidelineType = guidelineType
        self.guidelineSource = guidelineSourceNSURL
        self.doseRouteSchedule = doseRouteSchedule
        self.adjustment = adjustment
        self.contraindication = contraindication
        self.notes = notes
        self.landmarkPapers = landmarkPapersArray
        self.supportingTrialSource = supportingTrialSourceNSURL
        self.supportingTrialText = supportingTrialText
        self.keyTerms = keyTerms
    
    }
}
