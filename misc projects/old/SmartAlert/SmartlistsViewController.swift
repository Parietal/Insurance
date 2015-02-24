//
//  SmartlistsViewController.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class SmartlistsViewController:UIViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.image = UIImage(named: "icon_smartlists_off.png")
        self.tabBarItem.selectedImage = UIImage(named: "icon_smartlists_on.png")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController.title = "Smart Lists"
    }
    
}