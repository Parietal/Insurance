//
//  RAColor.swift
//  SmartAlertAction
//
//  Created by Qiang Ren on 9/3/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class RAColors: NSObject {
    class var GRAY1:UIColor { return UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0) }
    class var GRAY2:UIColor { return UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0) }
    class var GRAY3:UIColor { return UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0) }
    class var GRAY4:UIColor { return UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0) }
    class var GRAY5:UIColor { return UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0) }
    class var GRAY6:UIColor { return UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1.0) }
    class var GRAY7:UIColor { return UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1.0) }
    class var GRAY8:UIColor { return UIColor(red: 84/255, green: 84/255, blue: 84/255, alpha: 1.0) }

    class var BLUE1:UIColor { return UIColor(red: 16/255, green: 103/255, blue: 189/255, alpha: 1.0) }
    class var RED1:UIColor { return UIColor(red: 218/255, green: 18/255, blue: 0/255, alpha: 1.0) }
    class var GREEN1:UIColor { return UIColor(red: 89/255, green: 145/255, blue: 60/255, alpha: 1.0) }

    class var LIGHT_GRAY:UIColor { return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0) }
    class var TAN_GRAY:UIColor { return UIColor(red: 250/255, green: 249/255, blue: 248/255, alpha: 1.0) }
    class var GRAY:UIColor { return UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0) }
    class var MEDIUM_GRAY:UIColor { return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0) }
    class var DARK_GRAY:UIColor { return UIColor(red: 72/255, green: 73/255, blue: 76/255, alpha: 1.0) }
    class var LIGHT_BLUE:UIColor { return UIColor(red: 76/255, green: 188/255, blue: 232/255, alpha: 1.0) }
    class var DARK_BLUE:UIColor { return UIColor(red: 3/255, green: 101/255, blue: 192/255, alpha: 1.0) }
    class var ORANGE:UIColor { return UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 1.0) }
    
    //PHM read settings for custom background color. Add definitions here for values in settings bundle
    class var LOGIN_BACKGROUND_COLOR:UIColor {
        var settingsColorScheme:String = NSUserDefaults.standardUserDefaults().objectForKey("colorScheme") as String
        
        switch settingsColorScheme{
            case "blue":
                return UIColor(red: 16/255, green: 103/255, blue: 189/255, alpha: 1.0)
            case "red":
                return UIColor(red: 218/255, green: 18/255, blue: 0/255, alpha: 1.0)
            case "green":
                return UIColor(red: 89/255, green: 145/255, blue: 60/255, alpha: 1.0)
            case "purple":
                return UIColor(red: 102/255, green: 1/255, blue: 102/255, alpha: 1.0)
            default:
                return UIColor(red: 16/255, green: 103/255, blue: 189/255, alpha: 1.0)
        }
    }
  
}
