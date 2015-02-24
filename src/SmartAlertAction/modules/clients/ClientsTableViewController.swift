//
//  ClientsTableViewController.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 2014-11-27.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ClientsTableViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {

    // class constants
    let CLIENT_ALERT_DISABLED: String = "Alerts Disabled"
    let INDEX_NOT_FOUND: Int = -1
    
    let RECORD_NOT_FOUND = -1
    let ALERTS_DISABLED = 0
    let ALERTS_ENABLED = 1
    
    class var INPUT_PARAM_CLIENT_ID:String { return "clientId" }
    
    var clientsWithDisabledAlerts = [NSManagedObject]()
    
    var clientId = 0;
    
    var showAlertDisabled = false
    
    var selClientAlertStatus = false
    
    // ui controls
    @IBOutlet var clientSearchBar: UISearchBar!
    
    // init client list & initial alphabets
    var clientList: [String: [ClientModel]] = [:]
    //    var clientIdNamePair: [Int: String] = [:]
    var initialAlphabets: [String] = []
    
    // search results
    var searchResultList: [String: [ClientModel]] = [:]
    var searchResultAlphabets: [String] = []
    
    // activity indicator
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    var clientArray: [ClientModel]?
    
    @IBOutlet var tableView:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.sectionIndexColor = RAColors.BLUE1  // Bruce ** Color Change
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // hide search bar
        // self.tableView.contentOffset = CGPointMake(0, RASizes.SEARCH_BAR_HEIGHT)
        
        // load client data
        self.loadData()
        self.getClients()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
        
        self.searchDisplayController?.searchResultsTableView.reloadData()
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
            self.tableView.reloadData()
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell: UITableViewCell?
        // header.bottomSeparatorColor = RAColors.GRAY5
        self.tableView.separatorColor = RAColors.GRAY3
        return 44
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.searchResultAlphabets.count
        } else {
            return self.clientList.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
        cell.textLabel?.attributedText = firstAttributedString
        
        cell.detailTextLabel?.font = RAFonts.CLIENT_LIST_FNAME
        cell.detailTextLabel?.textColor = RAColors.GRAY7
        
        var alertStatus = fetchAlertStatus(self.clientId)
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.searchResultList[self.searchResultAlphabets[section]]!.count
        } else {
            return self.clientList[self.initialAlphabets[section]]!.count
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.initialAlphabets[section]
    }

    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        for i in 0..<self.initialAlphabets.count {
            if initialAlphabets[i] == title {
                return i
            }
        }
        return self.INDEX_NOT_FOUND
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return Constants.ALPHABETS
    }
    
    // MARK: - Table search bar
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Search can be by Client Name or Policy Number,
        
        var searchResult = [String:[ClientModel]]()
        
        for clientA in self.clientArray! {
            
            for product in clientA.products
            {
                var id_InString = String(product.policyId)
                println(id_InString)
                if id_InString.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil ||
                    id_InString.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
                {
                    //Got some policy,
                    //Now get client Name
                    for (initial:String, list:[ClientModel]) in self.clientList
                    {
                        var filtedList = [ClientModel]()
                        for client in list {
                            
                            if clientA.id == client.id {
                                //Got Client
                                filtedList.append(client)
                                break
                            }
                        }
                        if filtedList.count > 0
                        {
                            searchResult[initial] = filtedList
                            break
                        }
                    }
                    
                }
                
            }
            
        }
        for (initial:String, list:[ClientModel]) in self.clientList
        {
            var filtedList = [ClientModel]()
            for client in list
            {
                if client.fName.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil ||
                    client.lName.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
                {
                    filtedList.append(client)
                }
            }
            
            if filtedList.count > 0
            {
                searchResult[initial] = filtedList
            }
        }
        
        
        
        self.searchResultList = searchResult
        var alphabets:[String] = searchResult.keys.array
        self.searchResultAlphabets = sorted(alphabets, { $0 < $1 })
        
        self.searchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.backgroundColor = RAColors.GRAY4 //abhi ** color for search background
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation data params
    
    func setInputParams(params: Dictionary<String, AnyObject>) {
        if let id = params[ClientsTableViewController.INPUT_PARAM_CLIENT_ID]! as? Int {
            self.clientId = id
        }
    }
    
    func fetchAlertStatus(clientId: Int)-> Int{
        
        var showAlertsDisabled = -1
        
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

                if(self.clientId == id){
                    let status = client.valueForKey("showAlerts") as NSNumber
                    
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //*******************************//
        
        //        UIAlertView(title: "", message: "Function not yet available", delegate: nil, cancelButtonTitle: "OK").show()
        //
        //*********************************//
        
        // get client models
        var clientModels: [ClientModel]?
        if tableView == self.searchDisplayController?.searchResultsTableView {
            clientModels = self.searchResultList[self.searchResultAlphabets[indexPath.section]]
        } else {
            clientModels = self.clientList[self.initialAlphabets[indexPath.section]]
        }
        var clientModel = clientModels![indexPath.row]
        
        var masterDetailController = UIStoryboard(name: "Clients", bundle: nil).instantiateViewControllerWithIdentifier("MasterDetailView") as MasterTableViewController
        
        masterDetailController.setInputParams([MasterTableViewController.INPUT_PARAM_CLIENT_ID: clientId])
        
        self.clientId = clientModel.id
        
        masterDetailController.clientId = self.clientId
        masterDetailController.showAlertStatus = clientModel.settings!.showAlert
        
        self.navigationController?.pushViewController(masterDetailController, animated: true)
        
    }
    
    @IBAction func settingsTapped(sender: AnyObject) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateViewControllerWithIdentifier("AlertNotification") as UIViewController
            
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
    }


}


