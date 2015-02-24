//
//  RecommendationModel.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/23/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class RecommendationModel
{
    var id:Int = -1
    var title:String = ""
    var detail:String = ""
    
    init(title:String, detail:String) {
        self.title = title
        self.detail = detail
    }
}
