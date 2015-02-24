//
//  ActionModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-08-29.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class ActionModel
{
    
    var id:Int = -1
    var title:String = ""
    var platforms:[Int]?
    
    init(id:Int, title:String, platforms:[Int]?) {
        self.id = id
        self.title = title
        self.platforms = platforms
    }
    
}