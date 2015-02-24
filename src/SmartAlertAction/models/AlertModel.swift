//
//  AlertModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-08-29.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class AlertModel
{
    
    var id:Int = -1
    var category:AlertCategoryModel?
    var message:String = ""
    var actions:[ActionModel] = [ActionModel]()
    var date:NSDate?
    var isCompleted:Bool = false
    var client:ClientModel?
    var policy:PolicyModel?
    var rank:Int? = 3
    var alertRecommendation:RecommendationModel?
    var salesRecommendation:RecommendationModel?
    var policyPremium:AlertAttributeModel?
    var policiesInHousehold:AlertAttributeModel?
    var yearsAsClient:AlertAttributeModel?
    
    init(id:Int, category:AlertCategoryModel, message:String, actions:[ActionModel], dateString:String, timeString:String, isCompleted:Bool, client:ClientModel?, policy:PolicyModel?)
    {
        self.id = id
        self.category = category
        self.message = message
        self.actions = actions
        self.date = StringUtils.convertStringToDate(dateString, timeString: timeString)
        self.isCompleted = isCompleted
        self.client = client
        self.policy = policy
    }
    
    var trimedMessage: String {
        get {
            // max to 150
            return StringUtils.trimStringToLimit(self.message, limit: 150)
        }
    }
    
    var displayActions: String? {
        get {
            var actionString = ""
            for action in self.actions {
                if actionString != "" { actionString += "," }
                actionString += action.title
            }
            if actionString == "" {
                return nil
            } else {
                return "Action Taken - " + actionString
            }
        }
    }
    
    var policyPremiumValue: Double {
        get {
            var val:String? = policyPremium?.value.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
            if (val == nil) {
                return Double.NaN
            }
            return (val! as NSString).doubleValue
        }
    }
}