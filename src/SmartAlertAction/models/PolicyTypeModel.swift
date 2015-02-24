//
//  PolicyTypeModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-09.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class PolicyTypeModel
{
    
    var id:Int = -1
    var code:String = "" //used for sorting
    var title:String = ""
    var subTitle:String = ""
    
    init(id:Int, code:String, title:String, subTitle:String) {
        self.id = id
        self.code = code
        self.title = title
        self.subTitle = subTitle
    }
    
}