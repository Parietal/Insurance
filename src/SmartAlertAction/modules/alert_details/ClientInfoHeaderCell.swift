//
//  ClientInfoHeaderCell.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-11-20.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class ClientInfoHeaderCell:UIView
{
    
    var textLabel:UILabel = UILabel()
    
    var topSeparatorColor: UIColor? {
        didSet {
            println("topSeparatorColor=\(topSeparatorColor)")
            setNeedsDisplay()
        }
    }
    var bottomSeparatorColor: UIColor? {
        didSet {
            println("bottomSeparatorColor=\(bottomSeparatorColor)")
            setNeedsDisplay()
        }
    }
    
    var headerFont: UIFont? {
        didSet {
            println("headerFont=\(headerFont)")
        }
    }
    
    var paddingLeft: CGFloat = 20 {
        didSet {
            self.positionTextLabel()
        }
    }
    
    var paddingRight: CGFloat = 20 {
        didSet {
            self.positionTextLabel()
        }
    }
    
    var paddingTop: CGFloat = 0 {
        didSet {
            self.positionTextLabel()
        }
    }
    
    var paddingBottom:CGFloat = 0 {
        didSet {
            self.positionTextLabel()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init() {
        super.init()
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    private func initialize() {
        //default background color
        self.backgroundColor = RAColors.GRAY2
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        
        // top separate line
        if topSeparatorColor != nil {
            println("draw topSeparator")
            //PHM Needed to add a subview to have lines draw
            var topSeparatorView : UIView = UIView( frame: CGRectMake(0, 0, rect.size.width, 0.5))
            topSeparatorView.backgroundColor = topSeparatorColor
            self.addSubview(topSeparatorView)
            //CGContextSetStrokeColorWithColor(context, topSeparatorColor?.CGColor)
            //CGContextStrokeRect(context, CGRectMake(5, 0, rect.size.width - 10, 1))
        }
        
        // bottom separate line
        if bottomSeparatorColor != nil {
            println("draw bottomSeparator")
            //PHM Needed to add a subview to have lines draw
            var bottomSeparatorView : UIView = UIView( frame: CGRectMake(0, rect.size.height - 1, rect.size.width, 0.5))
            bottomSeparatorView.backgroundColor = topSeparatorColor
            self.addSubview(bottomSeparatorView)
            
            //CGContextSetStrokeColorWithColor(context, bottomSeparatorColor?.CGColor)
            //CGContextStrokeRect(context, CGRectMake(5, rect.size.height - 1, rect.size.width - 10, 1))
        }
        
        self.addSubview(self.textLabel)
        self.positionTextLabel()
    }
    
    //PHM added an overiide for subview to alter font.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if headerFont != nil{
            self.textLabel.font = headerFont
        }
        
    }
    
    private func positionTextLabel() {
        self.textLabel.frame = CGRectMake(self.paddingLeft, self.paddingTop, self.frame.width-self.paddingRight, self.frame.height-self.paddingBottom)
    }
    
}