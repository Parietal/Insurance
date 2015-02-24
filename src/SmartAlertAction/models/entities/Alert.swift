//
//  Alert.swift
//  SmartAlertAction
//
//  Created by Saurav on 12/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import CoreData

class Alert: NSManagedObject {

    @NSManaged var categoryId: NSNumber
    @NSManaged var finishNote: String
    @NSManaged var id: NSNumber
    @NSManaged var isDestructive: NSNumber
    @NSManaged var status: String
    @NSManaged var date: NSDate

}
