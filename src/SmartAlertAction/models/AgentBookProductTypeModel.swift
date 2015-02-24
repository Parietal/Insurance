//
//  AgentBookProductTypeModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class AgentBookProductTypeModel
{
    
    var id:Int = -1
    var title:String = ""
    var value:Float = -1
    var numAccounts:Int = -1
    
    init(id:Int, title:String, value:Float, numAccounts:Int) {
        self.id = id
        self.title = title
        self.value = value
        self.numAccounts = numAccounts
    }
    
}