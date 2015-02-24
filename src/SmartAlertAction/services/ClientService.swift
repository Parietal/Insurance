//
//  ClientService.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-08.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class ClientService
{
    
    //retrieve the complete list of clients without details
    class func getAllForAgent(agentId:Int, completionHandler: (clients:[String:[ClientModel]]?, error: NSError?) -> Void)
    {
        DataService.getAllClientsForAgent(agentId, onDataHandler: {(jsonArray:NSArray?, error: NSError?) -> Void in
            
            if jsonArray != nil && error == nil {
                var clients:[String:[ClientModel]] = DataModelUtils.getClientsFromJSON(jsonArray!)
                completionHandler(clients: clients, error: error)
            }
            else
            {
                completionHandler(clients: nil, error: error)
            }
            
        })
    }
    
    //retrieve the details for a client
    class func getDetailsForClient(clientId:Int, completionHandler: (client:ClientModel?, error:NSError?) -> Void) -> Bool
    {
        var clientFound : Bool = false
        
        DataService.getDetailsForClient(clientId, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in

            if json != nil && error == nil {
                var client:ClientModel = DataModelUtils.getClientFromJSON(json!)
                completionHandler(client: client, error: error)
            }
            else
            {
                completionHandler(client: nil, error: error)
            }
        })
        
        return clientFound
        
    }
    
    class func getDetailsForAllClient(clientId:Int, completionHandler: (clients:[ClientModel]?, error:NSError?) -> Void) -> Bool
    {
        var clientFound : Bool = false
        
        DataService.getDetailsForAllClient(onDataHandler: {(json:[NSDictionary]?, error:NSError?) -> Void in
            
            if json != nil && error == nil
            {
                var clientArray = [ClientModel]()
                var numClients = json?.count
                
                for index in 0..<numClients!{
                    if json != nil && error == nil
                    {
                        var clientJson : NSDictionary = json![index]
                        
                        var client:ClientModel = DataModelUtils.getClientFromJSON(clientJson)
                        clientArray.append(client)
                    }
                }
            
                completionHandler(clients: clientArray, error: error)
            }
            else
            {
                completionHandler(clients: nil, error: error)
            }
            
            
        })
        
        return clientFound
        
    }
    //add a photo for a client
    class func addPhotoForClient(clientId:Int, photo:String, completionHandler: (client:ClientModel?, error:NSError?) -> Void)
    {
        DataService.addPhotoForClient(clientId, photo: photo, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in
            
            if json != nil && error == nil
            {
                var client:ClientModel = DataModelUtils.getClientFromJSON(json!)
                completionHandler(client: client, error: error)
            }
            else
            {
                completionHandler(client: nil, error: error)
            }
            
        })
    }
    
    //add a payment for a client
    class func addPaymentForClient(clientId:Int, payment:PaymentModel, completionHandler: (client:ClientModel?, error:NSError?) -> Void)
    {
        DataService.addPaymentForClient(clientId, payment: payment, onDataHandler: {(json:NSDictionary?, error:NSError?) -> Void in

            if json != nil && error == nil
            {
                var client:ClientModel = DataModelUtils.getClientFromJSON(json!)
                completionHandler(client: client, error: error)
            }
            else
            {
                completionHandler(client: nil, error: error)
            }
        })
    }
    
    //search through clients
    class func searchClients(keywords:[String], completionHandler: (clients:[ClientModel]?, error:NSError?) -> Void)
    {
        DataService.searchClients(keywords, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in

            if jsonArray != nil && error == nil
            {
                var clients:[ClientModel] = [ClientModel]()
                for i in 0..<jsonArray!.count {
                    var data:NSDictionary = jsonArray![i] as NSDictionary
                    var client:ClientModel = DataModelUtils.getClientFromJSON(data)
                    clients.append(client)
                }
                completionHandler(clients: clients, error: error)
            }
            else
            {
                completionHandler(clients: nil, error: error)
            }
        })
    }
    
}