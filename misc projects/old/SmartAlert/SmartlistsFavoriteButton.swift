//
//  SmartlistsFavoriteButton.swift
//  SmartAlert
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class SmartlistsFavoriteButton:UIButton
{
    
    var isFav:Bool = true
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: "onTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.tintColor = RAColors.LIGHT_BLUE()
    }
    
    func onTapped(sender:AnyObject) {
        self.isFav = !self.isFav
        var file:String = self.isFav ? "icon_fav_down.png" : "icon_fav.png"
        var img:UIImage = UIImage(named: file)
        self.setImage(img, forState: UIControlState.Normal)
    }
    
    func reset(isChecked:Bool) {
        self.isFav = !isChecked
        onTapped(self)
    }
    
}