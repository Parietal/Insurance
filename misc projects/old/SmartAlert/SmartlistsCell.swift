//
//  SmartlistsCell.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class SmartlistsCell:UITableViewCell
{
    
    @IBOutlet var separator:UIView?
    @IBOutlet var arrow:UIImageView?
    @IBOutlet var favButton:SmartlistsFavoriteButton?
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var bodyTextView:UITextView?
    @IBOutlet var timeLabel:UILabel?
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        
        //set highlight background
        self.selectionStyle = UITableViewCellSelectionStyle.Default
        var bg:UIView = UIView(frame: self.bounds)
        bg.layer.masksToBounds = true
        bg.backgroundColor = RAColors.LIGHT_BLUE().colorWithAlphaComponent(0.25)
        self.selectedBackgroundView = bg
    }
    
    override func layoutSubviews() {
        self.separator?.backgroundColor = RAColors.LIGHT_GRAY()
        self.titleLabel?.textColor = RAColors.DARK_GRAY()
        self.titleLabel?.font = RAFonts.SMARTLISTS_CELL_TITLE()
        self.bodyTextView?.textColor = RAColors.MEDIUM_GRAY()
        self.bodyTextView?.font = RAFonts.SMARTLISTS_CELL_BODY()
        self.timeLabel?.textColor = RAColors.MEDIUM_GRAY()
        self.timeLabel?.font = RAFonts.SMARTLISTS_CELL_TIME()
    }
    
    func update(alert:SmartListsAlertModel)
    {
        self.favButton?.reset(false)
        self.titleLabel?.text = alert.title
        self.bodyTextView?.text = alert.body
        self.timeLabel?.text = alert.date
    }
    
}