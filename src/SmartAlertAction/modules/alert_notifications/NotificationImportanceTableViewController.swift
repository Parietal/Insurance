//
//  NotificationImportanceTableViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/12/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

protocol NotificationImportanceDelegate{
    func onImportanceValueChanged(newValue:Int)
}

class NotificationImportanceTableViewController: UITableViewController,PageTransitionProtocol {
    
    let sectionTitles = ["SELECT AN IMPORTANCE"]
    
    // input params
    class var INPUT_PARAM_AGENT_ID:String { return "agentId" }
    
    var agentId:Int = 0
    
    var selectedLevel:Int = 0
    
    var delegate:NotificationImportanceDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AlertImportanceCell = tableView.dequeueReusableCellWithIdentifier("ImportanceCell", forIndexPath: indexPath) as AlertImportanceCell
        //cell.rateView.tintColor = RAColors.GRAY8
        //cell.rateView.rate = UInt(5 - indexPath.row)
        
        var notificationLevelString:String = ""
        let diamond = "\u{25C6}"
        
        var counter:Int
        
        for counter = 0; counter < Int(5 - indexPath.row); ++counter{
            notificationLevelString += diamond;
        }
        
        if(indexPath.row == 0){
            notificationLevelString += " only"
        }else{
            notificationLevelString += " or more"
        }        
        cell.rateView.text = notificationLevelString
        cell.rateView.sizeToFit()
        
        if self.selectedLevel == (5 - indexPath.row) {
            cell.checkImgv.hidden = false
        }
        else {
            cell.checkImgv.hidden = true
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.navigationController?.popViewControllerAnimated(true)
        self.setImportanceLevel(5 - indexPath.row)
        delegate?.onImportanceValueChanged(5 - indexPath.row)
    }
    
    
    func setImportanceLevel(level:Int){
        
        let settingsAdapter = CommonFunc.sharedInstanceSettings as SettingsAdapter
        var settings:Settings!
        settings = settingsAdapter.getSettings(agentId: self.agentId)
        if let aSettings = settings {
            settings.importanceLevel = NSNumber(integer: level)
        }
        else {
            settings = settingsAdapter.createSettings()
            settings.agentId = self.agentId
            settings.importanceLevel = NSNumber(integer: level)
        }
        settingsAdapter.insertSettings()
        
    }
    
    func loadImportanceLevel() -> Int{
        let settingsAdapter = CommonFunc.sharedInstanceSettings as SettingsAdapter
        var settings:Settings!
        settings = settingsAdapter.getSettings(agentId: self.agentId)
        if let aSettings = settings {
            return settings.importanceLevel.integerValue
        }
        else {
            // default level
            return 1
        }
    }
    
    
    func setInputParams(params: Dictionary<String, AnyObject>) {
        let agentId:Int = params[NotificationImportanceTableViewController.INPUT_PARAM_AGENT_ID] as Int;
        self.agentId = agentId;
        self.selectedLevel = self.loadImportanceLevel()
        self.tableView.reloadData()
    }

}
