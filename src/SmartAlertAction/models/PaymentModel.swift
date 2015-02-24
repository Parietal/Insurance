//
//  PaymentModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-15.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class PaymentModel
{
    
    enum TYPE : Int {
        case CREDIT_CARD, CHECK
    }
    
    var policyId:Int = -1
    var amount:Float = -1
    var type:Int = -1
    var name:String = ""
    var ccNumber:String = ""
    var ccSecurityCode:String = ""
    var ccExpiryDate:String = ""
    var consent:Bool = true
    var checkRoutingNumber:String = ""
    var checkAccountNumber:String = ""
    
    init(policyId:Int, amount:Float, type:Int, name:String, ccNumber:String, ccSecurityCode:String, ccExpiryDate:String, consent:Bool, checkRoutingNumber:String, checkAccountNumber:String)
    {
        self.policyId = policyId
        self.amount = amount
        self.type = type
        self.name = name
        self.ccNumber = ccNumber
        self.ccSecurityCode = ccSecurityCode
        self.ccExpiryDate = ccExpiryDate
        self.consent = consent
        self.checkRoutingNumber = checkRoutingNumber
        self.checkAccountNumber = checkAccountNumber
    }
    
}