//
//  PolicyDetailsItemModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-12.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class PolicyDetailsItemModel
{
    
    var name:String = ""
    var value:String = ""
    var iPadOnly:Bool = false
    
    init(name:String, value:String, iPadOnly:Bool) {
        self.name = name
        self.value = value
        self.iPadOnly = iPadOnly
    }
    
}