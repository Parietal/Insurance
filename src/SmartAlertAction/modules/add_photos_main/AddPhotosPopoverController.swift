//
//  AddPhotosPopoverController.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-09-18.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class AddPhotosPopoverController:UIPopoverController
{
    
    required override init(contentViewController viewController: UIViewController) {
        super.init(contentViewController: viewController)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    //offset popover based on rect
    override func presentPopoverFromRect(rect: CGRect, inView view: UIView, permittedArrowDirections arrowDirections: UIPopoverArrowDirection, animated: Bool)
    {
        super.presentPopoverFromRect(CGRectOffset(rect, 0, 0), inView: view, permittedArrowDirections: arrowDirections, animated: animated)
    }
    
}