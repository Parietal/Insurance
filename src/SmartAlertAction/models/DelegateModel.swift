//
//  DelegateModel.swift
//  DelegateAlerts
//
//  Created by Saurav on 16/10/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit

class DelegateModel: NSObject {

    var name = ""
    var details:[DelegateDetailModel]
    
    init(name:String, details:[DelegateDetailModel])
    {
        self.name = name
        self.details = details
    }

}
