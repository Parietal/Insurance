//
//  AnnualizedPremiumModel.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/25/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AnnualizedPremiumModel: NSObject {
 
    var id:Int = -1
    var typeId:Int = -1
    var code:String = ""
    var title:String = ""
    var value:String = ""
    
    init(id:Int, typeId:Int, code:String, title:String, value:String) {
        self.id = id
        self.typeId = typeId
        self.code = code
        self.title = title
        self.value = value
    }
}
