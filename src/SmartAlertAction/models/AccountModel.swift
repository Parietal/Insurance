//
//  PaymentDetailModel.swift
//  SmartAlertAction
//
//  Created by Saurav on 22/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AccountModel {
 
    var amountDue:Double = 0
    var remainingBalance:Double = 0
    var currency:String = ""
    
    init(amountDue:Double, remainingBalance:Double, currency:String)
    {
        self.amountDue = amountDue
        self.remainingBalance = remainingBalance
        self.currency = currency
    }
}
