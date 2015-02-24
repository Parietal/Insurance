//
//  SmartlistsHeaderCell.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class SmartlistsHeaderCell:UITableViewCell
{
    
    @IBOutlet var titleLabel:UILabel?
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.backgroundColor = RAColors.LIGHT_BLUE()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.titleLabel?.textColor = UIColor.whiteColor()
        self.titleLabel?.font = RAFonts.TABLE_HEADER_TITLE()
    }
    
    func update(title:String) {
        self.titleLabel?.text = title
    }
    
}