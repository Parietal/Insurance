//
//  MainTabBarController.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController:UITabBarController
{
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.tabBar.tintColor = RAColors.LIGHT_BLUE()
        self.tabBar.backgroundImage = UIImage(named: "tabbar_bg.png")
        self.tabBar.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = RAColors.LIGHT_BLUE()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.resignFirstResponder()
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController.navigationBarHidden = true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent!) {
        if motion == UIEventSubtype.MotionShake {
            println("Shake detected!")
            _sendLocalNotification()
        }
    }
    
    //send test local notification
    func _sendLocalNotification()
    {
        var alert:AlertDetailsModel = DataUtils.getAlertDetails(Constants.DEFAULT_ALERT_ID())
        var notification:UILocalNotification = UILocalNotification()
        notification.category = Constants.NOTIFICATION_CATEGORY_DEFAULT()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        //notification.alertAction = "Alert Action"
        notification.alertBody = alert.message
        notification.userInfo = NSDictionary(object: Constants.DEFAULT_ALERT_ID(), forKey: "alertId")
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        println("show local notification")
    }
    
    @IBAction func unwindToMain(s:UIStoryboardSegue) {
        
    }
    
}