//
//  AlertRecommendationCell.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/24/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AlertRecommendationCell: UITableViewCell {
    
    @IBOutlet weak var alertRecommendationTitle:UILabel!
    @IBOutlet weak var alertRecommendationDetail:UITextView!
    @IBOutlet weak var salesRecommendationTitle:UILabel!
    @IBOutlet weak var salesRecommendationDetail:UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
