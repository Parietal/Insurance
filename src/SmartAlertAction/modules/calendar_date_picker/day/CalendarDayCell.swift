//
//  CalendarDayCell.swift
//  CalendarDatePicker
//
//  Created by Paul Yuan on 2014-11-11.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class CalendarDayCell:UICollectionViewCell
{
    
    class var CELL_REUSE_ID:String { return "day" }
    
    @IBOutlet var label:UILabel?
    
    private var date:NSDate?
    private var background:UIView?
    private var disablePastDates:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
    
    //update text and style
    func update(date:NSDate?, selectedDate:NSDate?, disablePastDates:Bool)
    {
        self.date = date
        self.label?.hidden = self.date == nil
        self.disablePastDates = disablePastDates
        
        //render if selected
        if date != nil && selectedDate != nil {
            self.selected = CalendarUtils.sameDay(date!, date2: selectedDate!)
        } else {
            self.selected = false
        }
        
        if date != nil
        {
            //populate label
            var dayOfMonth:Int = CalendarUtils.getDayOfMonth(date!)
            self.label?.text = dayOfMonth.description
        }
        
        self.updateSelected(self.selected)
    }
    
    //update view based on selected
    func updateSelected(selected:Bool)
    {
        self.selected = selected
        self.setBackgroundView(selected)
        self.setLabel(selected)
        self.alpha = self.disablePastDates && self.cellIsPast() ? 0.25 : 1.0
    }
    
    //draw background for state
    private func setBackgroundView(selected:Bool)
    {
        //always remove background layer before redraw
        if self.background != nil {
            self.background!.removeFromSuperview()
            self.background = nil
        }
        
        let isToday:Bool = self.cellIsToday()
        if isToday || self.selected
        {
            //always show if today and selected, add background layer
            if self.background == nil
            {
                let margin:CGFloat = 5
                let newSize:CGFloat = self.frame.width - margin * 2
                let frame:CGRect = CGRectMake(margin, margin, newSize, newSize)
                self.background = UIView()
                self.background!.frame = frame
                self.background!.layer.cornerRadius = newSize / 2
                self.insertSubview(self.background!, atIndex: 0)
            }
        }
        
        self.background?.backgroundColor = UIColor.clearColor()
        if self.date != nil
        {
            var bgColor:UIColor = UIColor.clearColor()
            
            if isToday {
                bgColor = CalendarConstants.COLOR_RED
            }
            if selected {
                bgColor = CalendarConstants.COLOR_BLACK
            }
            
            self.background?.backgroundColor = bgColor
        }
    }
    
    //set label color for state
    private func setLabel(selected:Bool)
    {
        var color:UIColor = UIColor.blackColor()
        let fontSize:CGFloat = self.label!.font.pointSize
        var font:UIFont = UIFont.systemFontOfSize(fontSize)
        
        if self.date != nil
        {
            //set color for week days vs weekend days
            var dayOfWeek:Int = CalendarUtils.getDayOfWeek(date!)
            color = dayOfWeek == 1 || dayOfWeek == 7 ? CalendarConstants.COLOR_GREY : CalendarConstants.COLOR_BLACK
        }
        
        let isToday:Bool = self.cellIsToday()
        if selected || isToday {
            font = UIFont.boldSystemFontOfSize(fontSize)
            color = UIColor.whiteColor()
        }
        
        self.label?.textColor = color
        self.label?.font = font
    }
    
    //get if this cell is for today
    private func cellIsToday() -> Bool
    {
        var isToday:Bool = false
        if self.date != nil
        {
            let today:NSDate = NSDate()
            isToday = CalendarUtils.sameDay(self.date!, date2: today)
        }
        return isToday
    }
    
    //get if this cell is in the past
    func cellIsPast() -> Bool
    {
        let today:NSDate = NSDate()
        if self.cellIsToday() || self.date == nil {
            return false
        }
        
        return self.date!.compare(today) == NSComparisonResult.OrderedAscending
    }
    
    //show pulsing animation
    func animate()
    {
        if self.background != nil
        {
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
                
                self.background!.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
                }, completion: {(finished:Bool) -> Void in
            
                    UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
                        
                        self.background!.transform = CGAffineTransformIdentity
                        
                        }, completion: {(finished:Bool) -> Void in })
                    
                })
        }
    }
    
    //getter for the date
    func getDate() -> NSDate? {
        return self.date
    }
    
}