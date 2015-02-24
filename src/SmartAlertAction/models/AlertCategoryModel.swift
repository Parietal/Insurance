//
//  AlertCategoryModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-08-29.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class AlertCategoryModel
{
    
    var id:Int = -1
    var code:String = "" //used for sorting
    var title:String = ""
    var subTitle:String = ""
    var policyType:String? = ""
    var note:String? = ""
    var settings:CategorySettingsModel?

    init(id:Int, code:String, title:String, subTitle:String, policyType:String?, note:String?, settings: CategorySettingsModel?) {
        self.id = id
        self.code = code
        self.title = title
        self.subTitle = subTitle
        self.policyType = policyType
        self.note = note
        self.settings = settings
    }
    
    func enableReceiveNotification(enable: Bool) {
        
        let categoryAdapter = CommonFunc.sharedInstanceCategory as CategoryAdapter
        var category:Category? = categoryAdapter.getCategoryDetail(id)

        if category != nil {
            if category?.receiveNotification == enable {
                //nothing need to do, as same receiveNotification
                return
            }
        }
        else {
            //Create Category Object in DB via CoreData(Entity - Category)
            category = categoryAdapter.createCategory()
            category!.id = NSNumber(integer: self.id)
        }
    
        category!.receiveNotification = NSNumber(bool: enable)
    
        categoryAdapter.insertCategory()
    }

}