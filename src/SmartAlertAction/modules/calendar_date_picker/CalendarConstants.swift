//
//  CalendarConstants.swift
//  CalendarDatePicker
//
//  Created by Paul Yuan on 2014-11-11.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class CalendarConstants
{
    
    enum CALENDAR_SIZE:Float
    {
        case MONTH_START_ROW_HEIGHT = 35
        case WEEK_ROW_HEIGHT = 71
        case TOTAL_NUM_YEARS = 100
    }
    
    class var DAYS_OF_WEEK : [String] { return ["S", "M", "T", "W", "T", "F", "S"] }
    
    class var COLOR_RED:UIColor { return UIColor(red: 239/255, green: 72/255, blue: 50/255, alpha: 1.0) }
    class var COLOR_BLACK:UIColor { return UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1.0) }
    class var COLOR_GREY:UIColor { return UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0) }
    class var COLOR_LIGHT_GREY:UIColor { return UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0) }
    class var COLOR_WEEK_HEADER:UIColor { return UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0) }
    
}