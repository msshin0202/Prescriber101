//
//  DrugTableViewCell.swift
//  Prescriber101
//
//  Created by Minsoo Matthew Shin on 2018-12-27.
//  Copyright © 2018 Minsoo Shin. All rights reserved.
//

import UIKit

class DrugTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var guidelineSourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
