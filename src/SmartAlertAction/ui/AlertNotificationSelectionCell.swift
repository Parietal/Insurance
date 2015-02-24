//
//  AlertNotificationSelectionCell.swift
//  SmartAlertAction
//
//  Created by Lad on 14-11-12.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AlertNotificationSelectionCell: UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
