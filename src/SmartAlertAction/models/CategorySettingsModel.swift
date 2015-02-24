//
//  CategorySettingsModel.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/12/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class CategorySettingsModel {

    var receiveNotification:Bool = true
    
    init(receiveNotification:Bool) {
        self.receiveNotification = receiveNotification
    }
    
}
