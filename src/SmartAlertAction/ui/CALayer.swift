//
//  CALayer.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/24/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

extension CALayer {
   
    func setBorderColorFromUIColor(color: UIColor)
    {
        self.borderColor = color.CGColor;
    }

}
