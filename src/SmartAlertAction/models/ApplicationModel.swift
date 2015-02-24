//
//  ApplicationModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-04.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class ApplicationModel
{
    
    var id:Int = -1
    var client:PolicyInsuredClientModel?
    var submittedOn:NSDate?
    var status:PolicyStatusModel?
    var action:ActionModel?
    var policy:PolicyModel?
    
    init(id:Int, client:PolicyInsuredClientModel, submittedOn:NSDate, status:PolicyStatusModel, action:ActionModel, policy:PolicyModel)
    {
        self.id = id
        self.client = client
        self.submittedOn = submittedOn
        self.status = status
        self.action = action
        self.policy = policy
    }
    
}