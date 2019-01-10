//
//  DrugTableViewController.swift
//  Prescriber101
//
//  Created by Minsoo Matthew Shin on 2018-12-27.
//  Copyright © 2018 Minsoo Shin. All rights reserved.
//

import UIKit

class DrugTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var drugs = [Drug]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load master drug plist here
        guard let plist = Bundle.main.path(forResource: "Master", ofType: "plist") else {
            fatalError("error loading plist")
        }
        guard let drugArray = NSArray(contentsOfFile: plist) else {
            fatalError("error loading array")
        }
        for eachDrug in drugArray {
            guard let drug = eachDrug as? Dictionary<String, Any> else {
                fatalError("error loading drug information")
            }
            drugs.append(extractDrugInfo(for: drug))
        }
        print("count: \(drugs.count)\n")
        for drug in drugs {
            print(drug.generic)
        }
    }
    
    private func extractDrugInfo(for drug: Dictionary<String, Any>) -> Drug {
        var indication: String = ""
        var generic: String = ""
        var brand: String = ""
        var doseRouteSchedule = [String]()
        var adjustment = [String]()
        var contraindication = [String]()
        var notes = [String]()
        var guideline = Dictionary<String, String>()
        var supportingTrial = Dictionary<String, String>()
        var landmarkPapers = [Dictionary<String, String>]()
        var keyTerms = [String]()
        
        for information in drug.keys {
            switch information {
            case "Generic":
                guard let genericName = drug["Generic"] as? String else {
                    fatalError("Generic name in plist in unexpected format")
                }
                generic = genericName
            case "Indication":
                guard let indicationInfo = drug["Indication"] as? String else {
                    fatalError("Indication information in plist in unexpected format")
                }
                indication = indicationInfo
            case "Brand":
                guard let brandName = drug["Brand"] as? String else {
                    fatalError("Brand name in plist in unexpected format")
                }
                brand = brandName
            case "Dose Route Schedule":
                guard let doseRouteScheduleInfo = drug["Dose Route Schedule"] as? [String] else {
                    fatalError("Dose Route Schedule information in plist in unexpected format")
                }
                doseRouteSchedule = doseRouteScheduleInfo
            case "Adjustment":
                guard let adjustmentInfo = drug["Adjustment"] as? [String] else {
                    fatalError("Adjustment information in plist in unexpected format")
                }
                adjustment = adjustmentInfo
            case "Contraindication":
                guard let contraindicationInfo = drug["Contraindication"] as? [String] else {
                    fatalError("Contraindication information in plist in unexpected format")
                }
                contraindication = contraindicationInfo
            case "Notes":
                guard let notesInfo = drug["Notes"] as? [String] else {
                    fatalError("Notes information in plist in unexpected format")
                }
                notes = notesInfo
            case "Guideline Source":
                guard let guidelineInfo = drug["Guideline Source"] as? Dictionary<String,String> else {
                    fatalError("Guideline source information in plist in unexpected format")
                }
                guideline = guidelineInfo
            case "Supporting Trial":
                guard let supportingTrialsInfo = drug["Supporting Trial"] as? Dictionary<String,String> else {
                    fatalError("Guideline information in plist in unexpected format")
                }
                supportingTrial = supportingTrialsInfo
            case "Landmark Papers":
                guard let landmarkPapersInfo = drug["Landmark Papers"] as? [Dictionary<String, String>] else {
                    fatalError("Landmark Papers information in plist in unexpected format")
                }
                landmarkPapers = landmarkPapersInfo
            case "Key Terms":
                guard let keyTermsInfo = drug["Key Terms"] as? [String] else {
                    fatalError("Key Terms information in plist in unexpected format")
                }
                keyTerms = keyTermsInfo
            default:
                fatalError("unexpected information from plist: \(information)")
            }
        }
        let newDrug = Drug(indication: indication, generic: generic, brand: brand, doseRouteSchedule: doseRouteSchedule, adjustment: adjustment, contraindication: contraindication, notes: notes, guideline: guideline, supportingTrial: supportingTrial, landmarkPapers: landmarkPapers, keyTerms: keyTerms)
        return newDrug
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DrugTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? DrugTableViewCell else {
            fatalError("The dequeued cell is not an instance of DrugTableViewCell")
        }
        
        let drug = drugs[indexPath.row]
        
        cell.drugNameLabel.text = "\(drug.generic) (\(drug.brand))"
        cell.guidelineSourceLabel.text = "Source: \(drug.guidelineType)"
        
        return cell
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
