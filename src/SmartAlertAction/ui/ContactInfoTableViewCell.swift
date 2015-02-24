//
//  ContactInfoTableViewCell.swift
//  SmartAlertAction
//
//  Created by cdp on 10/7/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ContactInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var subTitleLabel:UILabel?
    @IBOutlet var callButton:UIButton?
    
    @IBAction func buttonTappedAction(sender: AnyObject) {
        if(sender.tag == 100)
        {
            // text
            
            
        }
        else if (sender.tag == 101)
        {
            // email
        }
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = RAColors.LIGHT_GRAY
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.editingAccessoryType = UITableViewCellAccessoryType.None
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        self.titleLabel?.textColor = UIColor.grayColor()
//        self.titleLabel?.font = RAFonts.CLIENT_CONTACT_CELL_TITLE;
//        self.subTitleLabel?.textColor = UIColor.blackColor()
//        self.subTitleLabel?.font = RAFonts.CLIENT_CONTACT_CELL_TITLE
//        
//    }
}