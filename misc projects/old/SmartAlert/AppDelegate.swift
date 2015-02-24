//
//  AppDelegate.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-07.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        _registerLocalNotification()
        application.applicationSupportsShakeToEdit = true
        application.applicationIconBadgeNumber = 0
        
        //global styles
        UITabBar.appearance().selectedImageTintColor = UIColor.whiteColor()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    {
        var allowedTypes:UIUserNotificationType = notificationSettings.types
        //println(allowedTypes)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println(notification.category)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void)
    {
        application.applicationIconBadgeNumber--
        
        //get alert
        var alertId:String = (notification.userInfo as NSDictionary).valueForKey("alertId") as String
        
        if identifier != nil {
            if identifier == Constants.NOTIFICATION_ACTION_ID_CALL() {
                println("initialize phone call")
                
                dispatch_async(dispatch_get_main_queue(), {
                    var alert:AlertDetailsModel = DataUtils.getAlertDetails(alertId)
                    application.openURL(NSURL(string: "tel:" + alert.phone))
                })
            }
        }
        else {
            if self.window?.rootViewController.isKindOfClass(MainNavController) == true {
                (self.window?.rootViewController as MainNavController).showAlertDetails(alertId)
            }
        }
        
        //must be called when finished
        completionHandler()
    }
    
    //register test local notification
    func _registerLocalNotification()
    {
        var emailAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        emailAction.identifier = Constants.NOTIFICATION_ACTION_ID_EMAIL()
        emailAction.title = "Email"
        emailAction.activationMode = UIUserNotificationActivationMode.Background
        emailAction.destructive = false
        emailAction.authenticationRequired = false
        
        var callAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        callAction.identifier = Constants.NOTIFICATION_ACTION_ID_CALL()
        callAction.title = "Call"
        callAction.activationMode = UIUserNotificationActivationMode.Foreground
        callAction.destructive = false
        callAction.authenticationRequired = false
        
        var defaultCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        defaultCategory.identifier = Constants.NOTIFICATION_CATEGORY_DEFAULT()
        defaultCategory.setActions([callAction, emailAction], forContext: UIUserNotificationActionContext.Default)
        defaultCategory.setActions([callAction, emailAction], forContext: UIUserNotificationActionContext.Minimal)
        
        var types:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var categories:NSSet = NSSet(objects: defaultCategory)
        var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

}

