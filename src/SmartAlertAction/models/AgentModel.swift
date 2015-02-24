//
//  AgentModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class AgentModel: PersonModel
{
    
    var id:Int = -1
    var delegates:[AgentModel] = [AgentModel]()
    var alertSettings:AlertSettingsModel?
    var book:AgentBookModel?
    var alerts:[AlertModel] = [AlertModel]()
    
    init(id:Int, fName:String, lName:String, displayName:String, imageName:String,delegates:[AgentModel], alertSettings:AlertSettingsModel?, book:AgentBookModel?, alerts:[AlertModel])
    {
        super.init()

        self.id = id
        self.fName = fName
        self.lName = lName
        self.displayName = displayName
        self.imageName = imageName
        self.delegates = delegates
        self.alertSettings = alertSettings?
        self.book = book?
        self.alerts = alerts
    }

    func save(key: String)
    {
        // Store the data
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

        defaults.setInteger(id, forKey: "\(key)_id")
        defaults.setObject(fName, forKey: "\(key)_firstName")
        defaults.setObject(lName, forKey: "\(key)_lastName")
        defaults.setObject(displayName, forKey: "\(key)_displayName")
        
        defaults.synchronize()
        
        println("Agent saved")
    }

    class func load(key: String) -> AgentModel?
    {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

        if let id = defaults.objectForKey("\(key)_id") as? NSNumber {
            var fName = defaults.objectForKey("\(key)_firstName") as String
            var lName = defaults.objectForKey("\(key)_lastName") as String
            var displayName = defaults.objectForKey("\(key)_displayName") as String
            
            return AgentModel(id: id.integerValue, fName: fName, lName: lName, displayName: displayName, imageName:"",delegates: [], alertSettings: nil, book: nil, alerts: [])
        }
        else
        {
            return nil
        }
    }
}