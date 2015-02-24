//
//  DataService.swift
//  SmartAlertAction
//
//  Created by Qiang Ren on 2014-09-29.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

enum HttpMethod: String
{
    case GET = "get"
    case POST = "post"
    case PUT = "put"
    case DELETE = "delete"
}

class RemoteService
{

    //authenticate the user and receive the user's AgentModel in response
    class func login(username: String, password: String, onDataHandler: (jsonDictionary: NSDictionary?, error:NSError?) -> Void)
    {
        //return LocalService.login(username, password: password, onDataHandler: onDataHandler)
        var data = ["username": username, "password": password] as [NSObject: AnyObject]
        //call service to get data
        _requestJSON(HttpMethod.POST, path: "/login", httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
                onDataHandler(jsonDictionary: json as NSDictionary?, error: error)
            }, postValues: data)
    }
    
    /////////////********************************************************/////////////
    ///////////// Alerts
    /////////////********************************************************/////////////
    
    //retrieve all the alerts for an agent by connecting to the data store
    class func getAllAlertsForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        var params = ["agentId": String(agentId)]
        //call service to get data
        _requestJSON(HttpMethod.GET, path: "/alerts", httpHeader: _buildHttpHeader(), parameters: params, onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
                onDataHandler(jsonArray: json as NSArray?, error: error)
            }, postValues: nil)
    }
    
    //retrieve the complete details for an alert
    class func getDetailsForAlert(alertId:Int, onDataHandler: (jsonObject:NSDictionary?, error:NSError?) -> Void)
    {
        var path = "/alert/\(alertId)"
        //call service to get data
        _requestJSON(HttpMethod.GET, path: path, httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
                onDataHandler(jsonObject: json as NSDictionary?, error: error)
            }, postValues: nil)
    }
    
    //mark an alert as complete, an AlertModel json is returned
    class func completeAlert(alertId:Int, onDataHandler: (jsonObject:NSDictionary?, error:NSError?) -> Void)
    {
        self.getDetailsForAlert(alertId, onDataHandler: {(jsonObject:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(jsonObject: jsonObject, error: error)
        })
    }
    
    //add a note to an alert, the AccountNoteModel is returned
    class func addNoteToAlert(alertId:Int, note:String, onDataHandler: (jsonObject:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: add in service call to get data
//        self._performAfterDelay(1, completionHandler: {() -> Void in
//            var jsonObject:NSDictionary = self._readLocalJSON("note") as NSDictionary
//            onDataHandler(jsonObject: json)
//        })
    }
    
    //postpone an alert, the AlertModel is returned
    class func postponeAlert(alertId:Int, date:String, onDataHandler: (jsonObject:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: placeholder method to read local json file for alert details
        self.getDetailsForAlert(0, onDataHandler: {(jsonObject:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(jsonObject: jsonObject, error: error)
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
    class func delegateAlert(alertId:Int, delegateId:Int, onDataHandler: (jsonObject:NSDictionary?, error:NSError?) -> Void)
    {
        //TODO: placeholder method to read local json file for alert details
        self.getDetailsForAlert(0, onDataHandler: {(jsonObject:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(jsonObject: jsonObject, error: error)
        })
    }
    
    /////////////********************************************************/////////////
    ///////////// Clients
    /////////////********************************************************/////////////
    
    //retrieve all the clients for an agent by connecting to the data store
    class func getAllClientsForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        var params = ["agentId": String(agentId)]
        //call service to get data
        _requestJSON(HttpMethod.GET, path: "/clients", httpHeader: _buildHttpHeader(), parameters: params, onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
                onDataHandler(jsonArray: json as NSArray?, error: error)
            }, postValues: nil)
    }
    
    //retrieve the complete details for a client
    class func getDetailsForClient(clientId:Int, onDataHandler: (jsonObject:NSDictionary?, error:NSError?) -> Void)
    {
        var path = "/client/\(clientId)"
        //call service to get data
        _requestJSON(HttpMethod.GET, path: path, httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
                onDataHandler(jsonObject: json as NSDictionary?, error: error)
            }, postValues: nil)
    }
    
    //This function gets details for multiple clients as array of NSDictionary this is needed to loop thru all clients and
    class func getDetailsForAllClient(#onDataHandler: (jsonObject:[NSDictionary]?, error:NSError?) -> Void)
    {
        var path = "/clients/details"
        //call service to get data
        _requestJSON(HttpMethod.GET, path: path, httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
            onDataHandler(jsonObject: json as [NSDictionary]?, error: error)
            }, postValues: nil)
    }

    //add a photo for a client, the ClientModel json is returned
    class func addPhotoForClient(clientId:Int, photo:String, onDataHandler: (jsonObject:NSDictionary?, error:NSError?) -> Void)
    {
        self.getDetailsForClient(clientId, onDataHandler: {(jsonObject:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(jsonObject: jsonObject, error: error)
        })
    }
    
    //add a payment for a client, the ClientModel json is returned
    class func addPaymentForClient(clientId:Int, payment:PaymentModel, onDataHandler: (jsonObject:NSDictionary?, error:NSError?) -> Void)
    {
        self.getDetailsForClient(clientId, onDataHandler: {(jsonObject:NSDictionary?, error:NSError?) -> Void in
            onDataHandler(jsonObject: jsonObject, error: error)
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
    ///////////// Policies
    /////////////********************************************************/////////////
    
    //retrieve the complete details for a policy
    class func getDetailsForPolicy(policyId:Int, onDataHandler: (jsonObject:NSDictionary?, error:NSError?) -> Void)
    {
        var path = "/policy/\(policyId)"
        //call service to get data
        _requestJSON(HttpMethod.GET, path: path, httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
            onDataHandler(jsonObject: json as NSDictionary?, error: error)
            }, postValues: nil)
    }
    
    //retrieve all of the billing associated with a policy
    class func getBillingForPolicy(policyId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        var path = "/policy/\(policyId)/billing"
        //call service to get data
        _requestJSON(HttpMethod.GET, path: path, httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
            onDataHandler(jsonArray: json as NSArray?, error: error)
            }, postValues: nil)
    }
    
    //retrieve all of the alerts associated with a policy
    class func getAlertsForPolicy(policyId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        self.getAllAlertsForAgent(policyId, onDataHandler: {(jsonArray:NSArray?, error:NSError?) -> Void in
            onDataHandler(jsonArray: jsonArray, error: error)
        })
    }
    
    /////////////********************************************************/////////////
    ///////////// Delegates
    /////////////********************************************************/////////////
    
    //retrieve the complete list of delegates
    class func getDelegatesForAgent(agentId:Int, onDataHandler: (jsonArray: NSArray?, error: NSError?) -> Void)
    {
        var params = ["agentId": String(agentId)]
        //call service to get data
        _requestJSON(HttpMethod.GET, path: "/delegates", httpHeader: _buildHttpHeader(), parameters: params, onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
                onDataHandler(jsonArray: json as NSArray?, error: error)
            }, postValues: nil)
    }

    //retrieve the complete list of agents
    class func getDelegateCandidates(onDataHandler: (jsonArray: NSArray?, error: NSError?) -> Void)
    {
        //call service to get data
        _requestJSON(HttpMethod.GET,  path: "/delegates/candidates", httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
                onDataHandler(jsonArray: json as NSArray?, error: error)
            }, postValues: nil)
    }

    //retrieve the complete list of agents
    class func getDelegateCandidates2(onDataHandler: (jsonArray: NSArray?, error: NSError?) -> Void)
    {
        //call service to get data
        _requestJSON(HttpMethod.GET,  path: "/delegates/candidates2", httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
            onDataHandler(jsonArray: json as NSArray?, error: error)
            }, postValues: nil)
    }

    //add delegates for the user
    class func addDelegatesForAgent(agentId:Int, delegateIds:[Int], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        var data = ["agentId": agentId, "delegateIds": delegateIds] as [NSObject: AnyObject]
        //call service to get data
        _requestJSON(HttpMethod.POST, path: "/delegates/add", httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
            onDataHandler(jsonArray: json as NSArray?, error: error)
            }, postValues: data)
    }
    
    //remove delegates for the user
    class func removeDelegatesForAgent(agentId:Int, delegateIds:[Int], onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        var data = ["agentId": agentId, "delegateIds": delegateIds] as [NSObject: AnyObject]
        //call service to get data
        _requestJSON(HttpMethod.DELETE, path: "/delegates/delete", httpHeader: _buildHttpHeader(), parameters: [:], onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
            onDataHandler(jsonArray: json as NSArray?, error: error)
            }, postValues: data)
    }
    
    /////////////********************************************************/////////////
    //MARK: Categories
    /////////////********************************************************/////////////
    class func getCategoriesForAgent(agentId:Int, onDataHandler: (jsonArray:NSArray?, error:NSError?) -> Void)
    {
        var params = ["agentId": String(agentId)]
        //call service to get data
        _requestJSON(HttpMethod.GET, path: "/category", httpHeader: _buildHttpHeader(), parameters: params, onDataHandler: {(json: AnyObject?, error: NSError?) -> Void in
            onDataHandler(jsonArray: json as NSArray?, error: error)
            }, postValues: nil)
    }

    /////////////********************************************************/////////////
    ///////////// MARK: - Utility functions
    /////////////********************************************************/////////////

    class func _buildHttpHeader() -> [String: String]
    {
        return [ "api-version": "1.0"]
    }

    class func _appendParametes(param: [String: String]?) -> [String: String]?
    {
        var segment = ["policy": "insurance", "life": "life"]
        var p = param != nil ? param! : [:]
        p["segment"] = segment[NSUserDefaults.standardUserDefaults().stringForKey("dataSetType")!]
        p["client_id"] = RemoteService._endpoint.clientId
        return p
    }
    
    class func _urlEncodedString(parameters: [String: String]) -> String
    {
        var parts: NSMutableArray = NSMutableArray()
        for (key: String, value: String) in parameters {
            var encodedKey: String = key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            var encodedValue: String = value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            var part = "\(encodedKey)=\(encodedValue)"
            parts.addObject(part)
        }
        return parts.componentsJoinedByString("&")
    }
    
    class func _parseJSON(data:NSData?, error:NSErrorPointer) -> AnyObject?
    {
        var result: AnyObject?
        if error.memory == nil && data != nil
        {
            
            var jsonData: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: error)
            
            if error.memory == nil
            {
                var statusCode = jsonData!["statusCode"] as NSString
                var statusMessage = jsonData!["statusMessage"] as String
                //error switch
                if( statusCode != "0"){
                    var code = Int(statusCode.intValue)
                    error.memory = NSError(domain: statusMessage, code: code, userInfo: nil)
                }
                result = jsonData!["data"]
            }
            
            if result == nil
            {
                result = jsonData
            }
            
        }
        return result
    }
    
    // request a call with method & parameters, then
    class func _requestJSON(httpMethod: HttpMethod, path: String, httpHeader: [String: String], parameters: [String: String]?, onDataHandler: (json: AnyObject?, error: NSError?) -> Void, postValues: [NSObject: AnyObject]?)
    {
//        var requestUrl:NSMutableString = NSMutableString(string: Constants.INSURANCE_SERVER_URL)
//        requestUrl.appendString(path)
        var requestUrl = NSMutableString(string: RemoteService.genRequestURL(path))
        var params = _appendParametes(parameters)
        if params != nil && params?.count > 0 {
            requestUrl.appendString("?")
            requestUrl.appendString(_urlEncodedString(params!))
        }

        println("url: \(requestUrl)")
        
        var request = NSMutableURLRequest(URL: NSURL(string: requestUrl)!);
        request.HTTPMethod = httpMethod.rawValue
        request.setValue(Constants.REQUEST_CONTENT_TYPE, forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.REQUEST_CHARSET, forHTTPHeaderField: "Accept-Charset")
        
        for (field, value) in httpHeader {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        //set post parameters
        if postValues != nil {
            var bodyData = NSJSONSerialization.dataWithJSONObject(postValues!, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            //var bodyData = _urlEncodedString(postValues as [String: String]).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            request.HTTPBody = bodyData
            println(NSString(data: bodyData!, encoding: NSUTF8StringEncoding))
        }

        var queue = NSOperationQueue()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response, data, error) -> Void in

            var err: NSError? = error
            var json: AnyObject?
            var httpResponse = response as NSHTTPURLResponse?
            if httpResponse?.statusCode == 200 {
                json = self._parseJSON(data, error: &err)
            } else {
                err = NSError(domain: "", code: httpResponse != nil ? httpResponse!.statusCode : -1, userInfo: nil)
            }
            
          //  println("data: "+NSString(data: data, encoding: NSUTF8StringEncoding)!)
           // println("json: \(json)")

            dispatch_async(dispatch_get_main_queue(), {()->Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                if err != nil {
                    
                    println("Error: Server connect Error.\n\(err?.description)")
                    //UIAlertView(title: "Error", message: "Server connect Error.\n\(error.description)", delegate: nil, cancelButtonTitle: "OK").show()
                    AppUtils.handleNetworkIssue(nil)
                }
                
                onDataHandler(json: json, error: err)

            })
            
        })
        
    }

    // (baseUrl, clientId)
    class var _endpoint: (baseUrl: String?, clientId: String?) {
        if let dataSource = NSUserDefaults.standardUserDefaults().stringForKey("dataSource") {
            if let endpoints = NSBundle.mainBundle().objectForInfoDictionaryKey("APIEndpoints") as? NSDictionary {
                if let endpoint = endpoints.objectForKey(dataSource) as? NSDictionary {
                    return (endpoint.objectForKey("baseUrl") as? String, endpoint.objectForKey("clientId") as? String)
                }
            }
            return (nil, nil)
        }
        return (nil, nil)
    }

    class func genRequestURL(subUrl:String) -> NSString {
        let url:String = RemoteService._endpoint.baseUrl! + subUrl
        return NSString(string: url)
    }
    
}