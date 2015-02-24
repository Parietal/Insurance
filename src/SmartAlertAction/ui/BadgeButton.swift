//
//  BadgeButton.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/13/14.
//  Modified by Abhilasha
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class BadgeButton: UIButton {
    
    private var _contentWidth:CGFloat = 0.0
    
    @IBInspectable var radius:CGFloat = 14.0
    
    @IBInspectable var circlePaddingLeft:CGFloat = 5.0
    
    // the title padding is the spacing between the circle badge and the label
    @IBInspectable var titlePaddingLeft:CGFloat = 10.0
    
    //the number displayed inside the badge(circle)
    @IBInspectable var badge:NSString = "99"
    
    //font for the number displayed inside the (badge)circle
    @IBInspectable var badgeFont:UIFont = RAFonts.HELVETICA_NEUE_MEDIUM_12
    
    @IBInspectable var selectedBadgeFont:UIFont = RAFonts.HELVETICA_NEUE_MEDIUM_12
    
    @IBInspectable var badgeColor:UIColor = RAColors.BLUE1  // Bruce ** Color Change
    
    @IBInspectable var selectedBadgeColor:UIColor = UIColor.whiteColor()
    
    @IBInspectable var circleBorderColor:UIColor = RAColors.BLUE1  // Bruce ** Color Change
    
    @IBInspectable var circleFillColor:UIColor = UIColor.whiteColor()
    
    @IBInspectable var circleSelectedBorderColor:UIColor = RAColors.BLUE1  // Bruce ** Color Change
    
    @IBInspectable var circleSelectedFillColor:UIColor = RAColors.BLUE1  // Bruce ** Color Change
    
    @IBInspectable var titleFont:UIFont = RAFonts.HELVETICA_NEUE_REGULAR_17
    
    
    var contentWidth:CGFloat {
        get {return _contentWidth}
    }
    
    override private init(frame: CGRect)
    {
        super.init(frame: frame)
        tintColor = UIColor.clearColor()
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.setTitleColor(RAColors.BLUE1, forState: UIControlState.Normal)  // Bruce ** Color Change
        
        self.titleLabel?.font = titleFont
    }
    
    convenience init(width:CGFloat,height:CGFloat)
    {
        self.init(frame: CGRect(x: 0.0,y: 0.0,width: width,height: height))
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        var attr:NSDictionary
        // Draw Circle
        if self.selected
        {
            CGContextSetFillColorWithColor(context, circleSelectedFillColor.CGColor)
            CGContextSetStrokeColorWithColor(context, circleSelectedBorderColor.CGColor)
            attr = [NSFontAttributeName: selectedBadgeFont,NSForegroundColorAttributeName:selectedBadgeColor]
        }
        else
        {
            CGContextSetFillColorWithColor(context, circleFillColor.CGColor)
            CGContextSetStrokeColorWithColor(context, circleBorderColor.CGColor)
            attr = [NSFontAttributeName: badgeFont,NSForegroundColorAttributeName:badgeColor]
        }
        
        let center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)
        CGContextBeginPath(context)
        CGContextAddArc(context, circlePaddingLeft + radius, center.y,radius, 0, CGFloat(M_PI*2.0), 0)
        CGContextDrawPath(context, kCGPathEOFillStroke)
        
        // Draw Badge
        let size = badge.sizeWithAttributes(attr)
        let rectText = CGRectMake(circlePaddingLeft + radius - size.width * 0.5, (self.bounds.size.height-size.height)*0.5, size.width, size.height)
        badge.drawInRect(rectText, withAttributes: attr)
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, circlePaddingLeft + radius * 2.0 + titlePaddingLeft, 0.0, 0.0)
        
        let titleAttribute = [NSFontAttributeName: titleFont as UIFont]
        let badgeWidth = self.titleLabel?.frame.width
        let titleSize = NSString(string:self.titleLabel!.text!).sizeWithAttributes(titleAttribute)
        
        _contentWidth = circlePaddingLeft + radius * 2.0 + titlePaddingLeft + badgeWidth!
    }
    
}
