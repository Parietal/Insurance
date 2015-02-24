//
//  UIViewController+Orientation.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/31/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

extension UIViewController {

    func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue | UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
        } else {
            
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue | UIInterfaceOrientationMask.LandscapeRight.rawValue)
        }
    }
    
}
