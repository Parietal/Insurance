//
//  FinishTableViewController.swift
//  SmartAlertAction
//
//  Created by Saurav on 28/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

protocol FinishAlertDelegate {
    func didFinishAlert()
}

class FinishTableViewController: UITableViewController,FinishNoteDelegate {
    
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    var finishTitlesList:[FinishTitlesModel] = []
    var alertId: Int = Constants.DEFAULT_ALERT_ID
    var alertDetail: AlertModel?
    var delegate: FinishAlertDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize.height = 304
        self.preferredContentSize.width = 280
        
        self.preferredContentSize = preferredContentSize
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.spinner.startAnimatingOnView(self.view)
        
        // get Finish Titles from service
        AlertService.finishTitles(Constants.DEFAULT_AGENT_ID, completionHandler: {(finishTitles: [FinishTitlesModel]?, error: NSError?) -> Void in
            
            self.finishTitlesList = finishTitles!
            self.tableView.reloadData()
            // hide loading
            self.spinner.stopAnimatingOnView()
        })
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finishTitlesList.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        var header :CustomTableViewHeaderFooterView = CustomTableViewHeaderFooterView()
        
        header.textLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        header.textLabel.textColor = RAColors.GRAY5
        header.contentView.backgroundColor = UIColor.whiteColor()
        
        header.textLabel.text = "Is the alert completed?"
        header.layer.borderWidth = 1.0
        header.layer.borderColor = RAColors.GRAY3.CGColor
        
        return header
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Is the alert completed?"
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("finishTitleCell", forIndexPath: indexPath) as? UITableViewCell
        
        // Configure the cell...
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "finishTitleCell")
        }
        
        let finishTitle: FinishTitlesModel = self.finishTitlesList[indexPath.row] as FinishTitlesModel
        
        
        cell?.textLabel?.text = finishTitle.title
        let titleAttribute = StringUtils.getFinishTitleAttribute(finishTitle.level)
        
        cell?.textLabel?.textColor = titleAttribute.color
        cell?.textLabel?.font = titleAttribute.font
        return cell!
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let finishTitle: FinishTitlesModel = self.finishTitlesList[indexPath.row] as FinishTitlesModel
            
        if (finishTitle.level == 1) {
            
            markAsComplete(finishTitle.title, isDestructive: false)
        }
        else if (finishTitle.level == 2) {
            
            // added date string to finish titile
            let finishString = finishTitle.title
            markAsComplete(finishString, isDestructive: true)
            
        }
        else if finishTitle.level == 3 {
                // Level 3 tells that it is sub title, go to another view
                let finishNoteVc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.CONTACT_FINSIH_NOTES_VC) as FinishNotesViewController
                finishNoteVc.alertDetail = alertDetail
                finishNoteVc.alertId = self.alertId
                finishNoteVc.delegate = self
                finishNoteVc.navigationItem.title = "Other..."
                self.navigationController?.pushViewController(finishNoteVc, animated: true)
        }
    }
    func markAsComplete(note:String, isDestructive:Bool) {
        let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
        var alert:Alert!
        
        alert = alertAdapter.getAlertDetail(alertDetail?.id, categoryId: alertDetail?.category?.id)
        
        if let alertObj = alert {
            
            if alertObj.status == "Completed" {
                //If it comes here, something is wrong, as it should not....as alert is finished already
                return
            }
        }
        else {
            
            //Create Alert Object in DB via CoreData(Entity - Alert)
            
            alert = alertAdapter.createAlert()
            alert.id = NSNumber(integer: self.alertId)

        }
        
        alert.date = NSDate()
        let dateString : String = StringUtils.convertDateToString(alert.date, format: Constants.FINISH_NOTE_DATE)
        
        alert.finishNote = dateString + " " + CommonFunc.capitalizeFirstChar(note)
        alert.status = isDestructive ? "NotCompleted" : "Completed"

        var category: AlertCategoryModel = alertDetail!.category!
        
        alert.categoryId = NSNumber(integer:category.id)
        alert.isDestructive = isDestructive
        
        alertAdapter.insertAlert()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        if self.delegate != nil {
            self.delegate?.didFinishAlert()
        }
    }
    
    //MARK: FinishNoteDelegate
    func didFinishNote()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        if self.delegate != nil {
            self.delegate?.didFinishAlert()
        }
    }
}
