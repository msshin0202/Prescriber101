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
