//
//  PolicyModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class PolicyModel
{
    
    var id:Int = -1
    var policyId:String = ""
    var type:PolicyTypeModel?
    var details:[PolicyDetailsGroupModel]?
    
    init(id:Int, policyId:String, type:PolicyTypeModel, details:[PolicyDetailsGroupModel]?)
    {
        self.id = id
        self.policyId = policyId
        self.type = type
        self.details = details
    }
    
}