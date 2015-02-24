//
//  ClientsAlertStatus.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 20/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import CoreData

class ClientsAlertStatus: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var showAlert: NSNumber
    
}