//
//  FCBlueButton.swift
//  FlightCrew
//
//  Created by Paul Yuan on 2014-07-06.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class RABlueButton:UIButton
{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0
        self.backgroundColor = RAColors.BLUE1  // Bruce ** Color Change
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
    }
    
}