//
//  CalendarDatePickerController.swift
//  CalendarDatePicker
//
//  Created by Paul Yuan on 2014-11-11.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

protocol CalendarDatePickerControllerDelegate {
    func calendarDatePickerOnDaySelected(day:NSDate)
    func calendarDatePickerOnCancel()
}

class CalendarDatePickerController:UIViewController, UITableViewDataSource, UITableViewDelegate, CalendarMonthCellDelegate
{

    @IBOutlet var tableView:UITableView?
    @IBOutlet var todayBtn:UIBarButtonItem?
    @IBOutlet var selectedBtn:UIBarButtonItem?
    @IBOutlet var cancelBtn:UIBarButtonItem?
    
    var delegate:CalendarDatePickerControllerDelegate?
    var disablePastDates:Bool = false {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    private var dateDisplay:CalendarDateDisplayController?
    private var selectedDate:NSDate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //set default cancel button
        if self.cancelBtn == nil {
            self.setCancelButtonTitle("Cancel")
        }
        
        self.todayBtn?.tintColor = CalendarConstants.COLOR_RED
        self.selectedBtn?.tintColor = CalendarConstants.COLOR_BLACK
        self.cancelBtn?.tintColor = CalendarConstants.COLOR_RED
        
        //register month cell nib
        let monthNib:UINib = UINib(nibName: "CalendarMonthCell", bundle: nil)
        self.tableView?.registerNib(monthNib, forCellReuseIdentifier: CalendarMonthCell.CELL_REUSE_ID)
        self.tableView?.layoutMargins = UIEdgeInsetsZero
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView?.showsHorizontalScrollIndicator = false
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.scrollsToTop = false
        
        //scroll to default date
        let today:NSDate = NSDate()
        let showDate:NSDate = self.selectedDate == nil ? today : self.selectedDate!
        self.goTo(showDate, animated: false)
        
        //style navigation bar and remove bottom border
        let bg:UIImage = self.getImageWithColor(CalendarConstants.COLOR_WEEK_HEADER)
        self.navigationController?.navigationBar.setBackgroundImage(bg, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil {
            if segue.identifier == "dateDisplay" {
                self.dateDisplay = segue.destinationViewController as? CalendarDateDisplayController
            }
        }
    }
    
    //scroll to show the month containing today
    @IBAction func goToToday(sender:AnyObject?) {
        let today:NSDate = NSDate()
        self.goTo(today, animated: true)
    }
    
    //scroll to show the selected month, to go today if no selected date
    @IBAction func goToSelectedDay(sender:AnyObject?) {
        self.selectedDate != nil ? self.goTo(self.selectedDate!, animated: true) : self.goToToday(nil)
    }
    
    //handle when the cancel button is clicked
    @IBAction func onCancel(sender:AnyObject?) {
        self.delegate?.calendarDatePickerOnCancel()
    }
    
    //set the default selected date
    func setDefaultSelectedDate(date:NSDate?) {
        self.selectedDate = date
        self.tableView?.reloadData()
    }
    
    //get the currently selected date
    func getSelectedDate() -> NSDate? {
        return self.selectedDate
    }
    
    //set the title text for the picker
    func setTitle(title:String) {
        self.navigationItem.title = title
        self.navigationItem.titleView?.hidden = title.isEmpty
    }
    
    //set the label for the cancel button
    func setCancelButtonTitle(title:String) {
        self.cancelBtn = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Bordered, target: self, action: "onCancel:")
        self.navigationItem.rightBarButtonItem = self.cancelBtn
        let view:UIView = self.cancelBtn?.valueForKey("view") as UIView
        view.hidden = title.isEmpty
    }
    
    //scroll to show entire specified month
    private func goTo(date:NSDate, animated:Bool)
    {
        let indexPath:NSIndexPath = self.getIndexPathForDate(date)
        self.tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: animated)
        
        //trigger animation if month is visible
        let monthCell:CalendarMonthCell? = self.tableView!.cellForRowAtIndexPath(indexPath) as? CalendarMonthCell
        monthCell?.animateDayForMonth(date)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Int(CalendarConstants.CALENDAR_SIZE.TOTAL_NUM_YEARS.rawValue)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CalendarMonthCell.NUM_MONTHS_IN_YEARS
    }
    
    //set the height for each month, calculate based on the number of weeks for each month
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let date:NSDate = self.getDateForIndexPath(indexPath)
        let numWeeks:Int = CalendarUtils.getNumberOfWeeksForMonth(date)
        let h:CGFloat = CGFloat(CalendarConstants.CALENDAR_SIZE.MONTH_START_ROW_HEIGHT.rawValue) + CGFloat(numWeeks) * CGFloat(CalendarConstants.CALENDAR_SIZE.WEEK_ROW_HEIGHT.rawValue)
        return h
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:CalendarMonthCell = tableView.dequeueReusableCellWithIdentifier(CalendarMonthCell.CELL_REUSE_ID) as CalendarMonthCell
        
        cell.delegate = self
        let date:NSDate = self.getDateForIndexPath(indexPath)
        cell.setDate(date, selectedDate: self.selectedDate, disablePastDates: self.disablePastDates)
        
        return cell
    }
    
    //get the date associated with an NSIndexPath
    private func getDateForIndexPath(indexPath:NSIndexPath) -> NSDate
    {
        let year:Int = self.getYearFromIndexPath(indexPath)
        let month:Int = indexPath.row + 1
        let day:Int = 1
        
        let date:NSDate = CalendarUtils.createDate(year, month: month, day: day)
        return date
    }
    
    //get the NSIndexPath of a date
    private func getIndexPathForDate(date:NSDate) -> NSIndexPath
    {
        let year:Int = CalendarUtils.getYearFromDate(date)
        let row:Int = CalendarUtils.getMonthFromDate(date) - 1 //because month starts from 1
        let section:Int = self.getSectionFromYear(year)
        let indexPath:NSIndexPath = NSIndexPath(forRow: row, inSection: section)
        return indexPath
    }
    
    //get the year being viewed based on the NSIndexPath
    private func getYearFromIndexPath(indexPath:NSIndexPath) -> Int
    {
        let today:NSDate = NSDate()
        let totalNumYears:Int = Int(CalendarConstants.CALENDAR_SIZE.TOTAL_NUM_YEARS.rawValue)
        var year:Int = CalendarUtils.getYearFromDate(today)
        if indexPath.section >= indexPath.section/2 {
            year += indexPath.section - Int(floor(CalendarConstants.CALENDAR_SIZE.TOTAL_NUM_YEARS.rawValue/2))
        } else {
            year -= Int(CalendarConstants.CALENDAR_SIZE.TOTAL_NUM_YEARS.rawValue/2) - indexPath.section
        }
        return year
    }
    
    //get the section for a year
    private func getSectionFromYear(year:Int) -> Int
    {
        let today:NSDate = NSDate()
        let currentYear:Int = CalendarUtils.getYearFromDate(today)
        let diff:Int = currentYear - year
        let totalNumYears:Int = Int(CalendarConstants.CALENDAR_SIZE.TOTAL_NUM_YEARS.rawValue)
        let section:Int = Int(floor(Double(totalNumYears)/2)) - diff
        return section
    }
    
    //generate a UIImage from a color
    private func getImageWithColor(color:UIColor) -> UIImage {
        let rect:CGRect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //show current date display
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexPaths:[NSIndexPath] = self.tableView?.indexPathsForVisibleRows() as [NSIndexPath]
        if indexPaths.count > 0 {
            let indexPath:NSIndexPath = indexPaths[0]
            let date:NSDate = self.getDateForIndexPath(indexPath)
            self.dateDisplay?.show(date)
        }
    }
    
    //hide current date display
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.dateDisplay?.hide()
    }

    /**** delegate methods ****/
    func calendarMonthOnDaySelected(day: NSDate) {
        self.selectedDate = day
        self.tableView?.reloadData()
        self.delegate?.calendarDatePickerOnDaySelected(day)
    }
    
}