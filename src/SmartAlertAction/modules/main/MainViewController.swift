//
//  MainViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/2/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import MessageUI

class MainViewController: UITabBarController, UISplitViewControllerDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate,UITabBarControllerDelegate
 {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Init view controller for each tab
        var smartListsSplitController = UIStoryboard(name: "SmartLists", bundle: nil).instantiateInitialViewController() as UIViewController
//        smartListsSplitController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        smartListsSplitController.title = "Alerts"
//        smartListsSplitController.delegate = self
        smartListsSplitController.tabBarItem.image = UIImage(named: "icon_smartlist_off")
        smartListsSplitController.tabBarItem.selectedImage = UIImage(named: "icon_smartlist_on")
        
        var clientsSplitController = UIStoryboard(name: "Clients", bundle: nil).instantiateInitialViewController() as UISplitViewController
        clientsSplitController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        clientsSplitController.title = "Clients"
        clientsSplitController.delegate = self
        clientsSplitController.tabBarItem.image = UIImage(named: "icon_clients_off")
        clientsSplitController.tabBarItem.selectedImage = UIImage(named: "icon_clients_on")

//        var dashboardController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateInitialViewController() as UIViewController
//        dashboardController.tabBarItem.image = UIImage(named: "icon_dashboard_off")
//        dashboardController.tabBarItem.selectedImage = UIImage(named: "icon_dashboard_on")

        // remove application feature from wave 1
//        var applicationsController = UIStoryboard(name: "Applications", bundle: nil).instantiateInitialViewController() as UIViewController
//        applicationsController.tabBarItem.image = UIImage(named: "icon_applications_off")
//        applicationsController.tabBarItem.selectedImage = UIImage(named: "icon_applications_on")

        self.viewControllers = [smartListsSplitController, clientsSplitController]
        
        // set tintColor of tabBar to blue1
        self.tabBar.tintColor = RAColors.GRAY8
        self.tabBar.selectedImageTintColor = RAColors.BLUE1  // Bruce ** Color Change

        //self._sendLocalNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == UIEventSubtype.MotionShake {
            println("Shake detected!")
            _sendLocalNotification()
        }
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
//        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
//            if let topAsDetailController = secondaryAsNavController.topViewController as? AlertDetailTableViewController {
//                if topAsDetailController.alertDetail == nil {
//                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//                    return true
//                }
//            }
//        }
        return true
    }
    
    //send test local notification
    func _sendLocalNotification()
    {
        AlertService.getDetailsForAlert(Constants.DEFAULT_ALERT_ID, completionHandler: {(alert: AlertModel?, error: NSError?) -> Void in
            var notification:UILocalNotification = UILocalNotification()
            notification.category = Constants.NOTIFICATION_CATEGORY_DEFAULT
            notification.fireDate = NSDate(timeIntervalSinceNow: 5)
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            //notification.alertAction = "Alert Action"
            notification.alertBody = alert!.message
            notification.userInfo = NSDictionary(object: Constants.DEFAULT_ALERT_ID, forKey: "alertId")
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            println("show local notification")
        })
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        println(result)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var alertId = alertView.tag
        if buttonIndex == 0 {
            // close
        } else if buttonIndex == 1 {
            // Open
            self.showAlertDetails(alertId)
        } else if buttonIndex == 2 {
            // Call
            self.makeCall(alertId)
        } else if buttonIndex == 3 {
            // Email
            self.showMailComposeView(alertId)
        }
    }
    
    // MARK: -
    
    func showNotificationAlert(alertId:Int, title:String?, message:String)
    {
        dispatch_async(dispatch_get_main_queue(), {
            var alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Close")
            alertView.tag = alertId
            alertView.delegate = self
            alertView.addButtonWithTitle("Open")
            alertView.addButtonWithTitle("Call")
            alertView.addButtonWithTitle("Email")
            alertView.show()
        })
    }
    
    func showAlertDetails(alertId:Int)
    {
        // swith to Alerts tab
        self.selectedIndex = 0
        if let navigationController = selectedViewController as? UINavigationController {
            // pop to root view controller
            navigationController.popToRootViewControllerAnimated(false)
            // if presented some view (like contact), dismiss it
            if navigationController.presentedViewController != nil {
                navigationController.dismissViewControllerAnimated(false, completion: nil)
            }
            if let smartContainerViewController = navigationController.viewControllers[0] as? SmartContainerViewController {
                smartContainerViewController.showAlertDetails(alertId)
            }
        }
    }

    func showMailComposeView(alertId:Int)
    {
        println("initialize email")

        AlertService.getDetailsForAlert(alertId, completionHandler: {(alert: AlertModel?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                
                if MFMailComposeViewController.canSendMail() {
                    var mailComposeViewController = MFMailComposeViewController()
                    mailComposeViewController.setToRecipients([alert!.client!.email])
                    mailComposeViewController.mailComposeDelegate = self
                    
                    var splitViewController = self.selectedViewController as UISplitViewController
                    var viewController = splitViewController.viewControllers[0] as UINavigationController
                    viewController.presentViewController(mailComposeViewController, animated: true, completion: nil)
                }else{
                    UIAlertView(title: "", message: "Cannot send email", delegate: nil, cancelButtonTitle: "OK").show()
                }

            })
        })
    }
    
    func makeCall(alertId:Int)
    {
        println("initialize phone call")
        
        AlertService.getDetailsForAlert(alertId, completionHandler: {(alert: AlertModel?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().openURL(NSURL(string: "tel:" + alert!.client!.phone)!)
                return
            })
        })
    }
    
    //MARK: UITabBar Delegate
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController)  {
        
        if let splitViewController = self.viewControllers?[1] as? UISplitViewController {
            if let navigationViewController = splitViewController.viewControllers[0] as? UINavigationController {
                navigationViewController.popViewControllerAnimated(true)
                
            }
        }
    }
}
