//
//  AuthorAdapter.swift
//  SmartAlertAction
//
//  Created by Saurav on 20/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import CoreData

class AuthorAdapter: BaseAdapter {
   
    func createAuthor() -> Author {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let entityDescripition = NSEntityDescription.entityForName("Author", inManagedObjectContext: managedObjectContext!)
        let author = Author(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        return author
    }
    
    func insertAuthor() {
        
        save()
    }
    
    func getAuthorDetail(id: Int!) -> Author! {
        
        //Completed
        let id_number = NSNumber(integer: id)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Author")
        
        let predicate_id:NSPredicate = NSPredicate(format: "id = \(id_number)")!
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_id])
        
        // And assign this NSCompoundPredicate (which is just an NSPredicate after all) to the fetchRequest
        fetchRequest.predicate = compound
        
        var syncDatas = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as NSArray?
        
        if syncDatas?.count > 0 {
            return syncDatas?.lastObject as Author
        }
        return nil
    }
    
    func getAllAuthorDetail() -> [Author]! {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Author")
        
        var author = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Author]?
        
        if author?.count > 0 {
            return author
        }
        return nil
    }
    
    func cleanAuthorTable() {
        
        var allAuthor:[Author]! = self.getAllAuthorDetail()
        
        if  allAuthor != nil {
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            
            for (index, author) in enumerate(allAuthor) {
                managedObjectContext?.deleteObject(author)
            }
            save()
        }
    }

}
