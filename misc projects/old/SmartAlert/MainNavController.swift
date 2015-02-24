//
//  MainNavController.swift
//  SmartAlert
//
//  Created by Paul Yuan on 2014-08-11.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class MainNavController:UINavigationController
{
    
    func showAlertDetails(alertId:String)
    {
        var storyboard = UIStoryboard(name: "AlertDetails", bundle: nil)
        var alertDetailsController:AlertDetailsViewController = (storyboard.instantiateInitialViewController() as AlertDetailsViewController)
        alertDetailsController.selectedAlertId = alertId
        self.pushViewController(alertDetailsController, animated: true)
    }
    
}