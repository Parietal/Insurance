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
    
    var ringLayer: CAShapeLayer!
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
        ringLayer?.frame = layer.bounds
        // relayout numeric label
        numericLabel?.center = CGPointMake(frame.width/2.0, frame.height/2.0)
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if (ringLayer == nil) {
            ringLayer = CAShapeLayer()
            layer.addSublayer(ringLayer)
        }
        let rect = CGRectInset(bounds, CGFloat(lineWidth/2.0), CGFloat(lineWidth/2.0))
        let path = UIBezierPath(ovalInRect: rect)
        
        ringLayer.path = path.CGPath
        ringLayer.fillColor = nil
        ringLayer.lineWidth = CGFloat(lineWidth)
        ringLayer.strokeColor = ringColor.CGColor
        ringLayer.anchorPoint = CGPointMake(0.5, 0.5)
        
        ringLayer.frame = layer.bounds
        
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
