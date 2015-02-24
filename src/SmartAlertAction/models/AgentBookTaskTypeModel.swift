//
//  AgentBookTaskTypeModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class AgentBookTaskTypeModel
{
    
    var id:Int = -1
    var title:String = ""
    var pct:Float = -1
    
    init(id:Int, title:String, pct:Float) {
        self.id = id
        self.title = title
        self.pct = pct
    }
    
}