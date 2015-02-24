//
//  PaymentInfoTableViewCell.swift
//  SmartAlertAction
//
//  Created by Saurav on 23/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class PaymentInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
