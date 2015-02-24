//
//  FCBoldTextButtonWhite.swift
//  FlightCrew
//
//  Created by Paul Yuan on 2014-07-06.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class RABoldTextButtonWhite:RABoldTextButton
{
    
    override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textColor = UIColor.whiteColor()
    }
    
}