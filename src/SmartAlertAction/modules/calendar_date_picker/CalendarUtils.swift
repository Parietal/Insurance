//
//  CalendarUtils.swift
//  CalendarDatePicker
//
//  Created by Paul Yuan on 2014-11-12.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class CalendarUtils
{
    
    //return the number of weeks for the month of the provided date including blank days from the previous month
    class func getNumberOfWeeksForMonth(date:NSDate) -> Int
    {
        let numCells:Int = self.getNumCellsForMonth(date)   
        let numWeeks:Int = Int(ceil(Double(numCells) / Double(CalendarWeekCell.NUM_DAYS_IN_WEEK)))
        return numWeeks
    }
    
    //return the number of days in the month
    class func getNumberOfDaysForMonth(date:NSDate) -> Int
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let days:NSRange = calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: date)
        let numDays:Int = days.length
        return numDays
    }
    
    //return the index of day in month, counting empty cells
    class func getIndexOfDayInMonth(date:NSDate) -> Int
    {
        let numCells:Int = self.getNumCellsForMonth(date)
        let day:Int = self.getDayFromDate(date)
        let numDays:Int = self.getNumberOfDaysForMonth(date)
        let index:Int = numCells - numDays + day - 1
        return index
    }
    
    //return the index of week in month
    class func getIndexOfWeekInMonth(date:NSDate) -> Int
    {
        let numDaysInWeek:Int = Int(CalendarWeekCell.NUM_DAYS_IN_WEEK)
        let cellIndex:Int = self.getIndexOfDayInMonth(date)
        let index:Int = Int(floor(Double(cellIndex) / Double(numDaysInWeek)))
        return index
    }
    
    //return the first day of the month of the provided date
    class func getFirstDayOfMonth(date:NSDate) -> NSDate
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let comps:NSDateComponents = calendar.components((NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay), fromDate: date)
        comps.day = 1
        let firstDayOfMonth:NSDate = calendar.dateFromComponents(comps)!
        return firstDayOfMonth
    }
    
    //return the last day of the month of the provided date
    class func getLastDayOfMonth(date:NSDate) -> NSDate
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let comps:NSDateComponents = calendar.components((NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay), fromDate: date)
        let numDays = self.getNumberOfDaysForMonth(date)
        comps.day = numDays
        let lastDayOfMonth:NSDate = calendar.dateFromComponents(comps)!
        return lastDayOfMonth
    }
    
    //return the day of the week for the provided date 
    class func getDayOfWeek(date:NSDate) -> Int
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.WeekdayCalendarUnit
        let comps:NSDateComponents = calendar.components(unit, fromDate: date)
        let weekday:Int = comps.weekday
        return weekday
    }

    //return the day of the month for the provided date
    class func getDayOfMonth(date:NSDate) -> Int
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.DayCalendarUnit
        let comps:NSDateComponents = calendar.components(unit, fromDate: date)
        let monthday:Int = comps.day
        return monthday
    }
    
    //return the NSDate object of a day relative to date
    class func getDateRelativeToDate(date:NSDate, numDays:Int) -> NSDate {
        var time:NSTimeInterval = 60 * 60 * 24 * Double(numDays)
        time += 60 * 60 * 5 //offset to make date comparison work
        let day:NSDate = date.dateByAddingTimeInterval(time)
        return day
    }
    
    //return the number of cells for the month of the provided date
    class func getNumCellsForMonth(date:NSDate) -> Int {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let firstDay:NSDate = self.getFirstDayOfMonth(date)
        let firstDayDayOfWeek:Int = self.getDayOfWeek(firstDay)
        let days:NSRange = calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: date)
        let numCells:Int = days.length + firstDayDayOfWeek - 1
        return numCells
    }
    
    //compare if two NSDate objects are in the same day
    class func sameDay(date1:NSDate, date2:NSDate) -> Bool
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit
        let comps1:NSDateComponents = calendar.components(unit, fromDate: date1)
        let comps2:NSDateComponents = calendar.components(unit, fromDate: date2)
        let sameDay:Bool = comps1.year == comps2.year && comps1.month == comps2.month && comps1.day == comps2.day
        return sameDay
    }
    
    //get a NSDate by specifying the year, month and day
    class func createDate(year:Int, month:Int, day:Int) -> NSDate
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit
        let comps:NSDateComponents = NSDateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        let date:NSDate = calendar.dateFromComponents(comps)!
        return date
    }
    
    //get the year from a NSDate
    class func getYearFromDate(date:NSDate) -> Int
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit
        let comps:NSDateComponents = calendar.components(unit, fromDate: date)
        return comps.year
    }
    
    //get the month from a NSDate
    class func getMonthFromDate(date:NSDate) -> Int
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.MonthCalendarUnit
        let comps:NSDateComponents = calendar.components(unit, fromDate: date)
        return comps.month
    }
    
    //get the day from a NSDate
    class func getDayFromDate(date:NSDate) -> Int
    {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.DayCalendarUnit
        let comps:NSDateComponents = calendar.components(unit, fromDate: date)
        return comps.day
    }
    
}