//
//  AlertDetailsModel.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation

class AlertDetailsModel:NSObject
{
    
    var date:String = ""
    var client:String = ""
    var age:Int = -1
    var phone:String = ""
    var email:String = ""
    var title:String = ""
    var message:String = ""
    var policy:String = ""
    var recommendedActions:String = ""
    
    init(date:String, client:String, age:Int, phone:String, email:String, title:String, message:String, policy:String, recommendedActions:String) {
        self.date = date
        self.client = client
        self.age = age
        self.phone = phone
        self.email = email
        self.title = title
        self.message = message
        self.policy = policy
        self.recommendedActions = recommendedActions
    }
    
}