//
//  AppUtils.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/5/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AppUtils:NSObject
{
    
    //handle unimplemented functionalities
    class func handleUnimplementedFunctionalities(alertDelegate:AnyObject)
    {
        /*
        var alert = UIAlertController(title: Constants.ALERT_TITLE(), message: Constants.ALERT_LOGIN_FUNCTION_NOT_IMPLEMENTED_MSG(),
        preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: Constants.ALERT_BUTTON_OK(), style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        */
        let alert = UIAlertView()
        alert.title = Constants.ALERT_TITLE
        alert.delegate = alertDelegate
        alert.message = Constants.ALERT_LOGIN_FUNCTION_NOT_IMPLEMENTED_MSG
        alert.addButtonWithTitle(Constants.ALERT_BUTTON_OK)
        alert.show()
    }
    
    class func handleNetworkIssue(alertDelegate:AnyObject?) {
        let alert = UIAlertView()
        alert.title = Constants.ALERT_TITLE
        alert.delegate = alertDelegate
        alert.message = Constants.ALERT_NETWORK_ERROR_MSG
        alert.addButtonWithTitle(Constants.ALERT_BUTTON_OK)
        alert.show()
    }

}