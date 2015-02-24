//
//  DelegateAdapter.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/24/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import CoreData

class DelegateAdapter: BaseAdapter {
    
    func createDelegate() -> Delegate {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let entityDescripition = NSEntityDescription.entityForName("Delegate", inManagedObjectContext: managedObjectContext!)
        let delegate = Delegate(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        return delegate
    }
    
    func insertDelegate() {
        save()
    }
    
    func getAllDelegate() -> [Delegate]! {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Delegate")
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Delegate]?
        
        if syncDatas?.count > 0 {
            return syncDatas
        }
        return nil
    }
    
    
    func getDelegates(agentId: Int!) -> [Delegate]! {
        
        let agentId_number = NSNumber(integer: agentId)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Delegate")
        
        let predicate_id:NSPredicate = NSPredicate(format: "agentId = \(agentId_number)")!
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_id])
        
        // And assign this NSCompoundPredicate (which is just an NSPredicate after all) to the fetchRequest
        fetchRequest.predicate = compound
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Delegate]?
        
        if syncDatas?.count > 0 {
            return syncDatas
        }
        return nil
    }
    
    func getDelegate(agentId value:Int!, alertId:Int!) -> Delegate! {
        
        let agentid_number = NSNumber(integer: value)
        let alertid_number = NSNumber(integer: alertId)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Delegate")
        
        let predicate_agentid:NSPredicate = NSPredicate(format: "agentId = \(agentid_number)")!
        let predicate_alertid:NSPredicate = NSPredicate(format: "alertId = \(alertid_number)")!
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_agentid,predicate_alertid])
        
        // And assign this NSCompoundPredicate (which is just an NSPredicate after all) to the fetchRequest
        fetchRequest.predicate = compound
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as NSArray?
        
        if syncDatas?.count > 0 {
            return syncDatas?.lastObject as Delegate
        }
        return nil
    }
    
    func cleanDelegateTable() {
        
        var allDelegate:[Delegate]! = self.getAllDelegate()
        
        if  allDelegate != nil {
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            for (index, delegate) in enumerate(allDelegate) {
                managedObjectContext?.deleteObject(delegate)
            }
            save()
        }
    }
}
