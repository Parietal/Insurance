//
//  CustomTableViewHeaderFooterView.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/30/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class CustomTableViewHeaderFooterView: UITableViewHeaderFooterView {

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
    }
    
    //PHM added an overiide for subview to alter font.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if headerFont != nil{
            self.textLabel.font = headerFont
        }
    
    }

}
