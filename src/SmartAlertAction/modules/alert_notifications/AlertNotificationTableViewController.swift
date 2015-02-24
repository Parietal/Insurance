//
//  AlertNotificationTableViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/12/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class AlertNotificationTableViewController: UITableViewController,AlertNotificationSwitchCellDelegate,NotificationImportanceDelegate{
    
    let sectionTitles = ["IMPORTANCE THRESHOLD","RECEIVE NOTIFICATIONS FOR:"]
    
    var data:[AlertCategoryModel]?
    var agentId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CategoryService.getAllForAgent(Constants.DEFAULT_AGENT_ID, completionHandler: {(categories:[AlertCategoryModel]?, error:NSError?) -> Void in
            self.data = categories
            
            self.tableView.reloadData()
        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return data != nil ? data!.count : 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("AlertNotificationSelectionCell", forIndexPath: indexPath) as UITableViewCell
            
            var notificationLevelString:String = ""
            let diamond = "\u{25C6}"
            
            let settingsAdapter = CommonFunc.sharedInstanceSettings as SettingsAdapter
            var settings:Settings!
            settings = settingsAdapter.getSettings(agentId: self.agentId)
            if let aSettings = settings {
                var counter:Int
                
                for counter = 0; counter < settings.importanceLevel.integerValue; ++counter{
                    notificationLevelString += diamond;
                }
                
                if(settings.importanceLevel.integerValue == 5){
                    notificationLevelString += " only"
                }else{
                    notificationLevelString += " or more"
                }
            }
            else {
                // default level
                notificationLevelString = diamond + " or more"
            }
            println(notificationLevelString)
            
            (cell as AlertNotificationSelectionCell).detailLabel.text = notificationLevelString
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                (cell as AlertNotificationSelectionCell).titleLabel.text = "Notify me if alert is:"
            }else{
                (cell as AlertNotificationSelectionCell).titleLabel.text = "Notify me if:"
            }
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("AlertNotificationSwitchCell", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            (cell as AlertNotificationSwitchCell).titleLabel.text = data?[indexPath.row].title
            (cell as AlertNotificationSwitchCell).stateSwitch.on = (data?[indexPath.row].settings? != nil ? data![indexPath.row].settings!.receiveNotification : true)
            (cell as AlertNotificationSwitchCell).tag = indexPath.row
            (cell as AlertNotificationSwitchCell).delegate = self
            (cell as AlertNotificationSwitchCell).titleLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_16
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && indexPath.section == 0{
            self.performSegueWithIdentifier("ImportanceDetail", sender: nil)
        }
    }
    
    //MARK: - AlertNotificationSwitchCell Delegate
    
    func onSwitchStateChanged(index: Int, newState: Bool) {
        //index = your section datasource's index
        println("index : \(index)")
        self.data?[index].enableReceiveNotification(newState)
    }
    
    //MARK: - NotificationImportance Delegate
    func onImportanceValueChanged(newValue: Int) {
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dvc: AnyObject = segue.destinationViewController
        if dvc.isKindOfClass(NotificationImportanceTableViewController){
            (dvc as NotificationImportanceTableViewController).setInputParams([NotificationImportanceTableViewController.INPUT_PARAM_AGENT_ID: self.agentId])
        }
        
    }
    
    
}
