//
//  NoteAdapter.swift
//  SmartAlertAction
//
//  Created by Saurav on 20/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import CoreData

class NoteAdapter: BaseAdapter {
   
    func createNote() -> Note {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let entityDescripition = NSEntityDescription.entityForName("Note", inManagedObjectContext: managedObjectContext!)
        let note = Note(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        return note
    }
    
    func insertNote() {
        
        save()
    }
    
    func getAllNoteDetail(clientId:Int) -> [Note]! {
        
        let idNumber = NSNumber(integer: clientId)
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Note")

        let predicate_id:NSPredicate = NSPredicate(format: "clientId = \(idNumber)")!
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predicate_id])
        fetchRequest.predicate = compound
        
        var notes = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Note]?
        
        if notes?.count > 0 {
            return notes
        }
        return nil
    }
    func getAllNoteDetail() -> [Note]! {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Note")
        
        var notes = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Note]?
        
        if notes?.count > 0 {
            return notes
        }
        return nil
    }
    
    func cleanNoteTable() {
        
        var allNote:[Note]! = self.getAllNoteDetail()
        
        if  allNote != nil {
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            
            for (index, note) in enumerate(allNote) {
                managedObjectContext?.deleteObject(note)
            }
            save()
        }
    }

}
