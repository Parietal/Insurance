//
//  Settings.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/13/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import CoreData

class Settings: NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var importanceLevel: NSNumber
    @NSManaged var agentId:NSNumber
}