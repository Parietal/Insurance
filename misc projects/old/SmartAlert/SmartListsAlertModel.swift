//
//  SmartListsAlertModel.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation

class SmartListsAlertModel:NSObject
{
    
    var id:String = ""
    var title:String = ""
    var body:String = ""
    var date:String = ""
    var isPastDue:Bool = false
    
    init(id:String, title:String, body:String, date:String, isPastDue:Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
        self.isPastDue = isPastDue
    }
    
}