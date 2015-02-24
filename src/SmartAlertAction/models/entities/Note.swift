//
//  Note.swift
//  SmartAlertAction
//
//  Created by Saurav on 20/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import CoreData

class Note: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var date: String
    @NSManaged var time: String
    @NSManaged var text: String
    @NSManaged var clientId: NSNumber
    @NSManaged var author: Author

}
