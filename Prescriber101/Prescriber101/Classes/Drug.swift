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
    var guidelines: [Dictionary<String, String>]
    var supportingTrials: [Dictionary<String, String>]
    var landmarkPapers: [Dictionary<String, String>]
    var keyTerms: [String]
    
    init(indication: String, generic: String, brand: String, doseRouteSchedule: [String], adjustment: [String], contraindication: [String], notes: [String], guidelines: [Dictionary<String, String>], supportingTrials: [Dictionary<String, String>], landmarkPapers: [Dictionary<String,String>], keyTerms: [String]) {
        
//        // Convert guideline source to NSURL from String into a dictionary
//
//        var guidelinesArray = [Dictionary<String, Any>]()
//        for eachGuideline in guidelines {
//            guard let newGuidelineText = eachGuideline["Text"] else {
//                fatalError("Unable to get display text from guideline")
//            }
//            guard let newGuidelineSource = eachGuideline["Source"] else {
//                fatalError("Unable to get source from guideline")
//            }
//            guard let guidelineSourceNSURL = NSURL(string: newGuidelineSource) else {
//                fatalError("Unable to convert trial source String to NSURL")
//            }
//            let guidelinesDictionary = ["Text": newGuidelineText, "Source": guidelineSourceNSURL] as [String : Any]
//            guidelinesArray.append(guidelinesDictionary)
//        }
//
//        // Convert supporting trial source to NSURL from String into a dictionary
//
//        var supportingTrialsArray = [Dictionary<String, Any>]()
//        for eachTrial in supportingTrials {
//            guard let newTrialText = eachTrial["Text"] else {
//                fatalError("Unable to get display text from trial")
//            }
//            guard let newTrialSource = eachTrial["Source"] else {
//                fatalError("Unable to get source from trial")
//            }
//            guard let trialSourceNSURL = NSURL(string: newTrialSource) else {
//                fatalError("Unable to convert trial source String to NSURL")
//            }
//            let supportingTrialsDictionary = ["Text": newTrialText, "Source": trialSourceNSURL] as [String : Any]
//            supportingTrialsArray.append(supportingTrialsDictionary)
//        }
//
//
//        // Convert landmark papers source to NSURL from String into a dictionary
//        var landmarkPapersArray = [Dictionary<String, String>]()
//        for eachPaper in landmarkPapers {
//            guard let newPaperText =  eachPaper["Text"] else {
//                fatalError("Unable to get display text from paper text")
//            }
//            guard let newPaperSource = eachPaper["Source"] else {
//                fatalError("Unable to get source from paper")
//            }
//            guard let paperSourceNSURL = NSURL(string: newPaperSource) else {
//                fatalError("Unable to convert paper source String to NSURL")
//            }
//            let landmarkPaperDictionary = ["Text": newPaperText, "Source": newPaperSource] as [String : String]
//            landmarkPapersArray.append(landmarkPaperDictionary)
//        }
        
        self.indication = indication
        self.generic = generic
        self.brand = brand
        self.guidelines = guidelines
        self.doseRouteSchedule = doseRouteSchedule
        self.adjustment = adjustment
        self.contraindication = contraindication
        self.notes = notes
        self.landmarkPapers = landmarkPapers
        self.supportingTrials = supportingTrials
        self.keyTerms = keyTerms
    
    }
}
