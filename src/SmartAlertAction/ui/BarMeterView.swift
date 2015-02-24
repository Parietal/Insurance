//
//  BarMeterView.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/24/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

@IBDesignable class BarMeterView: UIView {

    @IBInspectable var max:UInt = 10 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var value:UInt = 3 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var paddingSpace:CGFloat = 2 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var barWidth:CGFloat = 30 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var textSize: Int = 16 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var text:String = "" {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var textPaddingSpace:CGFloat = 3 {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if max == 0{
            return
        }
        
        var newAlpha: CGFloat = CGFloat(CGFloat(value)/CGFloat(max))
        var currentColor = self.tintColor.colorWithAlphaComponent(newAlpha)
        
        let itemHeight = (CGFloat(self.bounds.height) - textPaddingSpace - 20) /  CGFloat(max) - paddingSpace
        let itemWidth = barWidth
        println("BarMeter graphicHeight:\(CGFloat(self.bounds.height) - textPaddingSpace - 20), graphicWidth:\(itemWidth)")
        assert(itemWidth <= self.bounds.width, "barWidth must not more than view's width")
        let context = UIGraphicsGetCurrentContext()
        let path = CGPathCreateMutable()
        let x:CGFloat = (self.bounds.width - itemWidth) / 2
        let xCenter:CGFloat = self.bounds.width / 2
        var yCenter:CGFloat = self.bounds.height
        let flip:CGFloat = -1.0
        for i in 0..<value {
            yCenter -= (itemHeight + paddingSpace)

            CGContextSetStrokeColorWithColor(context, currentColor.CGColor)
            CGContextSetLineWidth(context, 1.5)

            var rectangle = CGRectMake(x, yCenter, itemWidth, itemHeight)
            CGContextAddRect(context, rectangle)
            
            CGContextClosePath(context)
            CGContextSetFillColorWithColor(context, currentColor.CGColor)
            CGContextFillPath(context)
        }
        
        CGContextSetLineWidth(context, 1.0);
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        var t:NSString = text
        if t.length == 0 {
            t = String(value)
        }
        var font = UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!
        var attributes: [NSObject: AnyObject] = [NSFontAttributeName: font]

        var size = t.boundingRectWithSize(CGSizeMake(itemWidth, 0), options: NSStringDrawingOptions.TruncatesLastVisibleLine, attributes: attributes, context: nil)
        
        t.drawAtPoint(CGPointMake(xCenter - size.width / 2, yCenter - textPaddingSpace - size.height), withAttributes: attributes)
        
    }

}
