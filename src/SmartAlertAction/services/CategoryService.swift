//
//  CategoryService.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/12/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class CategoryService: NSObject {

    //retrieve collection of CategoryModels for the agent
    //CategoryModels do not have all the details filled in
    class func getAllForAgent(agentId:Int, completionHandler: (categories:[AlertCategoryModel]?, error:NSError?) -> Void)
    {
        DataService.getCategoriesForAgent(agentId, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            
            if jsonArray != nil && error == nil
            {
                var categories:[AlertCategoryModel] = DataModelUtils.getCategoriesFromJSON(jsonArray!)
                completionHandler(categories: categories, error: error)
            }
            else
            {
                completionHandler(categories: nil, error: error)
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
    
}
