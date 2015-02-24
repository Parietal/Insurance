//
//  ActionTableViewCell.swift
//  SmartAlertAction
//
//  Created by cdp on 10/9/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    
    @IBOutlet var saveContactButton : UIButton?
    
    @IBAction func saveContactTapped(sender: AnyObject) {
        //save contact to device
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}



