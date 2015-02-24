//
//  SettingsTableViewController.swift
//  SmartAlertAction
//
//  Created by SunTeng on 9/3/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var notificationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notificationBtn.tintColor = RAColors.BLUE1  // Bruce ** Color Change
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            var indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showNotifications(sender: UIButton) {
        // Jump to System Settings of App
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Alert Notifications
        if indexPath.section == 0 {
            var notificationsController = UIStoryboard(name: "AlertNotifications", bundle: nil).instantiateInitialViewController() as AlertNotificationTableViewController
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                self.navigationController?.pushViewController(notificationsController, animated: true)
            }
            else{
                let detailNavigationVC = UINavigationController(rootViewController: notificationsController)
                self.splitViewController?.showDetailViewController(detailNavigationVC, sender: nil)
            }
        }
        
        if indexPath.section == 1
        {
            // show delegates page
            var delegateController:EditDelegatesViewController = UIStoryboard(name: "EditDelegates", bundle: nil).instantiateInitialViewController() as EditDelegatesViewController

            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                self.navigationController?.pushViewController(delegateController, animated: true)
            }
            else
            {
                let detailNC:UINavigationController = UINavigationController(rootViewController: delegateController)
                self.splitViewController?.showDetailViewController(detailNC, sender: nil)
            }
        }
        
        //PHM Set selected cell highlight color
        var cell:UITableViewCell? = self.tableView.cellForRowAtIndexPath(indexPath)
        var selectedCellView = UIView()
        selectedCellView.backgroundColor = RAColors.BLUE1
        selectedCellView.tintColor = UIColor.whiteColor()
        cell?.selectedBackgroundView = selectedCellView
        cell?.textLabel?.highlightedTextColor = UIColor.whiteColor()
        cell?.detailTextLabel?.highlightedTextColor = UIColor.whiteColor()

    }
    
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
