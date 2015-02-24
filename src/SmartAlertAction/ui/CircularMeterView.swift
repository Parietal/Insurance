//
//  CircularMeterView.swift
//
//  Created by Ian Craigmile on 3/10/2014.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import QuartzCore
import UIKit

@IBDesignable
public class CircularMeterView: UIView {
    
    var numericLabel: UILabel!
    var currentRating: Int?
    
    @IBInspectable var lineWidth: Double = 10.0 {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable var textSize: Int = 40 {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable var rating: Int = 6 {
        didSet { updateLayerProperties() }
    }
    
    @IBInspectable var ringColor: UIColor = UIColor.blueColor() {
        didSet { updateLayerProperties() }
    }
    
    public override func layoutSubviews() {
        // resize ring layer
        // relayout numeric label
        //numericLabel?.center = CGPointMake(frame.width/2.0, frame.height/2.0)
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        let context = UIGraphicsGetCurrentContext()
        let path = CGPathCreateMutable()

        CGContextSetStrokeColorWithColor(context, ringColor.CGColor)
        CGContextSetLineWidth(context, CGFloat(lineWidth))

        let rectangle = CGRectInset(bounds, CGFloat(lineWidth/2.0), CGFloat(lineWidth/2.0))
        CGContextAddEllipseInRect(context, rectangle)
        CGContextDrawPath(context, kCGPathStroke)
        
        if (numericLabel == nil) {
            numericLabel = UILabel(frame: self.frame)
            self.addSubview(numericLabel)
            numericLabel.textAlignment = NSTextAlignment.Center
        }
        
        numericLabel.text = String(rating)
        numericLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(textSize))
        
        numericLabel.center = CGPointMake(frame.width/2.0, frame.height/2.0)
        
        //updateLayerProperties()
    }
    
    public func setRating(var rating: Int) {
        self.currentRating = rating
        self.rating = rating
        
        var newAlpha: CGFloat = CGFloat(CGFloat(rating)/10.0)
        var currentColor = self.ringColor.colorWithAlphaComponent(newAlpha)
        self.ringColor = currentColor
        
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        /*
        if ringLayer != nil {
        ringLayer.strokeEnd = CGFloat(rating)
        }
        */
        // force to redraw
        self.setNeedsDisplay()
    }
}
