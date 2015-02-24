//
//  AddPhotoOptionsTableView.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-09-18.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class AddPhotoOptionsTableView:UITableView
{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.whiteColor()
        //self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.scrollEnabled = false
    }
    
}