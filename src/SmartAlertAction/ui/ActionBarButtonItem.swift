//
//  ActionBarButtonItem.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-10-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class ActionBarButtonItem:UIBarButtonItem
{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var attributes:NSDictionary = NSDictionary(object: RAFonts.BAR_BUTTON_ITEM_ACTION_LABEL, forKey: NSFontAttributeName)
        self.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
    }
    
}