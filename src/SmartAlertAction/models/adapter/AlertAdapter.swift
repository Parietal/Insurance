//
//  AlertAdapter.swift
//  SmartAlertAction
//
//  Created by Saurav on 29/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import CoreData

class AlertAdapter: BaseAdapter {
   
    func createAlert() -> Alert {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let entityDescripition = NSEntityDescription.entityForName("Alert", inManagedObjectContext: managedObjectContext!)
        let alert = Alert(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        return alert
    }
    
    func insertAlert() {
        
        save()
    }
    
    func getAlertDetail(id: Int!, categoryId:Int!) -> Alert! {
        
        //Completed
        let id_number = NSNumber(integer: id)
        let categoryId_number = NSNumber(integer: categoryId)

        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Alert")
        
        let predicate_id:NSPredicate = NSPredicate(format: "id = \(id_number)")!
        let predicate_categoryId:NSPredicate = NSPredicate(format: "categoryId = \(categoryId_number)")!
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_id, predicate_categoryId])

        // And assign this NSCompoundPredicate (which is just an NSPredicate after all) to the fetchRequest
        fetchRequest.predicate = compound
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as NSArray?
        
        if syncDatas?.count > 0 {
            return syncDatas?.lastObject as Alert
        }
        return nil
    }
    
    func getAlertDetailStatus(id: Int!, categoryId:Int!, status:String) -> Alert! {
        
        //Completed
        let id_number = NSNumber(integer: id)
        let categoryId_number = NSNumber(integer: categoryId)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Alert")
        
        let predicate_id:NSPredicate = NSPredicate(format: "id = \(id_number)")!
        let predicate_categoryId:NSPredicate = NSPredicate(format: "categoryId = \(categoryId_number)")!
        let predicate_status:NSPredicate = NSPredicate(format: "status = '\(status)'")!
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_id, predicate_categoryId, predicate_status])
        
        // And assign this NSCompoundPredicate (which is just an NSPredicate after all) to the fetchRequest
        fetchRequest.predicate = compound
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as NSArray?
        
        if syncDatas?.count > 0 {
            return syncDatas?.lastObject as Alert
        }
        return nil
    }
    
    //Get alert not older than one day
    func getAlertDetailStatus_Latest(id: Int!, categoryId:Int!, status:String) -> Alert! {
        
        //Completed
        let id_number = NSNumber(integer: id)
        let categoryId_number = NSNumber(integer: categoryId)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Alert")
        
        let predicate_id:NSPredicate = NSPredicate(format: "id = \(id_number)")!
        let predicate_categoryId:NSPredicate = NSPredicate(format: "categoryId = \(categoryId_number)")!
        let predicate_status:NSPredicate = NSPredicate(format: "status = '\(status)'")!
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_id, predicate_categoryId, predicate_status])
        
        // And assign this NSCompoundPredicate (which is just an NSPredicate after all) to the fetchRequest
        fetchRequest.predicate = compound
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as NSArray?
        
        if syncDatas?.count > 0 {
            
            let alert = syncDatas?.lastObject as Alert
            let days = CommonFunc.daysBetweenDate(NSDate(), toDateTime: alert.date)
            if days == 0 {
                return syncDatas?.lastObject as Alert

            }
        }
        return nil
    }
    
    func getAllAlertDetail() -> [Alert]! {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Alert")
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Alert]?
        
        if syncDatas?.count > 0 {
            return syncDatas
        }
        return nil
    }
    
    func cleanAlertTable() {
        
        var allAlert:[Alert]! = self.getAllAlertDetail()
        
        if  allAlert != nil {
        
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            
            for (index, alert) in enumerate(allAlert) {
                managedObjectContext?.deleteObject(alert)
            }
            save()
        }
    }
}
