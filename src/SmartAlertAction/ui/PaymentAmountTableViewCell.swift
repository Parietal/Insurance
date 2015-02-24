//
//  PaymentAmountTableViewCell.swift
//  SmartAlertAction
//
//  Created by Saurav on 22/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class PaymentAmountTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setSelected(false, animated: false)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        var imageName:String = selected ? "checkBox_ON" : "checkBox_OFF"
        self.button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    }

}
