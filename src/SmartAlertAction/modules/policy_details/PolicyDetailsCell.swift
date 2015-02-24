//
//  PolicyDetailsCell.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-11-24.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class PolicyDetailsCell:UITableViewCell
{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    private func initialize() {
        self.clipsToBounds = true
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //draw custom separator based on the layoutMargin of the cell
        //couldn't use default separator because of iOS rendering bug where separator loses layoutmargin after scrolling
        let border:UIView = UIView()
        let x:CGFloat = self.layoutMargins.left
        let y:CGFloat = self.frame.height - self.layoutMargins.bottom - 1
        let w:CGFloat = self.frame.width - self.layoutMargins.left - self.layoutMargins.right
        let h:CGFloat = 0.5
        border.frame = CGRectMake(x, y, w, h)
        border.backgroundColor = RAColors.GRAY4
        self.addSubview(border)
    }
    
}