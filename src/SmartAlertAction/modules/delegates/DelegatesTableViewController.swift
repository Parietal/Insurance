//
//  DelegatesTableViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/15/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import AddressBookUI

class DelegatesTableViewController: UITableViewController, UIAlertViewDelegate, AddDelegateTableViewDelegate {

    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var removeButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!

    // class constants
    let INDEX_NOT_FOUND: Int = -1

    var agentId: Int = Constants.DEFAULT_AGENT_ID

    var agentList:[String: [AgentModel]] = [:]
    var initialAlphabets:[String] = []

    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Allow Multiple Selection during Editing mode
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        // display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButton
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // show loading
        self.spinner.startAnimatingOnView(self.view)
        
        // get delegates from service
        DelegateService.getAllForAgent(self.agentId, completionHandler: { (delegates, error) -> Void in
            
            if delegates != nil {
                self.agentList = delegates!
                
                // sort agent name alphabets
                var alphabets:[String] = self.agentList.keys.array
                self.initialAlphabets = sorted(alphabets, { $0 < $1 })

                // reload client data
                self.tableView.reloadData()
            }
            
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
        // only two section
        return self.initialAlphabets.count + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section < self.initialAlphabets.count {
            return self.agentList[self.initialAlphabets[section]]!.count
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("delegateCell") as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "delegateCell")
        }

        if indexPath.section < self.initialAlphabets.count {
            var agentModels = self.agentList[self.initialAlphabets[indexPath.section]]
            var agentModel = agentModels![indexPath.row]
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
//            cell?.textLabel?.tintColor = UIColor.blackColor()
            cell?.textLabel?.text = agentModel.displayName

        } else {
            cell?.selectionStyle = UITableViewCellSelectionStyle.Default
//            cell?.textLabel?.tintColor = RAColors.MEDIUM_GRAY
            cell?.textLabel?.text = "Add Delegate..."
        }
        
        
        return cell!
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.section < self.initialAlphabets.count {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == self.initialAlphabets.count {
            var addDelegateController = UIStoryboard(name: "Delegates", bundle: nil).instantiateViewControllerWithIdentifier("AddDelegate") as AddDelegateTableViewController
            
            addDelegateController.delegate = self
            self.navigationController?.pushViewController(addDelegateController, animated: true)
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < self.initialAlphabets.count {
            return self.initialAlphabets[section]
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        for i in 0..<self.initialAlphabets.count {
            if initialAlphabets[i] == title {
                return i
            }
        }
        return self.INDEX_NOT_FOUND
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return Constants.ALPHABETS
    }

    // MARK: - AddDelegateTableViewDelegate
    
    func didSelectDelegate(delegate: AgentModel) {
        // TODO: call service to add delegate and refresh
        // show processing
        // call service
        // hide processing
    }
    
    // MARK: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        // Yes pressed
        if buttonIndex == 1 {
            performRemoveAction()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func editAction(sender: UIBarButtonItem) {
        self.setTableViewEditing(true, animated: true)
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        self.setTableViewEditing(false, animated: true)
    }
    
    @IBAction func removeAction(sender: UIBarButtonItem) {
        var selectedRows = self.tableView.indexPathsForSelectedRows()
        if selectedRows?.count > 0 {
            var alertView = UIAlertView(title: Constants.ALERT_TITLE, message: "Are you sure you want to remove selected delegates?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
            alertView.show()
        } else {
            UIAlertView(title: Constants.ALERT_TITLE, message: "Please select one first", delegate: nil, cancelButtonTitle: Constants.ALERT_BUTTON_OK).show()
        }
    }
    
    func setTableViewEditing(editing: Bool, animated: Bool) {
        self.tableView.setEditing(editing, animated: animated)
        
        if self.tableView.editing == true {
            self.navigationItem.leftBarButtonItem = self.cancelButton
            self.navigationItem.rightBarButtonItem = self.removeButton
        } else {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = self.editButton
        }
    }

    func performRemoveAction() {
        // TODO: integrate to service
        var selectedRows = self.tableView.indexPathsForSelectedRows()
        
        var rowsToRemove:[Int] = []
        
        for row in selectedRows! {
            if let indexPath = row as? NSIndexPath {
                rowsToRemove += [indexPath.row]
            }
        }
        // sort desc
        sort(&rowsToRemove, {$0 > $1})

        // delete rows
        for row in rowsToRemove {
//            self.data.removeAtIndex(row)
        }
        
        self.setTableViewEditing(false, animated: true)
        
        self.tableView.reloadData()
    }
}
