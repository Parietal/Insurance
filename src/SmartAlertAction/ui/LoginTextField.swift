//
//  LoginTextField.swift
//  FlightCrew
//
//  Created by Paul Yuan on 2014-07-06.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class LoginTextField: UITextField
{
    
    @IBInspectable var paddingTop:CGFloat = 10
    @IBInspectable var paddingBottom:CGFloat = 10
    @IBInspectable var paddingLeft:CGFloat = 10
    @IBInspectable var paddingRight:CGFloat = 10
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = RAColors.LIGHT_GRAY
        self.textColor = UIColor.blackColor()
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsetsMake(paddingTop, paddingLeft, paddingBottom, paddingRight)
        let edges = UIEdgeInsetsInsetRect(bounds, padding)
        return super.textRectForBounds(edges)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsetsMake(paddingTop, paddingLeft, paddingBottom, paddingRight)
        let edges = UIEdgeInsetsInsetRect(bounds, padding)
        return super.editingRectForBounds(edges)
    }
    
}