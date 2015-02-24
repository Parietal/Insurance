//
//  DelegateDetailModel.swift
//  DelegateAlerts
//
//  Created by Saurav on 16/10/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit

class DelegateDetailModel: NSObject {
   
    var desc = ""
    var clientName = ""
    var delegateAgent = ""
    var rank:Int = 0
    
    init(desc:String, clientName:String, delegateAgent:String, rank:Int)
    {
        self.desc = desc
        self.clientName = clientName
        self.delegateAgent = delegateAgent
        self.rank = rank
    }
}
