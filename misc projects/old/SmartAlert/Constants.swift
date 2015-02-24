//
//  Constants.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation

class Constants:NSObject
{
    
    /**** data constants ****/
    class func DEFAULT_ALERT_ID() -> String { return "0" }
    
    /**** notification constants ****/
    class func NOTIFICATION_CATEGORY_DEFAULT() -> String { return "default" }
    class func NOTIFICATION_ACTION_ID_CALL() -> String { return "callActionId" }
    class func NOTIFICATION_ACTION_ID_EMAIL() -> String { return "emailActionId" }
    
}