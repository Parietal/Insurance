//
//  FCSwitch.swift
//  FlightCrew
//
//  Created by Paul Yuan on 2014-07-06.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class RASwitch:UISwitch
{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.onTintColor = RAColors.BLUE1  // Bruce ** Color Change
    }
    
}