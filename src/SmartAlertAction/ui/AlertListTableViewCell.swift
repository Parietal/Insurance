//
//  AlertListTableViewCell.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/9/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AlertListTableViewCell: SwipeableTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionsLabel: UILabel!

    override func drawRect(rect: CGRect) {
        self.titleLabel?.font = RAFonts.ALERTLIST_CELL_TITLE
        self.titleLabel?.textColor = RAColors.MEDIUM_GRAY

        self.dateLabel?.font = RAFonts.ALERTLIST_CELL_DATE
        self.dateLabel?.textColor = RAColors.MEDIUM_GRAY
        
        self.messageLabel?.font = RAFonts.ALERTLIST_CELL_MESSAGE
        
        self.actionsLabel?.font = RAFonts.ALERTLIST_CELL_ACTIONS
        self.actionsLabel?.textColor = RAColors.MEDIUM_GRAY
        super.drawRect(rect)
    }
    
    class func heightOfAlertCell(alert: AlertModel) -> CGFloat {
        //return 140
        
        // simple calc for height
        var height: CGFloat = 8 // cell padding
        
        // title, date in one line
        height += 23
        
        // message, need to measure
        if NSString(string: alert.message).length > 0 {
            var font:UIFont  = RAFonts.ALERTLIST_CELL_MESSAGE
            var size  = alert.message.boundingRectWithSize(CGSizeMake(200, 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).size
            height += size.height
        } else {
            height += 25
        }
        
        // actions one line
        if alert.actions.count > 0 {
            height += (8 + 17)
        }
        
        return height
    }
}
