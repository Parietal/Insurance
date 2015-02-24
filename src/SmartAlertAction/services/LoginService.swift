//
//  LoginService.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-05.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class LoginService
{
    
    //authenticate the user and receive the user's agent model in the completion handler
    class func login(username:String, password:String, completionHandler: (agent:AgentModel?, error:NSError?) -> Void)
    {
        DataService.login(username, password: password, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            
            if json != nil && error == nil
            {
                var agent:AgentModel! = DataModelUtils.getAgentFromJSON(json)
                completionHandler(agent: agent, error: error)
            }
            else
            {
                completionHandler(agent: nil, error: error)
            }

        })
    }
    
}