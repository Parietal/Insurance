//
//  DelegateService.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-15.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class DelegateService
{
    
    //retrieve collection of AgentModels for the agent
    //AgentModels do not have all the details filled in
//    class func getAllForAgent(agentId:Int, completionHandler: (agents:[AgentModel]?, error:NSError?) -> Void)
    class func getAllForAgent(agentId:Int, completionHandler: (agents:[String:[AgentModel]]?, error:NSError?) -> Void)
    {
        DataService.getDelegatesForAgent(agentId, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            
            if jsonArray != nil && error == nil
            {
                var agents:[String:[AgentModel]] = DataModelUtils.getAgentsFromJSON(jsonArray!)
                completionHandler(agents: agents, error: error)
            }
            else
            {
                completionHandler(agents: nil, error: error)
            }
            
        })
    }
    
    //retrieve collection of AgentModels
    //AgentModels do not have all the details filled in
    class func getCandiates(completionHandler: (agents:[String:[AgentModel]]?, error:NSError?) -> Void)
    {
        DataService.getDelegateCandidates({(jsonArray:NSArray?, error:NSError?) -> Void in
            
            if jsonArray != nil && error == nil
            {
                var agents:[String:[AgentModel]] = DataModelUtils.getAgentsFromJSON(jsonArray!)
                completionHandler(agents: agents, error: error)
            }
            else
            {
                completionHandler(agents: nil, error: error)
            }
            
        })
    }
    
    class func getAllCandiates(completionHandler: (agents:[AgentModel]?, error:NSError?) -> Void)
    {
        DataService.getDelegateCandidates({(jsonArray:NSArray?, error:NSError?) -> Void in
            
            if jsonArray != nil && error == nil
            {
                var agents:[AgentModel] = DataModelUtils.getAllAgentsFromJSON(jsonArray!)
                completionHandler(agents: agents, error: error)
            }
            else
            {
                completionHandler(agents: nil, error: error)
            }
            
        })
    }
    
    //replacement method for getCandiates
    class func getAllCandiates2(completionHandler: (agents:[String:[AgentModel]]?, error:NSError?) -> Void)
    {
        DataService.getDelegateCandidates2({(jsonArray:NSArray?, error:NSError?) -> Void in
            
            if jsonArray != nil && error == nil
            {
                var agents:[String:[AgentModel]] = DataModelUtils.getAllAgentsFromJSON2(jsonArray!)
                completionHandler(agents: agents, error: error)
            }
            else
            {
                completionHandler(agents: nil, error: error)
            }
            
        })
    }
    
    //add delegates for the agent
    //receive modified list of delegates for the agent
    class func addDelegatesForAgent(agentId:Int, completionHandler: (agents:[AgentModel]?, error:NSError?) -> Void)
    {
        var delegateIds:[Int] = [0]
        DataService.addDelegatesForAgent(agentId, delegateIds: delegateIds, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            
            if jsonArray != nil && error == nil
            {
                var agents:[AgentModel] = [AgentModel]()
                for i in 0..<jsonArray!.count {
                    var data:NSDictionary = jsonArray![i] as NSDictionary
                    var agent:AgentModel = DataModelUtils.getAgentFromJSON(data)
                    agents.append(agent)
                }
                completionHandler(agents: agents, error: error)
            }
            else
            {
                completionHandler(agents: nil, error: error)
            }
            
        })
    }
    
    //remove delegates for the agent
    //receive modified list of delegates for the agent
    class func removeDelegatesForAgent(agentId:Int, completionHandler: (agents:[AgentModel]?, error:NSError?) -> Void)
    {
        var delegateIds:[Int] = [0]
        DataService.removeDelegatesForAgent(agentId, delegateIds: delegateIds, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            
            if jsonArray != nil && error == nil
            {
                var agents:[AgentModel] = [AgentModel]()
                for i in 0..<jsonArray!.count {
                    var data:NSDictionary = jsonArray![i] as NSDictionary
                    var agent:AgentModel = DataModelUtils.getAgentFromJSON(data)
                    agents.append(agent)
                }
                completionHandler(agents: agents, error: error)
            }
            else
            {
                completionHandler(agents: nil, error: error)
            }
            
        })
    }
    
    //Get Delegated Alerts of Logged In Agent
    class func getDetailsForDelegate(agentId:Int, completionHandler: (delegates:[DelegateModel]?, error:NSError?) -> Void)
    {
        DataService.getDetailsForDelegate(agentId, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            
            if json != nil && error == nil
            {
                var delegates:[DelegateModel] = DataModelUtils.getDelegateArray(json!)
                completionHandler(delegates: delegates, error: error)
            }
            else
            {
                completionHandler(delegates: nil, error: error)
            }
            
        })
    }
}