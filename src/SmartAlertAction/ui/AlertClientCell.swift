//
//  AlertClientCell.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/14/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AlertClientCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var policyPremiumView: BarMeterView!
    @IBOutlet var policiesInHouseholdView: BarMeterView!
    @IBOutlet var yearsAsClientView: CircularMeterView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
