//
//  PolicyBillingModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-11.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class PolicyBillingModel
{
    
    var id:Int = -1
    var billingDate:NSDate?
    var amount:Float = -1
    var dueDate:NSDate?
    var payment:Float = -1
    var receivedDate:NSDate?
    
    init(id:Int, billingDate:String, amount:Float, dueDate:String, payment:Float, receivedDate:String)
    {
        self.id = id
        self.billingDate = StringUtils.convertStringToDate(billingDate, timeString: "")
        self.amount = amount
        self.dueDate = StringUtils.convertStringToDate(dueDate, timeString: "")
        self.payment = payment
        self.receivedDate = StringUtils.convertStringToDate(receivedDate, timeString: "")
    }
    
}