//
//  AlertCategoryViewModel.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/3/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AlertCategoryViewModel: AlertCategoryModel {
    var number: Int = 0
    var alerts: [AlertModel] = []

    init(id: Int, code: String, title: String, number: Int) {
        super.init(id: id, code: code, title: title, subTitle: "", policyType: "", note: "", settings: nil)
        self.number = number
    }

    class func categoryViewModelsFromAlertModes(alerts: Array<AlertModel>) -> Array<AlertCategoryViewModel> {
        var categoryViewModels = Dictionary<String, AlertCategoryViewModel>()

        var delegated = AlertCategoryViewModel(id: -98, code: "Delegated", title: "Delegated", number: 42) //TODO: get delegated from back-end
        var completed = AlertCategoryViewModel(id: -99, code: "Completed", title: "Completed", number: 0)
        
        // for each alert
        for alert in alerts {
            if let category = alert.category? {
                // get categoryId by filter the last two digit 010101->0101
                var categoryCode = category.code
                categoryCode = categoryCode.substringToIndex(advance(categoryCode.endIndex, -2))

                // get alertList of this category (of current alert)
                var cate:AlertCategoryViewModel? = categoryViewModels[categoryCode]
                if cate == nil {
                    // first time to see this category
                    cate = AlertCategoryViewModel(id: -1, code: categoryCode, title: category.title, number: 0)
                    categoryViewModels[categoryCode] = cate
                }

                if isAlertCompleted(alert) == true {
                    completed.alerts.append(alert)
                    completed.number++
                }
                else if isAlertDelegated(alert) == true {
                    delegated.alerts.append(alert)
                    delegated.number++
                }
                else if alert.isCompleted {
                    completed.alerts.append(alert)
                    completed.number++
                }
                else {
                    // add alerts to view model
                    cate?.alerts.append(alert)
                    
                    // count uncompleted number
                    if !alert.isCompleted {
                        cate?.number++
                    }
                }
            }
        }
        
        // sort each value
        for (category,viewModel) in categoryViewModels {
            viewModel.alerts.sort({ $0.rank > $1.rank})
        }
        //delegated.alerts.sort
        completed.alerts.sort({ $0.rank > $1.rank})

        var array = categoryViewModels.values.array
        // sort by code
        array = sorted(array, { (c1: AlertCategoryViewModel, c2: AlertCategoryViewModel) -> Bool in
            c1.code < c2.code })
        array.append(delegated)
        array.append(completed)
        return array
    }
    
    ///Check whether alert is completed and saved in local DB
    class func isAlertCompleted(alertObj:AlertModel) -> Bool {
    
        let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
        var alert:Alert!
        alert = alertAdapter.getAlertDetailStatus_Latest(alertObj.id, categoryId: alertObj.category?.id, status:"Completed")
        if let alertObj = alert {
            //If it comes here, that means alert with alertId exists in DB and has been marked as completed
            return true
        }
        else {
            return false
        }
    }

    ///Check whether alert is completed and saved in local DB
    class func isAlertDelegated(alertObj:AlertModel) -> Bool {
        
        let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
        var alert:Alert!
        alert = alertAdapter.getAlertDetailStatus_Latest(alertObj.id, categoryId: alertObj.category?.id, status:"Delegated")
        if let alertObj = alert {
            //If it comes here, that means alert with alertId exists in DB and has been marked as completed
            return true
        }
        else {
            return false
        }
    }
}
