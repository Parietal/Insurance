//
//  TimeUtils.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-10-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class TimeUtils
{
    
    class func PerformAfterDelay(delayInSeconds:Float, completionHandler: () -> Void) {
        var delay:Int64 = Int64(Float(NSEC_PER_SEC) * delayInSeconds)
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delay)
        dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
            completionHandler()
        })
    }
    
}