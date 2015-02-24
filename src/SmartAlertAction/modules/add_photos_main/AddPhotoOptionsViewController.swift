//
//  AddPhotoOptionsViewController.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-10-15.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class AddPhotoOptionsViewController:UIViewController
{
    
    var delegate:AddPhotoOptionsPopoverDelegate?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier != nil
        {
            if segue.identifier == "addOptionsTable" {
                var controller:AddPhotoOptionsTableViewController = segue.destinationViewController as AddPhotoOptionsTableViewController
                controller.delegate = self.delegate? as ContactViewController
            }
            else if segue.identifier == "addOptionsCollection" {
                var controller:AddPhotoOptionsCollectionViewController = segue.destinationViewController as AddPhotoOptionsCollectionViewController
                controller.delegate = self.delegate? as ContactViewController
            }
        }
    }
    
}