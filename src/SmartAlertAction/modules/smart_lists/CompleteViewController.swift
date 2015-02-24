//
//  CompleteViewController.swift
//  SmartAlertAction
//
//  Created by Saurav on 04/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {

    var delegateDetail: [DelegateModel]?
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // show loading
        spinner.startAnimatingOnView(self.view)
        getCompleteData()

    }
    
    private func getCompleteData() {
        AlertService.getAllForAgent(Constants.DEFAULT_AGENT_ID, completionHandler: {(alerts:[AlertModel]?, error:NSError?) -> Void in
            
            // Get only Completed Alert, currently everything is residing in JSON, that's why below line of code is needed to fetch all the completedTask
            //Then reusing the DelegateModel for Completed task

            var filterAlert = alerts as Array!
            var filteredArray = filterAlert.filter( { (alert: AlertModel) -> Bool in
                return alert.isCompleted == true
            })
            
            //Also check whether user has marked any alert as finished/completed and whose Id will be saved in DB
            let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
            var alert_FromDB:[Alert]! = alertAdapter.getAllAlertDetail()
            
            if alert_FromDB != nil {
                
                for alert in filterAlert {
                    if alert_FromDB.count > 0 {
                        //Skip alerts which is already added in filteredArray by checking condition isCompleted == true
                        if !(alert.isCompleted) {
                            
                            
                            for (index, alertDB) in enumerate(alert_FromDB) {
                                if alert.id == alertDB.id && alertDB.status == "Completed" {
                                    
                                    let days = CommonFunc.daysBetweenDate(NSDate(), toDateTime: alertDB.date)
                                    if days == 0 {
                                        //Get note from Alert Entity from CoreData and replace in Alert from JSON
                                        alert.message = alertDB.finishNote
                                        //Got alert From DB and From JSON
                                        filteredArray.append(alert)
                                    }
                                    
                                    //Remove this alert
                                    alert_FromDB.removeAtIndex(index)
                                    break
                                }
                            }
                        }
                    }
                    
                    
                }
                
            }
            var delegateDetail_FILTER: [DelegateModel] = []
            
            for alertItem in filteredArray {
                var details:[DelegateDetailModel] = []
                
                
                let alert = alertItem as AlertModel
                var desc = alert.category?.subTitle
                var clientName = alert.client?.getFullName()
                //Sending Message in DelegateAgent for Complete Screen
                var delegateAgent:String = alert.message
                var rank:Int = alert.rank!
                
                var group:DelegateDetailModel = DelegateDetailModel(desc: desc!, clientName: clientName!, delegateAgent: delegateAgent, rank: rank)
                
                details.append(group)
                
                
                var isDelegateAdded = false
                for delegateObj in delegateDetail_FILTER {
                    let delegateModel = delegateObj as DelegateModel
                    
                    if delegateModel.name == alert.category?.title {
                        //Already we have this Delegate Model
                        //Append AlertModel in this
                        
                        delegateModel.details.append(group)
                        isDelegateAdded = true
                        break
                    }
                }
                if !isDelegateAdded {
                    var delegate:DelegateModel = DelegateModel(name: alert.category!.title, details: details)
                    delegateDetail_FILTER.append(delegate)
                    
                }
            }
            
            
            
            self.delegateDetail = delegateDetail_FILTER
            //Reload View
            self.setUI()
            // hide loading
            self.spinner.stopAnimatingOnView()
            
        })
    }
    private func getData() {
        
        DelegateService.getDetailsForDelegate(Constants.DEFAULT_AGENT_ID, completionHandler: {(delegates, error) -> Void in
            
            self.delegateDetail = delegates
            //Reload View
            self.setUI()
            // hide loading
            self.spinner.stopAnimatingOnView()
        })
    }
    private func setUI() {
        
        //Show only one TableView and group data according to alert type
        let tableView = getAlertTableView() as UITableView
        self.view.addSubview(tableView)
        
    }
    
    func getAlertTableView() -> Any {
        
        let tableViewWidth  = Int(self.view.frame.size.height)
        let height = Int(self.view.frame.size.height)
        var tableView = CompleteTableView(frame: CGRect(x: 0, y: 0, width: 320, height: height), style: UITableViewStyle.Plain)
        tableView.delegateAlert = self.delegateDetail
        
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;
        tableView.tableFooterView?.hidden = true
        tableView.tableFooterView = UIView(frame: CGRectZero)

        return tableView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
