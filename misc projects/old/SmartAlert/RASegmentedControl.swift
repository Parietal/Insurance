//
//  RASegmentedControl.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class RASegmentedControl:UISegmentedControl
{
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.tintColor = RAColors.LIGHT_BLUE()
        
        //set font
        var attributes:NSDictionary = NSDictionary(objects: [UIFont.boldSystemFontOfSize(14)], forKeys: [NSFontAttributeName])
        self.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
    }
    
}