//
//  CategoryAdapter.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/12/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import CoreData

class CategoryAdapter: BaseAdapter {
   
    func createCategory() -> Category {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let entityDescripition = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext!)
        let category = Category(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        return category
    }
    
    func insertCategory() {
        save()
    }
    
    func getCategoryDetail(id: Int!) -> Category! {
        
        //Completed
        let id_number = NSNumber(integer: id)

        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        let predicate_id:NSPredicate = NSPredicate(format: "id = \(id_number)")!
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_id])

        // And assign this NSCompoundPredicate (which is just an NSPredicate after all) to the fetchRequest
        fetchRequest.predicate = compound
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as NSArray?
        
        if syncDatas?.count > 0 {
            return syncDatas?.lastObject as Category
        }
        return nil
    }
    
    func getAllCategoryDetail() -> [Category]! {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Category]?
        
        if syncDatas?.count > 0 {
            return syncDatas
        }
        return nil
    }
    
    func cleanCategoryTable() {
        
        var allCategory:[Category]! = self.getAllCategoryDetail()
        
        if  allCategory != nil {
        
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            
            for (index, category) in enumerate(allCategory) {
                managedObjectContext?.deleteObject(category)
            }
            save()
        }
    }

}
