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
    var prescriptionGuide: [String]
    var notes: [String]
    var guidelines: [[Any]]
    var relevantEvidence: [NSMutableAttributedString]
    var contributors: [String]
    var updatedDate: Date
    
    init(indication: String, generic: String, brand: String, prescriptionGuide: [String], notes: [String], guidelines: [[Any]], relevantEvidence: [NSMutableAttributedString], contributors: [String], updatedDate: Date) {
        
        self.indication = indication
        self.generic = generic
        self.brand = brand
        self.prescriptionGuide = prescriptionGuide
        self.notes = notes
        self.guidelines = guidelines
        self.relevantEvidence = relevantEvidence
        self.contributors = contributors
        self.updatedDate = updatedDate    
    }
    
}
