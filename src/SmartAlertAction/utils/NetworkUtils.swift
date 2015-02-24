//
//  NetworkUtils.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/30/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

let blumixReachability = Reachability.reachabilityWithHostName(Constants.INSURANCE_SERVER_URL_HOSTNAME)

class NetworkUtils
{

    class func isOnline() -> Bool
    {
        return false
        // check network
        //return (blumixReachability.currentReachabilityStatus() != NetworkStatus.NotReachable)
    }
    
}