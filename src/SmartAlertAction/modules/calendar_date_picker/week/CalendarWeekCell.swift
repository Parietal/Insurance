//
//  CalendarWeekCell.swift
//  CalendarDatePicker
//
//  Created by Paul Yuan on 2014-11-12.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

protocol CalendarWeekCellDelegate {
    func calendarWeekOnDaySelected(day:NSDate)
}

class CalendarWeekCell:UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    class var CELL_REUSE_ID : String { return "WeekCell" }
    class var NUM_DAYS_IN_WEEK : CGFloat { return 7 }
    
    @IBOutlet var collectionView:UICollectionView?
    
    var delegate:CalendarWeekCellDelegate?
    
    private var topBorder:CALayer?
    private var baseDate:NSDate = NSDate()
    private var weekNum:Int = 0
    private var selectedDate:NSDate?
    private var disablePastDates:Bool = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //load days of the week
        var nib:UINib = UINib(nibName: "CalendarDayCell", bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: CalendarDayCell.CELL_REUSE_ID)
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.bounces = false
        self.collectionView?.scrollEnabled = false
        self.collectionView?.delaysContentTouches = false
        
        //draw top border
        self.topBorder = CALayer()
        self.topBorder!.backgroundColor = CalendarConstants.COLOR_LIGHT_GREY.CGColor
        self.drawTopBorder(0, offsetDaysRight: 0)
        self.layer.addSublayer(self.topBorder!)
    }
    
    func update(baseDate:NSDate, weekNum:Int, selectedDate:NSDate?, disablePastDates:Bool) {
        self.baseDate = baseDate
        self.weekNum = weekNum
        self.selectedDate = selectedDate
        self.disablePastDates = disablePastDates
        self.collectionView?.reloadData()
    }
    
    //update the border based on the week
    private func updateTopBorder()
    {
        let numWeeksInMonth:Int = CalendarUtils.getNumberOfWeeksForMonth(self.baseDate)
        var offsetDaysLeft:Int = 0
        var offsetDaysRight:Int = 0
        
        if self.weekNum == 0
        {
            let firstDay:NSDate = CalendarUtils.getFirstDayOfMonth(self.baseDate)
            let firstDayWeekDay:Int = CalendarUtils.getDayOfWeek(firstDay)
            offsetDaysLeft = firstDayWeekDay - 1
        }
        else if self.weekNum == numWeeksInMonth - 1
        {
            let lastDay:NSDate = CalendarUtils.getLastDayOfMonth(self.baseDate)
            let lastDayWeekDay:Int = CalendarUtils.getDayOfWeek(lastDay)
            offsetDaysRight = Int(CalendarWeekCell.NUM_DAYS_IN_WEEK) - lastDayWeekDay
        }
        
        self.drawTopBorder(offsetDaysLeft, offsetDaysRight: offsetDaysRight)
    }
    
    //draw the border starting from the specified offset days
    private func drawTopBorder(offsetDaysLeft:Int, offsetDaysRight:Int)
    {
        let dayWidth:CGFloat = self.frame.width / CalendarWeekCell.NUM_DAYS_IN_WEEK
        let x:CGFloat = CGFloat(offsetDaysLeft) * dayWidth
        let w:CGFloat = self.frame.width - x - (CGFloat(offsetDaysRight) * dayWidth)
        self.topBorder!.frame = CGRectMake(x, 0, w, 1)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let w:CGFloat = collectionView.frame.width / CalendarWeekCell.NUM_DAYS_IN_WEEK
        let h:CGFloat = collectionView.frame.height
        return CGSizeMake(w, h)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //deselect all day in week
        self.deselectAllDays()
        
        //select cell
        var cell:CalendarDayCell = collectionView.cellForItemAtIndexPath(indexPath) as CalendarDayCell
        if !self.disablePastDates || (self.disablePastDates && !cell.cellIsPast())
        {
            cell.updateSelected(true)
            
            //trigger delegate method
            var cellDate:NSDate? = cell.getDate()
            if cellDate != nil {
                self.delegate?.calendarWeekOnDaySelected(cellDate!)
            }
        }
    }
    
    //deselect all days in the week
    private func deselectAllDays()
    {
        var cells:[CalendarDayCell] = self.collectionView?.visibleCells() as [CalendarDayCell]
        for cell in cells {
            cell.updateSelected(false)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell:CalendarDayCell = collectionView.dequeueReusableCellWithReuseIdentifier(CalendarDayCell.CELL_REUSE_ID, forIndexPath: indexPath) as CalendarDayCell
        
        //get current day for cell
        let cellDate:NSDate? = self.getCellDate(indexPath)
        cell.update(cellDate, selectedDate: self.selectedDate, disablePastDates: self.disablePastDates)
        
        //update top border for first and last weeks
        self.updateTopBorder()
        
        return cell
    }
    
    //animate the day for the week
    func animateDayForWeek(date:NSDate)
    {
        let dayIndex:Int = CalendarUtils.getDayOfWeek(date) - 1 //day starts from 1
        let indexPath:NSIndexPath = NSIndexPath(forRow: dayIndex, inSection: 0)
        let cell:CalendarDayCell? = self.collectionView?.cellForItemAtIndexPath(indexPath) as? CalendarDayCell
        cell?.animate()
    }
    
    //return date associated with a day cell by proiding a NSIndexPath
    private func getCellDate(indexPath:NSIndexPath) -> NSDate?
    {
        let numCells:Int = CalendarUtils.getNumCellsForMonth(self.baseDate)
        let numDaysInMonth:Int = CalendarUtils.getNumberOfDaysForMonth(self.baseDate)
        let numWeeksInMonth:Int = CalendarUtils.getNumberOfWeeksForMonth(self.baseDate)
        let cellIndex:Int = self.weekNum * Int(CalendarWeekCell.NUM_DAYS_IN_WEEK) + indexPath.row
        let firstDay:NSDate = CalendarUtils.getFirstDayOfMonth(self.baseDate)
        let firstDayWeekDay:Int = CalendarUtils.getDayOfWeek(firstDay)
        let numDaysFromFirstDay:Int = cellIndex - firstDayWeekDay + 1
        let cellDate:NSDate? = numDaysFromFirstDay < 0 || numDaysFromFirstDay >= numDaysInMonth ? nil : CalendarUtils.getDateRelativeToDate(firstDay, numDays: numDaysFromFirstDay)
        return cellDate
    }
    
}