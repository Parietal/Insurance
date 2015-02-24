//
//  DataUtils.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation

class DataUtils:NSObject
{
    
    class func JSON_FILE_EXTENSION() -> String { return "json" }
    
    //get smartlists alerts
    class func getSmartListsAlerts() -> [SmartListsAlertModel]
    {
        var filePath = NSBundle.mainBundle().pathForResource("smartlists", ofType: JSON_FILE_EXTENSION())
        var raw:NSData = NSData.dataWithContentsOfFile(filePath!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        var jsonData:NSArray = NSJSONSerialization.JSONObjectWithData(raw, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
        
        var alerts:[SmartListsAlertModel] = [SmartListsAlertModel]()
        for i in 0..<jsonData.count {
            var data:NSDictionary = jsonData[i] as NSDictionary
            var alert:SmartListsAlertModel = _parseSmartListsAlertsJSON(data)
            alerts.append(alert)
        }
        
        return alerts
    }
    
    //get the details for an alert
    class func getAlertDetails(alertId:String) -> AlertDetailsModel
    {
        var filePath:String = _validateAlertDetailsPath(alertId, fileName: "alert_details_")
        var raw:NSData = NSData.dataWithContentsOfFile(filePath, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        var jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(raw, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var alert:AlertDetailsModel = _parseAlertDetailsJSON(jsonData)
        return alert
    }
    
    //convert json to SmartListsAlertModel object
    class func _parseSmartListsAlertsJSON(data:NSDictionary) -> SmartListsAlertModel
    {
        var id:Int = data.valueForKey("id") as Int
        var title:String = data.valueForKey("title") as String
        var body:String = data.valueForKey("body") as String
        var date:String = data.valueForKey("date") as String
        var isPastDue:Bool = data.valueForKey("isPastDue") as Bool
        var alert:SmartListsAlertModel = SmartListsAlertModel(id: id.description, title: title, body: body, date: date, isPastDue: isPastDue)
        return alert
    }
    
    //convert json to AlertDetailsModel object
    class func _parseAlertDetailsJSON(data:NSDictionary) -> AlertDetailsModel
    {
        var date:String = data.valueForKey("date") as String
        var client:String = data.valueForKey("client") as String
        var age:Int = data.valueForKey("age") as Int
        var phone:String = data.valueForKey("phone") as String
        var email:String = data.valueForKey("email") as String
        var title:String = data.valueForKey("title") as String
        var message:String = data.valueForKey("message") as String
        var policy:String = data.valueForKey("policy") as String
        var recommendedActions:String = data.valueForKey("recommended_actions") as String
        var alert:AlertDetailsModel = AlertDetailsModel(date: date, client: client, age: age, phone: phone, email: email, title: title, message: message, policy: policy, recommendedActions: recommendedActions)
        return alert
    }
    
    //if file does not exist, use default alert details
    class func _validateAlertDetailsPath(alertId:String, fileName:String) -> String {
        var jsonFileName:String = fileName + alertId
        var filePath:String? = NSBundle.mainBundle().pathForResource(jsonFileName, ofType: JSON_FILE_EXTENSION())
        
        var fileExists:Bool = NSFileManager.defaultManager().fileExistsAtPath(filePath!)
        if !fileExists {
            jsonFileName = Constants.DEFAULT_ALERT_ID() + fileName
            filePath = NSBundle.mainBundle().pathForResource(jsonFileName, ofType: JSON_FILE_EXTENSION())
        }
        
        return filePath!
    }
    
}