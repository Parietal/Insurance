//
//  AlertRecommendationCell2.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/30/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AlertRecommendationCell2: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()

        //CGContextSetFillColorWithColor(context, RAColors.GRAY5)
        //CGContextFillRect(context, rect);
    
        // top separate line
        CGContextSetStrokeColorWithColor(context, RAColors.GRAY5.CGColor)
        CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1))
    
        // bottom separate line
        //CGContextSetStrokeColorWithColor(context, RAColors.GRAY5.CGColor)
        //CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1))
    }
}
