//
//  AllAgentsViewController.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-11-25.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import Foundation
import UIKit

protocol AllAgentsViewControllerDelegate {
    func allAgentsOnAgentSelected(agent:AgentModel) -> Bool
}

class AllAgentsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate
{
    
    class private var CELL_REUSE_ID : String { return "Cell" }
    
    @IBOutlet var tableView:UITableView?
    
    var delegate:AllAgentsViewControllerDelegate?
    
    private var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    private var agents:[String:[AgentModel]] = [String:[AgentModel]]()
    private var filteredAgents:[String:[AgentModel]] = [String:[AgentModel]]()
    private var isSearching:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ? "Add Delegate to List" : "Delegates"
        
        //initialize search results collection
        for letter in Constants.ALPHABETS {
            self.filteredAgents[letter.lowercaseString] = [AgentModel]()
        }
        
        self.tableView?.hidden = true
        self.tableView?.tintColor = RAColors.BLUE1
        
        let cellNib:UINib = UINib(nibName: "AllAgentsCell", bundle: nil)
        self.tableView?.registerNib(cellNib, forCellReuseIdentifier: AllAgentsViewController.CELL_REUSE_ID)
        self.searchDisplayController?.searchResultsTableView.registerNib(cellNib, forCellReuseIdentifier: AllAgentsViewController.CELL_REUSE_ID)
        
        self.searchDisplayController?.searchBar.delegate = self
        definesPresentationContext = true
        
        //add cancel button for iphone
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
        {
            let cancel:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "onCancel:")
            self.navigationItem.leftBarButtonItem = cancel
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.spinner.startAnimatingOnView(self.view)
        DelegateService.getAllCandiates2({(agents:[String:[AgentModel]]?, error:NSError?) -> Void in
            
            self.spinner.stopAnimatingOnView()
            self.agents = agents!
            self.tableView?.reloadData()
            self.tableView?.hidden = false
            
        })
        
        //listener for keyboard events
        let notifCtr = NSNotificationCenter.defaultCenter()
        notifCtr.addObserver(self, selector: "keyboardDismissed", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let notifCtr = NSNotificationCenter.defaultCenter()
        notifCtr.removeObserver(self)
    }
    
    func keyboardDismissed() {
        self.searchDisplayControllerDidEndSearch(self.searchDisplayController!)
    }
    
    func onCancel(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.ALPHABETS.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let letter:String = Constants.ALPHABETS[section].lowercaseString
        let list:[AgentModel]? = self.isSearching ? self.filteredAgents[letter] : self.agents[letter]
        return list == nil ? 0 : list!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:AllAgentsCell? = tableView.dequeueReusableCellWithIdentifier(AllAgentsViewController.CELL_REUSE_ID) as? AllAgentsCell

        if cell == nil {
            cell = AllAgentsCell(style: UITableViewCellStyle.Default, reuseIdentifier: AllAgentsViewController.CELL_REUSE_ID)
        }
        
        let agent:AgentModel? = self.getAgentFromIndexPath(indexPath)
        cell?.agent = agent
        
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UITableViewHeaderFooterView = UITableViewHeaderFooterView()
        view.textLabel.text = Constants.ALPHABETS[section].uppercaseString
        return view
    }
    
    //make sure that index titles are all in uppercase
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        var titles:[String] = []
        if !self.isSearching
        {
            for letter in Constants.ALPHABETS {
                titles.append(letter.uppercaseString)
            }
        }
        return titles
    }
    
    //mapping indices to sections
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let agent:AgentModel? = self.getAgentFromIndexPath(indexPath)
        let isDuplicate:Bool = self.delegate == nil ? false : self.delegate!.allAgentsOnAgentSelected(agent!)
        if isDuplicate
        {
            self.searchDisplayControllerDidEndSearch(self.searchDisplayController!)
            let msg:String = "Sorry, " + agent!.displayName + " is already one of your delegates, please select another agent to add."
            let alert:UIAlertController = UIAlertController(title: nil, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
            
            let ok:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {(action:UIAlertAction!) -> Void in })
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //get the agent model from a NSIndexPath
    private func getAgentFromIndexPath(indexPath:NSIndexPath) -> AgentModel?
    {
        let letter:String = Constants.ALPHABETS[indexPath.section].lowercaseString
        let list:[AgentModel] = self.isSearching ? self.filteredAgents[letter]! : self.agents[letter]!
        let agent:AgentModel? = list[indexPath.row]
        return agent
    }
    
    /**** delegate methods ****/
    func searchDisplayControllerDidBeginSearch(controller: UISearchDisplayController)
    {
        self.isSearching = true
    }
    
    func searchDisplayControllerDidEndSearch(controller: UISearchDisplayController) {
        self.isSearching = false
        controller.active = false
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        return true
    }
    
    //case insensitive search for first and last names
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        for pair in self.agents
        {
            let letter:String = pair.0
            let list:[AgentModel] = pair.1
            
            var matches:[AgentModel] = [AgentModel]()
            for agent in list
            {
                let fNameMatch:Bool = agent.fName.lowercaseString.rangeOfString(searchString.lowercaseString) != nil
                let lNameMatch:Bool = agent.lName.lowercaseString.rangeOfString(searchString.lowercaseString) != nil
                if fNameMatch || lNameMatch {
                    matches.append(agent)
                }
            }
            self.filteredAgents[letter] = matches
        }
        return true
    }
    
}