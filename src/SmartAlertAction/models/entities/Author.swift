//
//  Author.swift
//  SmartAlertAction
//
//  Created by Saurav on 20/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import CoreData

class Author: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var fName: String
    @NSManaged var lName: String
    @NSManaged var imageName: String
    @NSManaged var displayName: String

}
