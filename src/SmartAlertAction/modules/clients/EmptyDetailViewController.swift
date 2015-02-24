//
//  EmptyDetailViewController.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 21/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class EmptyDetailViewController: UIViewController{
    
    @IBOutlet var settingButton: UIBarButtonItem!
    
    @IBAction func settingsTapped(sender: AnyObject) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as UISplitViewController
            controller.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.navigationItem.rightBarButtonItem == nil {
            self.navigationItem.rightBarButtonItem = settingButton;

        }

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.rightBarButtonItem = nil;
    }

}