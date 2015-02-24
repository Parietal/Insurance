//
//  SmartlistsTableViewController.swift
//  InsuranceAgent
//
//  Created by Paul Yuan on 2014-08-08.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class SmartlistsTableViewController:UITableViewController
{
    
    enum SECTIONS : Int {
        case TODAY, PAST_DUE
    }
    
    var alerts:[SmartListsAlertModel] = [SmartListsAlertModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts = DataUtils.getSmartListsAlerts()
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var sectionAlerts:[SmartListsAlertModel] = _getAlertsForSection(indexPath.section)
        var selectedAlert:SmartListsAlertModel = sectionAlerts[indexPath.row]
        
        //show alert details view
        var navController:MainNavController = self.navigationController as MainNavController
        navController.showAlertDetails(selectedAlert.id)
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellIdentifier = "Cell"
        var cell:SmartlistsCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as SmartlistsCell
        if(cell == nil) {
            cell = SmartlistsCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        var sectionAlerts:[SmartListsAlertModel] = _getAlertsForSection(indexPath.section)
        var alert:SmartListsAlertModel = sectionAlerts[indexPath.row]
        cell!.update(alert)
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        var cellIdentifier = "Header"
        var cell:SmartlistsHeaderCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as SmartlistsHeaderCell
        if(cell == nil) {
            cell = SmartlistsHeaderCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        var title:String = ""
        switch section {
        case SECTIONS.PAST_DUE.toRaw():
            title = "Past Due"
        default:
            title = "Today"
        }
        cell!.update(title)
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        var sectionAlerts:[SmartListsAlertModel] = _getAlertsForSection(section)
        return sectionAlerts.count
    }
    
    //get all the alerts for a specified section
    func _getAlertsForSection(section:Int) -> [SmartListsAlertModel]
    {
        var sectionAlerts:[SmartListsAlertModel] = [SmartListsAlertModel]()
        for i in 0..<self.alerts.count {
            var alert:SmartListsAlertModel = self.alerts[i] as SmartListsAlertModel
            if section == SECTIONS.TODAY.toRaw() && !alert.isPastDue {
                sectionAlerts.append(alert)
            }
            else if section == SECTIONS.PAST_DUE.toRaw() && alert.isPastDue {
                sectionAlerts.append(alert)
            }
        }
        return sectionAlerts
    }
    
}