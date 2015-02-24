//
//  Category.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/12/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var receiveNotification: NSNumber

}
