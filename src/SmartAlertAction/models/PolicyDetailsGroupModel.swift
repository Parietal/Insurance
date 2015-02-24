//
//  PolicyDetailsGroupModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-12.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class PolicyDetailsGroupModel
{
    
    var title:String
    var items:[PolicyDetailsItemModel] = [PolicyDetailsItemModel]()
    var twoColumns:Bool
    
    init(title:String, items:[PolicyDetailsItemModel], twoColumns:Bool) {
        self.title = title
        self.items = items
        self.twoColumns = twoColumns
    }
    
}