//
//  AlertImportanceCell.swift
//  SmartAlertAction
//
//  Created by Lad on 14-11-12.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AlertImportanceCell: UITableViewCell {

    @IBOutlet weak var rateView: UILabel!
    @IBOutlet weak var checkImgv:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
