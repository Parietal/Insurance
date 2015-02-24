//
//  RAActivityIndicatorView.swift
//  SmartAlertAction
//
//  Created by SunTeng on 9/15/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class RAActivityIndicatorView: UIActivityIndicatorView {

    override init() {
        super.init()
        self.color = RAColors.BLUE1  // Bruce ** Color Change
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.color = RAColors.BLUE1  // Bruce ** Color Change
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.color = RAColors.BLUE1  // Bruce ** Color Change
    }
    
    func startAnimatingOnView(view: UIView) {
        super.startAnimating()
        self.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2)
        view.addSubview(self)
    }
    
    func stopAnimatingOnView() {
        super.stopAnimating()
        self.removeFromSuperview()
    }

}
