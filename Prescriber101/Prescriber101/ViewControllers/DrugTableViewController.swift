//
//  DrugTableViewController.swift
//  Prescriber101
//
//  Created by Minsoo Matthew Shin on 2018-12-27.
//  Copyright © 2018 Minsoo Shin. All rights reserved.
//

import UIKit

class DrugTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)

    var drugs = [Drug]()
    var filteredDrugs = [Drug]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomization()
        loadPlist()
        setUpSearchBar()
    }
    
    // MARK: - Private instance methods
    
    private func loadPlist() {
        
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
    }
    
    private func setCustomization() {
        self.title = "Prescriber 101"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.15, green: 0.09, blue: 0.78, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by drug name or indication"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDrugs = drugs.filter({( drug : Drug) -> Bool in
            return drug.generic.lowercased().contains(searchText.lowercased()) || drug.brand.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    private func extractDrugInfo(for drug: Dictionary<String, Any>) -> Drug {
        var indication: String = ""
        var generic: String = ""
        var brand: String = ""
        var doseRouteSchedule = [String]()
        var adjustment = [String]()
        var contraindication = [String]()
        var notes = [String]()
        var guidelines = [Dictionary<String, String>]()
        var supportingTrials = [Dictionary<String, String>]()
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
            case "Guidelines":
                guard let guidelineInfo = drug["Guidelines"] as? [Dictionary<String,String>] else {
                    fatalError("Guideline source information in plist in unexpected format")
                }
                guidelines = guidelineInfo
            case "Supporting Trials":
                guard let supportingTrialsInfo = drug["Supporting Trials"] as? [Dictionary<String,String>] else {
                    fatalError("Guideline information in plist in unexpected format")
                }
                supportingTrials = supportingTrialsInfo
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
        let newDrug = Drug(indication: indication, generic: generic, brand: brand, doseRouteSchedule: doseRouteSchedule, adjustment: adjustment, contraindication: contraindication, notes: notes, guidelines: guidelines, supportingTrials: supportingTrials, landmarkPapers: landmarkPapers, keyTerms: keyTerms)
        return newDrug
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredDrugs.count
        }
        return drugs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DrugTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? DrugTableViewCell else {
            fatalError("The dequeued cell is not an instance of DrugTableViewCell")
        }
        let drug: Drug
        if isFiltering() {
            drug = filteredDrugs[indexPath.row]
        } else {
            drug = drugs[indexPath.row]
        }
        
        cell.drugNameLabel.text = "\(drug.generic) (\(drug.brand))"
        
        
        var guidelineText = ""
        for (index, guidelineDescription) in drug.guidelines.enumerated() {
            guard let guideline = guidelineDescription["Text"] else {
                fatalError("Could not get guideline description")
            }
            if index == drug.guidelines.endIndex - 1 {
                guidelineText.append("\(guideline)")
            } else {
                guidelineText.append("\(guideline), ")
            }
        }
        
        cell.guidelineSourceLabel.text = "Source: \(guidelineText)"
        
        return cell
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DrugInformationSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let drug: Drug

                if isFiltering() {
                    drug = filteredDrugs[indexPath.row]
                } else {
                    drug = drugs[indexPath.row]
                }
                print(drug)
                let controller = segue.destination as! DrugViewController
                controller.selectedDrug = drug
            } else {
                fatalError("Error with getting drug detail")
            }
        }
    }
}

extension DrugTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

