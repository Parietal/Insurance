//
//  AlertService.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-05.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
// comment
class AlertService
{
    
    //retrieve collection of AlertModels for the smartlist
    //AlertModels do not have all the details filled in
    class func getAllForAgent(agentId:Int, completionHandler: (alerts:[AlertModel]?, error:NSError?) -> Void)
    {
        DataService.getAllAlertsForAgent(agentId, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            
            if jsonArray != nil && error == nil
            {
                var alerts:[AlertModel] = [AlertModel]()
                for i in 0..<jsonArray!.count
                {
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
    
    //retrieve the details for an alert
    //completion handler block will receive a AlertModel with all properties filled in
    class func getDetailsForAlert(alertId:Int, completionHandler: (alert:AlertModel?, error:NSError?) -> Void)
    {
        DataService.getDetailsForAlert(alertId, onDataHandler: {(json:NSDictionary?, error:NSError?) ->Void in
            
            if json != nil && error == nil
            {
                var alert:AlertModel = DataModelUtils.getAlertFromJSON(json!)
                completionHandler(alert: alert, error: error)
            }
            else
            {
                completionHandler(alert: nil, error: error)
            }
            
        })
    }
    
    class func getDetailsForAllAlert(alertId:Int, completionHandler: (alerts:[AlertModel]?, error:NSError?) -> Void)
    {
        DataService.getDetailsForAllAlert(alertId, onDataHandler: {(jsonArray:NSArray?, error:NSError?) ->Void in
            
            if jsonArray != nil && error == nil
            {
                var alerts:[AlertModel] = DataModelUtils.getAllAlertFromJSON(jsonArray!)
                completionHandler(alerts: alerts, error: error)
            }
            else
            {
                completionHandler(alerts: nil, error: error)
            }
            
        })
    }
    //mark an alert as complete
    //completion handler block will receive a AlertModel
    class func completeAlert(alertId:Int, completionHandler: (alert:AlertModel?, error:NSError?) -> Void)
    {
        DataService.completeAlert(alertId, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            
            if json != nil && error == nil
            {
                var alert:AlertModel = DataModelUtils.getAlertFromJSON(json!)
                completionHandler(alert: alert, error: error)
            }
            else
            {
                completionHandler(alert: nil, error: error)
            }
            
        })
    }
    
    //add a note for an alert
    //completion handler block will receive an AccountNoteModel
    class func addNoteToAlert(alertId:Int, note:String, completionHandler: (accountNote:AccountNoteModel?, error:NSError?) -> Void)
    {
        DataService.addNoteToAlert(alertId, note: note, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
        
            if json != nil && error == nil
            {
                var note:AccountNoteModel = DataModelUtils.getAccountNoteFromJSON(json!)
                completionHandler(accountNote: note, error: error)
            }
            else
            {
                completionHandler(accountNote: nil, error: error)
            }
        
        })
    }
    
    //postpone an alert
    //completion handler block will receive an AlertModel
    class func postponeAlert(alertId:Int, date:NSDate, completionHandler: (alert:AlertModel?, error:NSError?) -> Void)
    {
        var dateString = StringUtils.convertDateToString(date, format: "")
        DataService.postponeAlert(alertId, date: dateString, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            
            if json != nil && error == nil
            {
                var alert:AlertModel = DataModelUtils.getAlertFromJSON(json!)
                completionHandler(alert: alert, error: error)
            }
            else
            {
                completionHandler(alert: nil, error: error)
            }

        })
    }
    
    //remove alerts for an agent
    //completion handler block will receive an array of AlertModels
    class func removeAlerts(alertIds:[Int], completionHandler: (alerts:[AlertModel]?, error:NSError?) -> Void)
    {
        DataService.removeAlerts(alertIds, onDataHandler: {(json:NSArray?, error:NSError?) -> Void in

            if json != nil && error == nil
            {
                var alerts:[AlertModel] = [AlertModel]()
                for i in 0..<json!.count {
                    var data:NSDictionary = json![i] as NSDictionary
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
    
    //delegate the alert to another agent
    //completion handler block will receive an AlertModel
    class func delegateAlert(alertId:Int, delegateId:Int, completionHandler: (alert:AlertModel?, error:NSError?) -> Void)
    {
        DataService.delegateAlert(alertId, delegateId: delegateId, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            
            if json != nil && error == nil
            {
                var alert:AlertModel = DataModelUtils.getAlertFromJSON(json!)
                completionHandler(alert: alert, error: error)
            }
            else
            {
                completionHandler(alert: nil, error: error)
            }

        })
    }
    //Get finish title for finishing the alert
    class func finishTitles(alertId:Int, completionHandler: (finishTitle:[FinishTitlesModel]?, error:NSError?) -> Void)
    {
        DataService.finishTitles(alertId, onDataHandler: {(json:NSArray?, error:NSError?) -> Void in
            
            if json != nil && error == nil
            {
                var finishTitle:[FinishTitlesModel] = DataModelUtils.getFinishTitlesFromJSON(json!)
                completionHandler(finishTitle: finishTitle, error: error)
            }
            else
            {
                completionHandler(finishTitle: nil, error: error)
            }
            
        })
    }
    

}