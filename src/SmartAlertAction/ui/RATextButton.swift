//
//  FCTextButton.swift
//  FlightCrew
//
//  Created by Paul Yuan on 2014-07-06.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class RATextButton:UIButton
{
    
    var textColor:UIColor = RAColors.BLUE1  // Bruce ** Color Change
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.setTitleColor(textColor, forState: UIControlState.Normal)
        self.setTitleColor(textColor, forState: UIControlState.Selected)
    }
    
}