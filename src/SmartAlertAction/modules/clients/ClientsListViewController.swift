//
//  ClientsListViewController.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 27/11/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ClientsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {
    
    @IBOutlet var clientsTableView:UITableView!
    
    private var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    private var clients:[String:[ClientModel]] = [String:[ClientModel]]()
    private var filteredAgents:[String:[ClientModel]] = [String:[ClientModel]]()
    private var isSearching:Bool = false
    
    var clientId = 0;
    
    // init client list & initial alphabets
    var clientList: [String: [ClientModel]] = [:]
    //    var clientIdNamePair: [Int: String] = [:]
    var initialAlphabets: [String] = []
    
    // search results
    var searchResultList: [String: [ClientModel]] = [:]
    var searchResultAlphabets: [String] = []
    
    var clientArray: [ClientModel]?
    
    // class constants
    let CLIENT_ALERT_DISABLED: String = "Alerts Disabled"
    let INDEX_NOT_FOUND: Int = -1
    
    let RECORD_NOT_FOUND = -1
    let ALERTS_DISABLED = 0
    let ALERTS_ENABLED = 1
    
    class var INPUT_PARAM_CLIENT_ID:String { return "clientId" }
    
    var clientsWithDisabledAlerts = [NSManagedObject]()
    
    var showAlertDisabled = false
    
    var selClientAlertStatus = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.clientsTableView.sectionIndexColor = RAColors.BLUE1  // Bruce ** Color Change
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // hide search bar
        //    self.clientsList.contentOffset = CGPointMake(0, RASizes.SEARCH_BAR_HEIGHT)
        
        // load client data
        self.loadData()
        self.getClients()

    }
    
    func loadData() {
        // start animation
        self.spinner.startAnimatingOnView(self.view)
        
        ClientService.getAllForAgent(Constants.DEFAULT_AGENT_ID, completionHandler: {(clients:[String:[ClientModel]]?, error:NSError?) -> Void in
            
            // assigan to clients
            self.clientList = clients!
            
            // sort client name alphabets
            var alphabets:[String] = self.clientList.keys.array
            self.initialAlphabets = sorted(alphabets, { $0 < $1 })
            
            // reload table data
            self.clientsTableView.reloadData()
            
            // stop animation
            self.spinner.stopAnimatingOnView()
        })
    }
    
    func getClients() {
        //    class func getDetailsForAllClient(clientId:Int, completionHandler: (clients:[ClientModel]?, error:NSError?) -> Void) -> Bool
        
        ClientService.getDetailsForAllClient(self.clientId, completionHandler: {(clients:[ClientModel]?, error:NSError?) -> Void in
            
            // assign to client detail
            self.clientArray = clients
            
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.ALPHABETS.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let letter:String = Constants.ALPHABETS[section].lowercaseString
        let list:[ClientModel]? = self.isSearching ? self.filteredAgents[letter] : self.clientList[letter]
        return list == nil ? 0 : list!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UITableViewHeaderFooterView = UITableViewHeaderFooterView()
        view.textLabel.text = Constants.ALPHABETS[section].uppercaseString
        return view
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("clientCell") as UITableViewCell!
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier:"clientCell")
        }
        
        // get client models
        var clientModels: [ClientModel]?
        if tableView == self.searchDisplayController?.searchResultsTableView {
            clientModels = self.searchResultList[self.searchResultAlphabets[indexPath.section]]
        } else {
            clientModels = self.clientList[self.initialAlphabets[indexPath.section]]
        }
        var clientModel = clientModels?[indexPath.row]
        
        self.clientId = clientModel!.id
        
        // creating attributed stirngs for last name to be in bold font
        var firstName: String = clientModel!.fName + " "
        var fname_attrs = [NSFontAttributeName : RAFonts.CLIENT_LIST_FNAME]
        var firstAttributedString = NSMutableAttributedString(string:"\(firstName)", attributes:fname_attrs)
        
        var lastName: String = clientModel!.lName
        var lname_attrs = [NSFontAttributeName : RAFonts.CLIENT_LIST_LNAME]
        var lastAttributedString = NSMutableAttributedString(string:"\(lastName)", attributes:lname_attrs)
        
        firstAttributedString.appendAttributedString(lastAttributedString)
        cell.textLabel.attributedText = firstAttributedString
        
        cell.detailTextLabel?.font = RAFonts.CLIENT_LIST_FNAME
        cell.detailTextLabel?.textColor = RAColors.GRAY7
        
        var alertStatus = fetchAlertStatus(self.clientId)
        
        //   println("fetchAlertStatus....\(alertStatus)")
        
        switch(alertStatus){
        case RECORD_NOT_FOUND:
            if clientModel?.settings?.showAlert == true {
                cell.detailTextLabel?.text = ""
            } else {
                cell.detailTextLabel?.text = self.CLIENT_ALERT_DISABLED
            }
            break
        case ALERTS_ENABLED:
            cell.detailTextLabel?.text = ""
            clientModel?.settings?.showAlert = true
            break
        case ALERTS_DISABLED:
            cell.detailTextLabel?.text = self.CLIENT_ALERT_DISABLED
            clientModel?.settings?.showAlert = false
            break
        default:
            break
        }
        
        return cell
    }
    
    func fetchAlertStatus(clientId: Int)-> Int{
        
        var showAlertsDisabled = -1
        
        //    println("Input client id....\(clientId)")
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchReq = NSFetchRequest(entityName: "ClientAlerts")
        
        //3
        var error : NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchReq, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            clientsWithDisabledAlerts = results
            
            for index in 0..<clientsWithDisabledAlerts.count{
                var client: NSManagedObject = self.clientsWithDisabledAlerts[index]
                let id : Int = client.valueForKey("id") as Int
                
                //                println("Id fetched from  DB....\(id)")
                
                if(self.clientId == id){
                    let status = client.valueForKey("showAlerts") as NSNumber
                    
                    //                    println("status ....\(status)")
                    
                    if(status == 1){
                        return ALERTS_ENABLED
                    }else{
                        return ALERTS_DISABLED
                    }
                    
                }
            }
            
            
        }else{
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        return showAlertsDisabled
        
    }
    
}
