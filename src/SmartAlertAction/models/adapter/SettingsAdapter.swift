//
//  SettingsAdapter.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/13/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import CoreData

class SettingsAdapter: BaseAdapter {
    
    func createSettings() -> Settings {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let entityDescripition = NSEntityDescription.entityForName("Settings", inManagedObjectContext: managedObjectContext!)
        let settings = Settings(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        return settings
    }
    
    func insertSettings() {
        save()
    }
    
    func getAllSettings() -> [Settings]! {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Settings")
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Settings]?
        
        if syncDatas?.count > 0 {
            return syncDatas
        }
        return nil
    }
    
    func getSettings(id: Int!) -> Settings! {
        
        //Completed
        let id_number = NSNumber(integer: id)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Settings")
        
        let predicate_id:NSPredicate = NSPredicate(format: "id = \(id_number)")!
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_id])
        
        // And assign this NSCompoundPredicate (which is just an NSPredicate after all) to the fetchRequest
        fetchRequest.predicate = compound
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as NSArray?
        
        if syncDatas?.count > 0 {
            return syncDatas?.lastObject as Settings
        }
        return nil
    }
    
    
    func getSettings(agentId value: Int!) -> Settings! {
        
        //Completed
        let agentId_number = NSNumber(integer: value)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Settings")
        
        let predicate_id:NSPredicate = NSPredicate(format: "agentId = \(agentId_number)")!
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_id])
        
        // And assign this NSCompoundPredicate (which is just an NSPredicate after all) to the fetchRequest
        fetchRequest.predicate = compound
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as NSArray?
        
        if syncDatas?.count > 0 {
            return syncDatas?.lastObject as Settings
        }
        return nil
    }
    
    
    
    func cleanSettingsTable() {
        
        var allSettings:[Settings]! = self.getAllSettings()
        
        if  allSettings != nil {
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            for (index, Settings) in enumerate(allSettings) {
                managedObjectContext?.deleteObject(Settings)
            }
            save()
        }
    }
}
