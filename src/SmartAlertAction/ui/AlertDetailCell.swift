//
//  AlertDetailCell.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/14/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AlertDetailCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var starRate: DiamondRatingView!
    @IBOutlet weak var noteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
