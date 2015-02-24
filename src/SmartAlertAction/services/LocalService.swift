//
//  DataService.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-05.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class LocalService: NSObject
{
    
    //authenticate the user and receive the user's AgentModel in response
    class func login(username:String, password:String, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(0.1, completionHandler: {() -> Void in
            var json:NSDictionary = self._readLocalJSON("agent") as NSDictionary
            json.setValue("access_token", forKey: "1234567890")
            json.setValue("refresh_token", forKey: "0987654321")
            onDataHandler(json: json, error: nil)
        })
    }
    
    /////////////********************************************************/////////////
    //MARK: Alerts
    /////////////********************************************************/////////////
    
    //retrieve all the alerts for an agent by connecting to the data store
    class func getAllAlertsForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(0.1, completionHandler: {() -> Void in
            var jsonData:NSArray = self._readLocalJSON(dataFileSet.smartlistAlertsFile) as NSArray
            onDataHandler(jsonArray: jsonData, error: nil)
        })
    }
    
    //retrieve the complete details for an alert
    class func getDetailsForAlert(alertId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(0, completionHandler: {() -> Void in
            var jsonArray:NSArray = self._readLocalJSON(dataFileSet.alertDetailsFile) as NSArray
            if alertId < jsonArray.count {
                onDataHandler(json: jsonArray[alertId] as? NSDictionary, error: nil)
            } else {
                onDataHandler(json: nil, error: nil)
            }
        })
    }
    
    //retrieve the complete details for an alert
    class func getDetailsForAllAlert(alertId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(0, completionHandler: {() -> Void in
            var jsonData:NSArray = self._readLocalJSON(dataFileSet.alertDetailsFile) as NSArray
            onDataHandler(jsonArray: jsonData, error: nil)
        })
    }
    
    //mark an alert as complete, an AlertModel json is returned
    class func completeAlert(alertId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: placeholder method to read local json file for alert details
        self.getDetailsForAlert(0, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(json: json, error: error)
        })
    }
    
    //add a note to an alert, the AccountNoteModel is returned
    class func addNoteToAlert(alertId:Int, note:String, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(1, completionHandler: {() -> Void in
            var json:NSDictionary = self._readLocalJSON("note") as NSDictionary
            onDataHandler(json: json, error: nil)
        })
    }
    
    //postpone an alert, the AlertModel is returned
    class func postponeAlert(alertId:Int, date:String, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: placeholder method to read local json file for alert details
        self.getDetailsForAlert(0, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(json: json, error: error)
        })
    }
    
    //remove an array of alerts, the AlertModel's json is returned
    class func removeAlerts(alertIds:[Int], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        //TODO: placeholder method to read local json file for alert details
        self.getAllAlertsForAgent(0, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            onDataHandler(jsonArray: jsonArray, error: error)
        })
    }
    
    //delegate the alert to another agent, the AlertModel json is returned
    class func delegateAlert(alertId:Int, delegateId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: placeholder method to read local json file for alert details
        self.getDetailsForAlert(0, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(json: json, error: error)
        })
    }
    
    //Get finish title for finishing the alert
    class func finishTitles(clientId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        self._performAfterDelay(0.1, completionHandler: {() -> Void in
            var jsonData:NSArray = self._readLocalJSON("finishAlert") as NSArray
            onDataHandler(jsonArray: jsonData, error: nil)
        })
    }
    /////////////********************************************************/////////////
    //MARK: Clients
    /////////////********************************************************/////////////
    
    //retrieve all the clients for an agent by connecting to the data store
    class func getAllClientsForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(1, completionHandler: {() -> Void in
            var jsonData:NSArray = self._readLocalJSON(dataFileSet.clientsFile) as NSArray
            onDataHandler(jsonArray: jsonData, error: nil)
        })
    }
    
    //retrieve the complete details for a client
    class func getDetailsForClient(clientId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(1, completionHandler: {() -> Void in
            var jsonArray:NSArray = self._readLocalJSON(dataFileSet.clientDetailsFile) as NSArray
            let predicate_id:NSPredicate = NSPredicate(format: "id = %d", clientId)!
            jsonArray = jsonArray.filteredArrayUsingPredicate(predicate_id)
            
            if jsonArray.count > 0 {
                onDataHandler(json: jsonArray[0] as? NSDictionary, error: nil)
            } else {
                onDataHandler(json: nil, error: nil)
            }
           // println(jsonData)
        })
    }
    
    
    //This function gets details for multiple clients as array of NSDictionary this is needed to loop thru all clients and 
    // match it with reqd client id.
    class func getDetailsForAllClient(#onDataHandler: (json:[NSDictionary]?, error:NSError?) -> Void)
    {
        
        //TODO: add in service call to get data
        self._performAfterDelay(1, completionHandler: {() -> Void in
            var jsonData:[NSDictionary] = self._readLocalJSON(dataFileSet.clientDetailsFile) as [NSDictionary]
            onDataHandler(json: jsonData, error: nil)
          //  println(jsonData)
        })
    }
    
    //add a photo for a client, the ClientModel json is returned
    class func addPhotoForClient(clientId:Int, photo:String, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        self.getDetailsForClient(clientId, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(json: json, error: error)
        })
    }
    
    //add a payment for a client, the ClientModel json is returned
    class func addPaymentForClient(clientId:Int, payment:PaymentModel, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        self.getDetailsForClient(clientId, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(json: json, error: error)
        })
    }
    
    //search through the agent's clients list
    class func searchClients(keywords:[String], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        self.getAllClientsForAgent(0, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            onDataHandler(jsonArray: jsonArray, error: error)
        })
    }
    

    /////////////********************************************************/////////////
    //MARK: Policies
    /////////////********************************************************/////////////
    
    //retrieve the complete details for a policy
    class func getDetailsForPolicy(policyId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(0, completionHandler: {() -> Void in
            var jsonArray:NSArray = self._readLocalJSON(dataFileSet.policyDetailsFile) as NSArray
            
            //Sort jsonArray according to 'id', as in DataHandler value is fetched from jsonArray depending on its index
            // But this won't work on all situation, in future get dictionary via 'id' e.g. let predicate_id:NSPredicate = NSPredicate(format: "id = \(policyId)")!

            
            let predicate_id:NSPredicate = NSPredicate(format: "id = %d",policyId)!
            jsonArray = jsonArray.filteredArrayUsingPredicate(predicate_id)
            
            if(jsonArray.count > 0){
                onDataHandler(json: jsonArray[0] as? NSDictionary, error: nil)
            } else {
                onDataHandler(json: nil, error: nil)
            }
        })
    }
    
    //retrieve all of the billing associated with a policy
    class func getBillingForPolicy(policyId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(1, completionHandler: {() -> Void in
            var jsonArray:NSArray = self._readLocalJSON("billings") as NSArray
            onDataHandler(jsonArray: jsonArray, error: nil)
        })
    }
    
    //retrieve all of the alerts associated with a policy
    class func getAlertsForPolicy(policyId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        self.getAllAlertsForAgent(0, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            onDataHandler(jsonArray: jsonArray, error: error)
        })
    }
    
    /////////////********************************************************/////////////
    //MARK: Delegates
    /////////////********************************************************/////////////
    
    //retrieve the complete list of delegates
    class func getDelegatesForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(1, completionHandler: {() -> Void in
            var jsonData:NSArray = self._readLocalJSON("delegates") as NSArray
            onDataHandler(jsonArray: jsonData, error: nil)
        })
    }
    
    //retrieve the complete list of agents
    class func getDelegateCandidates(onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(1, completionHandler: {() -> Void in
            var jsonData:NSArray = self._readLocalJSON("agents") as NSArray
            onDataHandler(jsonArray: jsonData, error: nil)
        })
    }
    
    //replacement method for getDelegateCandidates to retrieve the complete list of agents
    class func getDelegateCandidates2(onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        self._performAfterDelay(0.1, completionHandler: {() -> Void in
            var jsonData:NSArray = self._readLocalJSON("all_agents") as NSArray
            onDataHandler(jsonArray: jsonData, error: nil)
        })
    }
    
    //add delegates for the user
    class func addDelegatesForAgent(agentId:Int, delegateIds:[Int], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        self.getDelegatesForAgent(agentId, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            onDataHandler(jsonArray: jsonArray, error: error)
        })
    }
    
    //remove delegates for the user
    class func removeDelegatesForAgent(agentId:Int, delegateIds:[Int], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        self.getDelegatesForAgent(agentId, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            onDataHandler(jsonArray: jsonArray, error: error)
        })
    }
    
    //Get Delegated Alerts of Logged In Agent
    class func getDetailsForDelegate(agentId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
        self._performAfterDelay(1, completionHandler: {() -> Void in
            var jsonData:NSDictionary = self._readLocalJSON("delegate") as NSDictionary
            onDataHandler(json: jsonData, error: nil)
        })
    }
    
    /////////////********************************************************/////////////
    //MARK: Categories
    /////////////********************************************************/////////////
    class func getCategoriesForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        self._performAfterDelay(1, completionHandler: {() -> Void in
            var jsonData:NSArray = self._readLocalJSON("categories") as NSArray
            onDataHandler(jsonArray: jsonData, error: nil)
        })
    }
    
    /////////////********************************************************/////////////
    //MARK: Utility functions
    /////////////********************************************************/////////////
    
    //delay to simulate network latency
    class func _performAfterDelay(delayInSeconds:Float, completionHandler: () -> Void)
    {
        var delay:Int64 = Int64(Float(NSEC_PER_SEC) * delayInSeconds)
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delay)
        dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
            completionHandler()
        })
    }
    
    //read local json file for data
    class func _readLocalJSON(fileName:String) -> AnyObject
    {
        var filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") as String?
        var raw:NSData? = NSData.dataWithContentsOfMappedFile(filePath!) as NSData?
//        var raw:NSData = NSData.dataWithContentsOfFile(filePath!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        var jsonData:AnyObject = NSJSONSerialization.JSONObjectWithData(raw!, options: NSJSONReadingOptions.MutableContainers, error: nil)!
        return jsonData
    }
    
}