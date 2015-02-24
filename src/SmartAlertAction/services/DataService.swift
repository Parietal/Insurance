//
//  DataService.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/30/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class DataService
{
    
    //authenticate the user and receive the user's AgentModel in response
    class func login(username:String, password:String, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.login(username, password: password, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.login(username, password: password, onDataHandler: onDataHandler)
        }
    }
    
    /////////////********************************************************/////////////
    ///////////// Alerts
    /////////////********************************************************/////////////
    
    //retrieve all the alerts for an agent by connecting to the data store
    class func getAllAlertsForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getAllAlertsForAgent(agentId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getAllAlertsForAgent(agentId, onDataHandler: onDataHandler)
        }
    }
    
    //retrieve the complete details for an alert
    class func getDetailsForAlert(alertId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getDetailsForAlert(alertId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getDetailsForAlert(alertId, onDataHandler: onDataHandler)
        }
    }

    //retrieve the complete details for an all alert
    class func getDetailsForAllAlert(alertId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        LocalService.getDetailsForAllAlert(alertId, onDataHandler: onDataHandler)
    }
    
    //mark an alert as complete, an AlertModel json is returned
    class func completeAlert(alertId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.completeAlert(alertId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.completeAlert(alertId, onDataHandler: onDataHandler)
        }
    }
    
    //add a note to an alert, the AccountNoteModel is returned
    class func addNoteToAlert(alertId:Int, note:String, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.addNoteToAlert(alertId, note: note, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.addNoteToAlert(alertId, note: note, onDataHandler: onDataHandler)
        }
    }
    
    //postpone an alert, the AlertModel is returned
    class func postponeAlert(alertId:Int, date:String, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.postponeAlert(alertId, date: date, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.postponeAlert(alertId, date: date, onDataHandler: onDataHandler)
        }
    }
    
    //remove an array of alerts, the AlertModel's json is returned
    class func removeAlerts(alertIds:[Int], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.removeAlerts(alertIds, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.removeAlerts(alertIds, onDataHandler: onDataHandler)
        }
    }
    
    //delegate the alert to another agent, the AlertModel json is returned
    class func delegateAlert(alertId:Int, delegateId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.delegateAlert(alertId, delegateId: delegateId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.delegateAlert(alertId, delegateId: delegateId, onDataHandler: onDataHandler)
        }
    }
    
    //Get finish title for finishing the alert
    class func finishTitles(alertId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        LocalService.finishTitles(alertId, onDataHandler: onDataHandler)
        /*
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.delegateAlert(alertId, delegateId: delegateId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.finishTitles(alertId, onDataHandler: onDataHandler)
        }
*/
    }
    /////////////********************************************************/////////////
    ///////////// Clients
    /////////////********************************************************/////////////
    
    //retrieve all the clients for an agent by connecting to the data store
    class func getAllClientsForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getAllClientsForAgent(agentId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getAllClientsForAgent(agentId, onDataHandler: onDataHandler)
        }
    }
    
    //retrieve the complete details for a client
    class func getDetailsForClient(clientId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getDetailsForClient(clientId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getDetailsForClient(clientId, onDataHandler: onDataHandler)
        }
    }
    
    //This function gets details for multiple clients as array of NSDictionary this is needed to loop thru all clients and
    class func getDetailsForAllClient(#onDataHandler: (json:[NSDictionary]?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getDetailsForAllClient(onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getDetailsForAllClient(onDataHandler: onDataHandler)
        }
    }
    
    //add a photo for a client, the ClientModel json is returned
    class func addPhotoForClient(clientId:Int, photo:String, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.addPhotoForClient(clientId, photo: photo, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.addPhotoForClient(clientId, photo: photo, onDataHandler: onDataHandler)
        }
    }
    
    //add a payment for a client, the ClientModel json is returned
    class func addPaymentForClient(clientId:Int, payment:PaymentModel, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.addPaymentForClient(clientId, payment: payment, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.addPaymentForClient(clientId, payment: payment, onDataHandler: onDataHandler)
        }
    }
    
    //search through the agent's clients list
    class func searchClients(keywords:[String], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.searchClients(keywords, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.searchClients(keywords, onDataHandler: onDataHandler)
        }
    }
    
    /////////////********************************************************/////////////
    ///////////// Policies
    /////////////********************************************************/////////////
    
    //retrieve the complete details for a policy
    class func getDetailsForPolicy(policyId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getDetailsForPolicy(policyId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getDetailsForPolicy(policyId, onDataHandler: onDataHandler)
        }
    }
    
    //retrieve all of the billing associated with a policy
    class func getBillingForPolicy(policyId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getBillingForPolicy(policyId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getBillingForPolicy(policyId, onDataHandler: onDataHandler)
        }
    }
    
    //retrieve all of the alerts associated with a policy
    class func getAlertsForPolicy(policyId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getAlertsForPolicy(policyId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getAlertsForPolicy(policyId, onDataHandler: onDataHandler)
        }
    }
    
    /////////////********************************************************/////////////
    ///////////// Delegates
    /////////////********************************************************/////////////
    
    //retrieve the complete list of delegates
    class func getDelegatesForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getDelegatesForAgent(agentId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getDelegatesForAgent(agentId, onDataHandler: onDataHandler)
        }
    }
    
    //retrieve the complete list of agents
    class func getDelegateCandidates(onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getDelegateCandidates(onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getDelegateCandidates(onDataHandler)
        }
    }
    
    //replacement method for getDelegateCandidates to retrieve the complete list of agents
    class func getDelegateCandidates2(onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getDelegateCandidates2(onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getDelegateCandidates2(onDataHandler)
        }
    }
    
    //add delegates for the user
    class func addDelegatesForAgent(agentId:Int, delegateIds:[Int], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.addDelegatesForAgent(agentId, delegateIds: delegateIds, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.addDelegatesForAgent(agentId, delegateIds: delegateIds, onDataHandler: onDataHandler)
        }
    }
    
    //remove delegates for the user
    class func removeDelegatesForAgent(agentId:Int, delegateIds:[Int], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.removeDelegatesForAgent(agentId, delegateIds: delegateIds, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.removeDelegatesForAgent(agentId, delegateIds: delegateIds, onDataHandler: onDataHandler)
        }
    }
    
    //Get Delegated Alerts of Logged In Agent
    class func getDetailsForDelegate(agentId:Int, onDataHandler: (json:NSDictionary?, error:NSError?) -> Void)
    {
        //Currently fetching detail from Local, once API is ready integrate the RemoteService
        LocalService.getDetailsForDelegate(agentId, onDataHandler: onDataHandler)
    }

    class func getCategoriesForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        if !isLocal()
        {
            // call remote service to get data
            RemoteService.getCategoriesForAgent(agentId, onDataHandler: onDataHandler)
        }
        else
        {
            // call local service when offline
            LocalService.getCategoriesForAgent(agentId, onDataHandler: onDataHandler)
        }
    }

    // MARK: - Utils
    class func isLocal() -> Bool {
        return NSUserDefaults.standardUserDefaults().stringForKey("dataSource") == "local"
    }

}