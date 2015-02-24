//
//  Delegate.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/24/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import CoreData

class Delegate: NSManagedObject {
    
    @NSManaged var agentId: NSNumber
    @NSManaged var alertId: NSNumber
    @NSManaged var category: String
    @NSManaged var desc: String
    @NSManaged var clientName: String
    @NSManaged var delegateAgent: String
    @NSManaged var rank: NSNumber
    
}
