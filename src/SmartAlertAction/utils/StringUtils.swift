//
//  StringUtils.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class StringUtils
{
    
    //get the NSDate object from the input date and time strings
    class func convertStringToDate(dateString:String, timeString:String) -> NSDate
    {
        var dString = dateString
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        
        // Fixed problem with Device set to non-english language - crash
        let usLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = usLocale

        
        //if dateString is an empty string, use today's date
        if NSString(string: dateString).length == 0 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var today:NSDate = NSDate()
            dString = dateFormatter.stringFromDate(today)
        }
        
        dateFormatter.dateFormat = NSString(string: timeString).length > 0 ? "yyyy-MM-dd h:mm a" : "yyyy-MM-dd"
        var d:NSDate = dateFormatter.dateFromString(dString + " " + timeString)!
        return d
    }
    
    class func convertDateToString(nsDate: NSDate, format: String) -> String {
        var dString = ""
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        
        //if format is empty string, use default format
        if NSString(string: format).length == 0 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        } else {
            dateFormatter.dateFormat = format
        }
        
        dString = dateFormatter.stringFromDate(nsDate)
        return dString
    }
    
    class func trimStringToLimit(string: String, limit: Int) -> String {
        var trimedString = NSString(string: string)
        if trimedString.length > limit {
            trimedString = trimedString.substringToIndex(limit).stringByAppendingString("...")
        }
        return trimedString
    }

    class func getFinishTitleAttribute(level: Int) -> (color:UIColor,font:UIFont) {

        
    switch(level) {
        case 1:
            return (RAColors.BLUE1, RAFonts.HELVETICA_NEUE_REGULAR_17)
        case 2:
            return (RAColors.RED1, RAFonts.HELVETICA_NEUE_REGULAR_17)
        case 3:
            return (UIColor.blackColor(), RAFonts.HELVETICA_NEUE_REGULAR_17)

        default:
            return (UIColor.blackColor(), RAFonts.HELVETICA_NEUE_REGULAR_17)
        }

    }
    
    class func convertDateToString(nsDate: NSDate,isOnlyTime:Bool) -> String {
        var dString = ""
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        
        if isOnlyTime {
            dateFormatter.dateFormat = "hh:mm a"
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        dString = dateFormatter.stringFromDate(nsDate)
        return dString
    }
}