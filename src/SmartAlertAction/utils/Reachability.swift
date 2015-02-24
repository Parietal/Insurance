//
//  Reachability.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/6/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import SystemConfiguration

enum NetworkStatus : NSInteger {
    case NotReachable = 0
    case ReachableViaWiFi
    case ReachableViaWWAN
    //case ReachableVia2G
    //case ReachableVia3G
}


let kReachabilityChangedNotification : NSString = "kNetworkReachabilityChangedNotification"

// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
let IN_LINKLOCALNETNUM = Int64(0xA9FE0000)

//MARK: - Supporting functions

let kShouldPrintReachabilityFlags = true

func PrintReachabilityFlags(flags : SCNetworkReachabilityFlags, comment : String)
{
    #if kShouldPrintReachabilityFlags
        
        println("Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
        (flags & UInt32(kSCNetworkReachabilityFlagsIsWWAN)) != 0               ? "W" : "-",
        (flags & UInt32(kSCNetworkReachabilityFlagsReachable)) != 0            ? "R" : "-",
        
        (flags & UInt32(kSCNetworkReachabilityFlagsTransientConnection)) != 0  ? "t" : "-",
        (flags & UInt32(kSCNetworkReachabilityFlagsConnectionRequired)) != 0   ? "c" : "-",
        (flags & UInt32(kSCNetworkReachabilityFlagsConnectionOnTraffic)) != 0  ? "C" : "-",
        (flags & UInt32(kSCNetworkReachabilityFlagsInterventionRequired)) != 0 ? "i" : "-",
        (flags & UInt32(kSCNetworkReachabilityFlagsConnectionOnDemand)) != 0   ? "D" : "-",
        (flags & UInt32(kSCNetworkReachabilityFlagsIsLocalAddress)) != 0       ? "l" : "-",
        (flags & UInt32(kSCNetworkReachabilityFlagsIsDirect)) != 0             ? "d" : "-",
        comment
        );
    #endif
}

//MARK: - Reachability implementation

class Reachability : NSObject
{
    
    var _alwaysReturnLocalWiFiStatus : Bool = false //default is NO
    var _reachabilityRef : SCNetworkReachability!
    
    /*!
    * Use to check the reachability of a given host name.
    */
    class func reachabilityWithHostName(hostName : String) -> Reachability!
    {
        var returnValue: Reachability!
        let reachability = SCNetworkReachabilityCreateWithName(nil, hostName).takeRetainedValue() as SCNetworkReachability!
        
        if reachability != nil
        {
            returnValue = Reachability()
            if returnValue != nil
            {
                returnValue._reachabilityRef = reachability
                returnValue._alwaysReturnLocalWiFiStatus = false
            }
        }
        return returnValue
    }
    
    /*!
    * Use to check the reachability of a given IP address.
    */
    class func reachabilityWithAddress(inout hostAddress : sockaddr_in) -> Reachability!
    {
        var returnValue: Reachability!
        let reachability = withUnsafePointer(&hostAddress) { (sockaddr_in: UnsafePointer<sockaddr_in>) -> SCNetworkReachability! in
            return SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer(sockaddr_in)).takeRetainedValue()
        }
        
        if reachability != nil
        {
            returnValue = Reachability()
            if returnValue != nil
            {
                returnValue._reachabilityRef = reachability
                returnValue._alwaysReturnLocalWiFiStatus = false
            }
        }
        return returnValue
    }
    
    /*!
    * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
    */
    class func reachabilityForInternetConnection() -> Reachability!
    {
        var zeroAddress = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        return self.reachabilityWithAddress(&zeroAddress)
    }
    
    /*!
    * Checks whether a local WiFi connection is available.
    */
    class func reachabilityForLocalWiFi() -> Reachability!
    {
        var localWifiAddress = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        localWifiAddress.sin_len = UInt8(sizeofValue(localWifiAddress))
        localWifiAddress.sin_family = sa_family_t(AF_INET)
        
        // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
        localWifiAddress.sin_addr.s_addr = in_addr_t(IN_LINKLOCALNETNUM)
        
        var returnValue = self.reachabilityWithAddress(&localWifiAddress)
        
        if returnValue != nil
        {
            returnValue._alwaysReturnLocalWiFiStatus = true
        }
        
        return returnValue;
    }
    
    //MARK: - Network Flag Handling
    
    func localWiFiStatusForFlags(flags : SCNetworkReachabilityFlags) -> NetworkStatus
    {
        PrintReachabilityFlags(flags, "localWiFiStatusForFlags")
        var returnValue : NetworkStatus = .NotReachable
        
        if (flags & UInt32(kSCNetworkReachabilityFlagsReachable) != 0 && (flags & UInt32(kSCNetworkReachabilityFlagsIsDirect)) != 0)
        {
            returnValue = .ReachableViaWiFi
        }
        
        return returnValue
    }
    
    
    func networkStatusForFlags(flags : SCNetworkReachabilityFlags) -> NetworkStatus
    {
        PrintReachabilityFlags(flags, "networkStatusForFlags");
        if ((flags & UInt32(kSCNetworkReachabilityFlagsReachable)) == 0)
        {
            // The target host is not reachable.
            return .NotReachable
        }
        
        var returnValue : NetworkStatus = .NotReachable
        
        if ((flags & UInt32(kSCNetworkReachabilityFlagsConnectionRequired)) == 0)
        {
            /*
            If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
            */
            returnValue = .ReachableViaWiFi
        }
        
        if ((((flags & UInt32(kSCNetworkReachabilityFlagsConnectionOnDemand)) != 0) ||
            (flags & UInt32(kSCNetworkReachabilityFlagsConnectionOnTraffic)) != 0))
        {
            /*
            ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
            */
            
            if ((flags & UInt32(kSCNetworkReachabilityFlagsInterventionRequired)) == 0)
            {
                /*
                ... and no [user] intervention is needed...
                */
                returnValue = .ReachableViaWiFi
            }
        }
        
        if ((flags & UInt32(kSCNetworkReachabilityFlagsIsWWAN)) == UInt32(kSCNetworkReachabilityFlagsIsWWAN))
        {
            /*
            ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
            */
            returnValue = .ReachableViaWWAN
        }
        
        return returnValue
    }
    
    func currentReachabilityStatus() -> NetworkStatus
    {
        //NSAssert(_reachabilityRef != NULL, @"currentNetworkStatus called with NULL SCNetworkReachabilityRef");
        var returnValue : NetworkStatus = .NotReachable
        var flags : SCNetworkReachabilityFlags = 0
        
        if SCNetworkReachabilityGetFlags(_reachabilityRef, &flags) != 0
        {
            if (_alwaysReturnLocalWiFiStatus)
            {
                returnValue = self.localWiFiStatusForFlags(flags)
            }
            else
            {
                returnValue = self.networkStatusForFlags(flags)
            }
        }
        
        return returnValue;
    }
    
    /*!
    * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
    */
    func connectionRequired() -> Bool
    {
        //NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
        var flags : SCNetworkReachabilityFlags = 0
        
        if SCNetworkReachabilityGetFlags(_reachabilityRef, &flags) != 0
        {
            return (flags & UInt32(kSCNetworkReachabilityFlagsConnectionRequired)) == UInt32(kSCNetworkReachabilityFlagsConnectionRequired)
        }
        
        return false
    }
    
}