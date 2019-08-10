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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        setCustomization()
        loadPlist()
        setUpSearchBar()
    }
    
    // MARK: - Private instance methods
    
    private func loadPlist() {
        
        guard let plist = Bundle.main.path(forResource: "master", ofType: "plist") else {
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
        var prescriptionGuide = [String]()
        var notes = [String]()
        var guidelines = [[Any]]()
        var relevantEvidence = [NSMutableAttributedString]()
        var contributors = [String]()
        var updatedDate = Date()
        
        for information in drug.keys {
            switch information {
            case "Medication Name":
                guard let genericName = drug["Medication Name"] as? String else {
                    fatalError("Generic name in plist in unexpected format")
                }
                generic = genericName
            case "Indication":
                guard let indicationInfo = drug["Indication"] as? String else {
                    fatalError("Indication information in plist in unexpected format")
                }
                indication = indicationInfo
            case "Brand Name(s)":
                guard let brandName = drug["Brand Name(s)"] as? String else {
                    fatalError("Brand name in plist in unexpected format")
                }
                let brands = brandName.split {$0.isNewline}
                for eachBrand in brands {
                    brand.append(eachBrand + " ")
                }
            case "Prescription Guide":
                guard let guide = drug["Prescription Guide"] as? [String] else {
                    fatalError("Dose Route Schedule information in plist in unexpected format")
                }
                prescriptionGuide = guide
            case "Note(s)":
                guard let notesInfo = drug["Note(s)"] as? [String] else {
                    fatalError("Notes information in plist in unexpected format")
                }
                notes = notesInfo
            case "Guideline (with appropriate links)":
                guard let guidelineInfo = drug["Guideline (with appropriate links)"] as? [[Any]] else {
                    fatalError("Guidelines information in plist in unexpected format")
                }
                
                var imageArray = [String]()
                for infoToDisplay in guidelineInfo {
                    for content in infoToDisplay {
                        if content is String {
                            if let imageFileData = content as? String {
                                imageArray.append(imageFileData)
                            }
                        } else if content is Dictionary<String, String> {
                            if let guidelineContent = content as? Dictionary<String, String> {
                                let guideArray = [guidelineContent]
                                guidelines.append(guideArray)
                            }
                        }
                    }
                    guidelines.append(imageArray)
                }
            case "Relevant Evidence (i.e. studies, trials)":
                guard let evidenceInfo = drug["Relevant Evidence (i.e. studies, trials)"] as? [[String: String]] else {
                    fatalError("Relevant Evidence information in plist in unexpected format")
                }
                for evidence in evidenceInfo {
                    var evidenceLink: String?
                    var evidenceText: String?
                    var mutableEvidence: NSMutableAttributedString
                    for (type, content) in evidence {
                        switch type {
                        case "Link":
                            evidenceLink = content
                        case "Text":
                            evidenceText = content
                        default:
                            fatalError("Unknown type of Evidence")
                        }
                    }
                    
                    guard evidenceText != nil else {
                        fatalError("Evidence text was not set properly")
                    }
                    guard evidenceLink != nil else {
                        fatalError("Evidence link was not set properly")
                    }
                    mutableEvidence = NSMutableAttributedString(string: evidenceText!)
                    mutableEvidence.addAttribute(.link, value: evidenceLink!, range: NSRange(location: 0, length: mutableEvidence.length))
                    relevantEvidence.append(mutableEvidence)
                }
            case "Contributor(s)":
                guard let contributorsInfo = drug["Contributor(s)"] as? [String] else {
                    fatalError("Contributor(s) information in plist in unexpected format")
                }
                contributors = contributorsInfo
            case "Updated Date":
                guard let dateInfo = drug["Updated Date"] as? Date else {
                    fatalError("Key Terms information in plist in unexpected format")
                }
                updatedDate = dateInfo
            default:
                print(information)
                fatalError("unexpected information from plist: \(information)")
            }
        }
        let newDrug = Drug(indication: indication, generic: generic, brand: brand, prescriptionGuide:  prescriptionGuide, notes: notes, guidelines: guidelines, relevantEvidence: relevantEvidence, contributors: contributors, updatedDate: updatedDate)
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
        
        let drugNameLabel = "\(drug.generic) \(drug.brand)"
        let drugGeneric = drug.generic
        let drugBrand = drug.brand
        
        let nonBoldRange = NSMakeRange(drugGeneric.count, drugBrand.count+1)
        
        cell.drugNameLabel.attributedText = attributedString(from: drugNameLabel, nonBoldRange: nonBoldRange)
        
        let indicationText = drug.indication
        cell.guidelineSourceLabel.text = "\(indicationText)"
        
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
    
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.labelFontSize
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ]
        
        let nonBoldAttr = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)
        ]
        let attrString = NSMutableAttributedString(string: string, attributes: attributes)
        
        if let range = nonBoldRange {
            attrString.setAttributes(nonBoldAttr, range: range)
        }
        return attrString
    }
}

extension DrugTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

