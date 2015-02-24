//
//  CalendarMonthHeaderCell.swift
//  CalendarDatePicker
//
//  Created by Paul Yuan on 2014-11-12.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class CalendarMonthHeaderCell:UIView
{
    
    private var label:UILabel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //setup styles for label
        self.label = UILabel(frame: frame)
        self.label?.text = "MONTH"
        self.label?.textAlignment = NSTextAlignment.Center
        self.label?.textColor = CalendarConstants.COLOR_RED
        self.label?.sizeToFit()
        self.addSubview(self.label!)
    }
    
    //set the label based on the provided date
    func setMonth(date:NSDate)
    {
        let firstDayOfMonth:NSDate = CalendarUtils.getFirstDayOfMonth(date)
        let today:NSDate = NSDate()
        
        //set text of label
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MMM"
        let monthLabel:String = formatter.stringFromDate(firstDayOfMonth)
        
        //compare if year and month are the same as the current date
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit
        let comps1:NSDateComponents = calendar.components(unit, fromDate: today)
        let comps2:NSDateComponents = calendar.components(unit, fromDate: firstDayOfMonth)
        
        self.label?.text = monthLabel.uppercaseString
        self.label?.textColor =  comps1.month == comps2.month && comps1.year == comps2.year ? CalendarConstants.COLOR_RED : CalendarConstants.COLOR_BLACK
        self.label?.sizeToFit()
        
        //position label
        let weekday:Int = CalendarUtils.getDayOfWeek(firstDayOfMonth) - 1 //sunday starts at 1
        let dayWidth:CGFloat = self.frame.width / CalendarWeekCell.NUM_DAYS_IN_WEEK
        let x:CGFloat = CGFloat(weekday) * dayWidth
        let y:CGFloat = 0
        self.label?.frame = CGRectMake(x, y, dayWidth, self.frame.height)
    }
    
}