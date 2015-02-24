//
//  AddDelegateTableViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/18/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

protocol AddDelegateTableViewDelegate {
    //func willSelectDelegate(delegate: AgentModel)
    func didSelectDelegate(delegate: AgentModel)
}

class AddDelegateTableViewController: UITableViewController {

    // class constants
    let INDEX_NOT_FOUND: Int = -1

    @IBOutlet var cancelButton: UIBarButtonItem!

    var delegate: AddDelegateTableViewDelegate?

    var agentId: Int = 0
    
    var agentList:[String: [AgentModel]] = [:]
    var initialAlphabets:[String] = []

    // activity indicator
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // display an cancel button
        self.navigationItem.rightBarButtonItem = self.cancelButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // show loading
        self.spinner.startAnimatingOnView(self.view)
        
        // get candidates from service
        DelegateService.getCandiates({ (agents, error) -> Void in
            
            if let agents = agents {
                self.agentList = agents

                // sort agent name alphabets
                var alphabets:[String] = self.agentList.keys.array
                self.initialAlphabets = sorted(alphabets, { $0 < $1 })

                // reload agent data
                self.tableView.reloadData()
                
                // hide loading
                self.spinner.stopAnimatingOnView()
            } else {
                var alertController = UIAlertController(title: Constants.ALERT_NETWORK_ERROR_MSG, message: nil, preferredStyle:.Alert)
                
                var action = UIAlertAction(title: "OK", style: .Default) { (action) in
                    //self.navigationController?.popViewControllerAnimated(true)
                }
                
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return initialAlphabets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.agentList[self.initialAlphabets[section]]!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("delegateCell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "delegateCell")
        }
        
        // get agent models
        var agentModels = self.agentList[self.initialAlphabets[indexPath.section]]
        var agentModel = agentModels![indexPath.row]

        cell?.textLabel?.text = agentModel.getFullName()
        // TODO: set delegate who already selected in gray font color, the rest in black
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        // get agent models
        var agentModels = self.agentList[self.initialAlphabets[indexPath.section]]
        var agentModel = agentModels![indexPath.row]
        
        self.delegate?.didSelectDelegate(agentModel)
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Table section settings
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.initialAlphabets[section]
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
    
}
