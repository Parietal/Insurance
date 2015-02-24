//
//  ClientDetailSettingsTableViewCell.swift
//  SmartAlertAction
//
//  Created by SunTeng on 9/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ClientDetailSettingsTableViewCell: UITableViewCell {

    @IBOutlet var settingsLabel: UILabel!
    @IBOutlet var settingsSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.settingsSwitch.onTintColor = RAColors.BLUE1  // Bruce ** Color Change
    }

}
