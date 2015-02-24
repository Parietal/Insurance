//
//  AddPhotoOptionCell.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-09-18.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class AddPhotoOptionCell:UITableViewCell
{
    
    @IBInspectable var titleLabel:String = ""
    @IBInspectable var lastRow:Bool = false
    var separator:UIView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //set colours
        self.backgroundColor = UIColor.whiteColor()
        
        //add label
        var label:UILabel = UILabel(frame: self.contentView.frame)
        label.textAlignment = NSTextAlignment.Center
        label.font = RAFonts.POPOVER_OPTIONS_CELL_LABEL()
        label.text = self.titleLabel
        label.textColor = RAColors.BLUE1
        self.addSubview(label)
        
        /*
        //add separator
        self.separator = UIUtils.getTableViewCellSeparator(self.frame, leftMargin: 0, rightMargin: 0)
        self.separator!.hidden = self.lastRow
        self.addSubview(self.separator!)
        */
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //set selected cell background
        var bgView:UIView = UIView(frame: self.frame)
        bgView.backgroundColor = RAColors.GRAY4
        self.selectedBackgroundView = bgView
    }
    
}