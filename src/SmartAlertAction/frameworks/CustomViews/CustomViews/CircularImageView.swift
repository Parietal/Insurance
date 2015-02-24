//
//  CircularImageView.swift
//  SmallBusinessBanker
//
//  Created by Jeremy Koch on 9/23/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

@IBDesignable
public class CircularImageView: UIView {

    var backgroundRingLayer: CAShapeLayer!
    var imageLayer: CALayer!
    
    var DEFAULT_IMAGE:String = "profile_default"
    
    
    @IBInspectable public var image: UIImage? {
        didSet {
            updateLayoutProperties()
        }
    }
    
    //to convert from URL to UIImage
    public func setImageAsURL(imageURL: String) {
        
        if imageURL.hasPrefix("http") {
            //support URLS
            //TODO - for now just get the end of the URL
            var urlTokens:[String] = imageURL.componentsSeparatedByString("/")
            //println(urlTokens)
            var filenameTokens:[String] = urlTokens.last!.componentsSeparatedByString(".")
            println(filenameTokens)
            var imageName = filenameTokens.first
            if imageName != nil {
                self.image = UIImage(named: ("profile_\(imageName!)"))
            } else {
                self.image = UIImage(named: DEFAULT_IMAGE)
            }
        } else {
            //support plain filenames
            if !imageURL.isEmpty {
                self.image = UIImage(named: imageURL)
            } else {
                self.image = UIImage(named: DEFAULT_IMAGE)
            }
        }
      
    }
    
    
    override public func layoutSubviews() {
        if backgroundRingLayer == nil {
            backgroundRingLayer = CAShapeLayer()
            layer.addSublayer(backgroundRingLayer)
            
            let rect = bounds
            let path = UIBezierPath(ovalInRect: rect)
            backgroundRingLayer.path = path.CGPath
            
        }
        
        if imageLayer == nil {
            let imageMaskLayer = CAShapeLayer()
            let path = UIBezierPath(ovalInRect: bounds)
            
            imageMaskLayer.path = path.CGPath
            imageMaskLayer.fillColor = UIColor.blackColor().CGColor
            imageMaskLayer.frame = bounds
            layer.addSublayer(imageMaskLayer)
            
            imageLayer = CALayer()
            imageLayer.mask = imageMaskLayer
            imageLayer.frame = bounds
            imageLayer.backgroundColor = UIColor.lightGrayColor().CGColor
            imageLayer.contentsGravity = kCAGravityResizeAspectFill
            layer.addSublayer(imageLayer)
        }
        
        updateLayoutProperties()
    }
    
    func updateLayoutProperties() {
        
        if imageLayer != nil {
            if let i = image {
                imageLayer.contents = i.CGImage
            }
        }
    }
}
