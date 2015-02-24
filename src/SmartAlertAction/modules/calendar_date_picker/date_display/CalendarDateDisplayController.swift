//
//  CalendarDateDisplayController.swift
//  CalendarDatePicker
//
//  Created by Paul Yuan on 2014-11-17.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class CalendarDateDisplayController:UIViewController
{
    
    @IBOutlet var label:UILabel?
    
    private var timer:NSTimer?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //setup label
        self.label?.font = UIFont.systemFontOfSize(12)
        self.label?.textColor = CalendarConstants.COLOR_BLACK
        
        //setup background
        let bg:UIView = UIView(frame: self.view.frame)
        let topColor:UIColor = UIColor.whiteColor()
        let bottomColor:UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        let gradientColors: Array <AnyObject> = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: Array <AnyObject> = [0.0, 1.0]
        
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = gradientColors
        gradient.locations = gradientLocations
        gradient.allowsEdgeAntialiasing = true
        bg.layer.insertSublayer(gradient, atIndex: 0)
        //bg.alpha = 0.9
        self.view.insertSubview(bg, atIndex: 0)
        
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    //show a date
    func show(date:NSDate)
    {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "hide", userInfo: nil, repeats: false)
        }
        
        self.updateDateLabel(date)
        self.view.hidden = false
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
            
            self.view.alpha = 1
            
            }, completion: {(finished:Bool) -> Void in })
    }
    
    //hide
    func hide()
    {
        self.timer?.invalidate()
        self.timer = nil
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
            
            self.view.alpha = 0
            
            }, completion: {(finished:Bool) -> Void in

                self.view.hidden = true
                
            })
    }
    
    //update the date label
    private func updateDateLabel(date:NSDate)
    {
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        let dateString:String = formatter.stringFromDate(date)
        self.label?.text = dateString
    }
    
}