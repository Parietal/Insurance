//
//  AppDelegate.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-08-27.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        
        MQALogger.startNewSessionWithApplicationKey("99e3dcd1381a9abce7b385bcd3b0648adc903d32")
        MQALogger.settings().defaultUser = "abhidubey@in.ibm.com"
        
        if let window = self.window {
            window.rootViewController = AuthenticationController()
        }
        
        // Override point for customization after application launch.
        var application = UIApplication.sharedApplication()
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) == true {
            var settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil)
            application.registerUserNotificationSettings(settings)
        } else {
            var settings = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(settings)
        }
        
        //PHM Check settings and set values where appropriate
        let settingDefaults = NSUserDefaults.standardUserDefaults()
        if(settingDefaults.objectForKey("resetData") == nil){
            settingDefaults.setBool(false, forKey: "resetData")
        }
        if(settingDefaults.objectForKey("colorScheme") == nil){
            settingDefaults.setValue("blue", forKey: "colorScheme")
        }
        if(settingDefaults.objectForKey("dataSetType") == nil){
            settingDefaults.setValue("policy", forKey: "dataSetType")
        }
        settingDefaults.registerDefaults(["dataSource": "local"])
        
        settingDefaults.synchronize()
        
        //PHM read the resetData Setting
        var resetDataSettingsValue:Bool = NSUserDefaults.standardUserDefaults().objectForKey("resetData") as Bool
        
        if(resetDataSettingsValue){
            let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
            alertAdapter.cleanAlertTable()
        
            let categoryAdapter = CommonFunc.sharedInstanceCategory as CategoryAdapter
            categoryAdapter.cleanCategoryTable()
        
            let settingsAdapter = CommonFunc.sharedInstanceSettings as SettingsAdapter
            settingsAdapter.cleanSettingsTable()

            let delegateAdapter = CommonFunc.sharedInstanceDelegate as DelegateAdapter
            delegateAdapter.cleanDelegateTable()

            //println("erased");
            
            //PHM set settings switch back to off.
            settingDefaults.setBool(false, forKey: "resetData")
            settingDefaults.synchronize()
        }
        
        _registerLocalNotification()

        application.applicationIconBadgeNumber = 0
        application.applicationSupportsShakeToEdit = true
        
        // Bruce ** Globally set the UIBarButtonItem tint color
        UIBarButtonItem.appearance().tintColor = RAColors.BLUE1
        UIButton.appearance().tintColor = RAColors.BLUE1
        UINavigationBar.appearance().tintColor = RAColors.BLUE1
        
        return true
    }
    
    //lock to landscape for ipads and portrait for iphones
    // removed for fixing 15027
/*    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow) -> Int
    {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue | UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
        } else {
            
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue | UIInterfaceOrientationMask.LandscapeRight.rawValue)
        }
    }
*/
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

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        // TODO: Remote Notification
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // TODO: Remote Notification
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        println("handleActionWithIdentifier")
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("didReceiveLocalNotification")
        println(notification.debugDescription)
        application.applicationIconBadgeNumber--
        if let userInfo: NSDictionary = notification.userInfo {
            if let alertId: NSNumber = userInfo.valueForKey("alertId") as? NSNumber {
                
                
                if self.window?.rootViewController?.presentedViewController?.isKindOfClass(MainViewController) == true {
                    
                    // Task 15336 - Remove alertView when shake occurs and app is not put in background
                    if application.applicationState != UIApplicationState.Active {
                        (self.window?.rootViewController?.presentedViewController as MainViewController).showAlertDetails(alertId.integerValue)
                    }
                    /*
                    if application.applicationState == UIApplicationState.Active {
                        var appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as String
                        (self.window?.rootViewController?.presentedViewController as MainViewController).showNotificationAlert(alertId.integerValue, title: appName, message: notification.alertBody!)
                    } else {
                        (self.window?.rootViewController?.presentedViewController as MainViewController).showAlertDetails(alertId.integerValue)
                    }
                    */
                    
                }
            }
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void)
    {
        application.applicationIconBadgeNumber--
        
        //get alert
        if let userInfo: NSDictionary = notification.userInfo {
            if let alertId: NSNumber = userInfo.valueForKey("alertId") as? NSNumber {
                if let mainViewController = self.window?.rootViewController?.presentedViewController as? MainViewController {
                    if identifier != nil {
                        if identifier == Constants.NOTIFICATION_ACTION_ID_CALL {
                            mainViewController.makeCall(alertId.integerValue)
                        } else if identifier == Constants.NOTIFICATION_ACTION_ID_EMAIL {
                            mainViewController.showMailComposeView(alertId.integerValue)
                        }
                    }
                    else {
                        mainViewController.showAlertDetails(alertId.integerValue)
                    }
                }
            }
        }
        
        //must be called when finished
        completionHandler()
    }

    //register test local notification
    func _registerLocalNotification()
    {
        var emailAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        emailAction.identifier = Constants.NOTIFICATION_ACTION_ID_EMAIL
        emailAction.title = "Email"
        emailAction.activationMode = UIUserNotificationActivationMode.Foreground
        emailAction.destructive = false
        emailAction.authenticationRequired = false
        
        var callAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        callAction.identifier = Constants.NOTIFICATION_ACTION_ID_CALL
        callAction.title = "Call"
        callAction.activationMode = UIUserNotificationActivationMode.Foreground
        callAction.destructive = false
        callAction.authenticationRequired = false
        
        var defaultCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        defaultCategory.identifier = Constants.NOTIFICATION_CATEGORY_DEFAULT
        defaultCategory.setActions([callAction, emailAction], forContext: UIUserNotificationActionContext.Default)
        defaultCategory.setActions([callAction, emailAction], forContext: UIUserNotificationActionContext.Minimal)
        
        var types:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var categories:NSSet = NSSet(objects: defaultCategory)
        var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "IBM.SmartAlertAction" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SmartAlertAction", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SmartAlertAction.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

