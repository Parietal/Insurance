//
//  ClientConsentTableViewCell.swift
//  SmartAlertAction
//
//  Created by Saurav on 23/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ClientConsentTableViewCell: UITableViewCell {

    @IBOutlet weak var consentLabel: UILabel!
    @IBOutlet weak var consentSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
