//
//  MultiColumnTableViewCell.swift
//  SmartAlertAction
//
//  Created by Saurav on 14/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class MultiColumnTableViewCell: UITableViewCell {

    @IBOutlet weak var leftTextLabel: UILabel!
    @IBOutlet weak var leftDetailLabel: UILabel!
    @IBOutlet weak var rightTextLabel: UILabel!
    @IBOutlet weak var rightDetailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
