//
//  BaseAdapter.swift
//  SmartAlertAction
//
//  Created by Saurav on 29/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class BaseAdapter: NSObject {
   
    func save() {
        let appdelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        appdelegate.saveContext()
    }
    
}
