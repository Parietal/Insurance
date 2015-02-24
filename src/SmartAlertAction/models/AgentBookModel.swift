//
//  AgentBookModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class AgentBookModel
{
    
    var alertToActionRate:Float = -1
    var alertsPerDay:Int = -1
    var mostActiveAgent:Int = -1
    var taskTypes:[AgentBookTaskTypeModel] = [AgentBookTaskTypeModel]()
    var productTypes:[AgentBookProductTypeModel] = [AgentBookProductTypeModel]()
    var maxPolicyPremium:AlertAttributeModel?
    var maxPoliciesInHousehold:AlertAttributeModel?
    var maxYearsAsClient:AlertAttributeModel?
    
    init(alertToActionRate:Float, alertsPerDay:Int, mostActiveAgent:Int, taskTypes:[AgentBookTaskTypeModel], productTypes:[AgentBookProductTypeModel])
    {
        self.alertToActionRate = alertToActionRate
        self.alertsPerDay = alertsPerDay
        self.mostActiveAgent = mostActiveAgent
        self.taskTypes = taskTypes
        self.productTypes = productTypes
    }

    var maxPolicyPremiumValue: Double {
        get {
            var val:String? = maxPolicyPremium?.value.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
            if (val == nil) {
                return Double.NaN
            }
            return (val! as NSString).doubleValue
        }
    }

}