//
//  StarRatingView.swift
//  Rating
//
//  Created by Saurav on 14/10/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit

@IBDesignable class DiamondRatingView: UIView {

    @IBInspectable var max:UInt = 5 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var rate:UInt = 3 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var paddingSpace:CGFloat = 2 {
        didSet { setNeedsDisplay() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        tintColor = UIColor.darkGrayColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if max == 0{
            return
        }
        
        let itemWidth = CGFloat(self.bounds.width) /  CGFloat(max) - paddingSpace
        let itemHeight = itemWidth
        assert(itemHeight <= self.bounds.size.height, "item's height must not more than view's height")
        let context = UIGraphicsGetCurrentContext()
        let path = CGPathCreateMutable()
        let r = itemWidth / 2
        var xCenter = r + 1
        let yCenter = r + 1
        let flip:CGFloat = -1.0
        for i in 0..<max {
            CGContextSetStrokeColorWithColor(context, tintColor.CGColor)
            CGContextSetLineWidth(context, 1.5)
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, xCenter, yCenter - r)
            let theta:CGFloat = CGFloat(2.0 * M_PI * (1.0 / 4.0))
            for k in 1..<5 {
                let x = r * sin(CGFloat(k) * theta)
                let y = r * cos(CGFloat(k) * theta)
                CGContextAddLineToPoint(context, x+xCenter, y*flip+yCenter)
            }
            CGContextClosePath(context)
            if i < rate {
                //draw hightlight color
                CGContextSetFillColorWithColor(context, tintColor.CGColor)
                CGContextFillPath(context)

                CGContextBeginPath(context)
                CGContextMoveToPoint(context, xCenter, yCenter - r)
                let theta:CGFloat = CGFloat(2.0 * M_PI * (1.0 / 4.0))
                for k in 1..<5 {
                    let x = r * sin(CGFloat(k) * theta)
                    let y = r * cos(CGFloat(k) * theta)
                    CGContextAddLineToPoint(context, x+xCenter, y*flip+yCenter)
                }
                CGContextClosePath(context)
                CGContextStrokePath(context)
            } else {
                //draw normal star color
                CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
                CGContextStrokePath(context)
            }
            
            xCenter = itemWidth + xCenter + paddingSpace;
        }
        
    }
}
