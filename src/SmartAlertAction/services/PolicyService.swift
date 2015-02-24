//
//  PolicyService.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-08.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class PolicyService
{
    
    //retrieve the details for a policy
    class func getDetailsForPolicy(policyId:Int, completionHandler: (policy:PolicyModel?, error:NSError?) -> Void)
    {
        DataService.getDetailsForPolicy(policyId, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
        
            if json != nil && error == nil
            {
                var policy:PolicyModel = DataModelUtils.getPolicyFromJSON(json!)
                completionHandler(policy: policy, error: error)
            }
            else
            {
                completionHandler(policy: nil, error: error)
            }
            
        })
    }
    
    //retrieve all of the billings for a policy
    class func getBillingsForPolicy(policyId:Int, completionHandler: (billings:[PolicyBillingModel]?, error:NSError?) -> Void)
    {
        DataService.getBillingForPolicy(policyId, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            
            if jsonArray != nil && error == nil
            {
                var billings:[PolicyBillingModel] = [PolicyBillingModel]()
                for i in 0..<jsonArray!.count {
                    var data:NSDictionary = jsonArray![i] as NSDictionary
                    var billing:PolicyBillingModel = DataModelUtils.getPolicyBillingFromJSON(data)
                    billings.append(billing)
                }
                completionHandler(billings: billings, error: error)
            }
            else
            {
                completionHandler(billings: nil, error: error)
            }
            
        })
    }
    
    //retrieve all of the alerts for a policy
    class func getAlertsForPolicy(policyId:Int, completionHandler: (alerts:[AlertModel]?, error:NSError?) -> Void)
    {
        DataService.getAlertsForPolicy(policyId, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in

            if jsonArray != nil && error == nil
            {
                var alerts:[AlertModel] = [AlertModel]()
                for i in 0..<jsonArray!.count {
                    var data:NSDictionary = jsonArray![i] as NSDictionary
                    var alert:AlertModel = DataModelUtils.getAlertFromJSON(data)
                    alerts.append(alert)
                }
                completionHandler(alerts: alerts, error: error)
            }
            else
            {
                completionHandler(alerts: nil, error: error)
            }
            
        })
    }
    
}