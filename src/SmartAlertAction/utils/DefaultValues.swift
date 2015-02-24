//
//  DefaultValues.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 25/11/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit

class DefaultValues: NSObject {
   
    var selectedSegment:Int = 0

    func updateSelectedSegment(index:Int) {
        
        self.selectedSegment = index
    }
    
    func getSelectedIndex() -> Int {
        
        return self.selectedSegment
    }
}
