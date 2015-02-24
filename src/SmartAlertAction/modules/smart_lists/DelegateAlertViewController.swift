//
//  DelegateAlertViewController.swift
//  DelegateAlerts
//
//  Created by Saurav on 13/10/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit

class DelegateAlertViewController: UIViewController,ButtonTapDelegate {

    var scrollView: UIScrollView!
    var delegateDetail: [DelegateModel]?
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    var isAlertCompleted: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.None;

        self.title = "Delegate"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // show loading
        spinner.startAnimatingOnView(self.view)
        
        if isAlertCompleted {
            getCompleteData()
        }
        else {
            getData()
        }
    }
    
    private func getCompleteData() {
        AlertService.getAllForAgent(Constants.DEFAULT_AGENT_ID, completionHandler: {(alerts:[AlertModel]?, error:NSError?) -> Void in
            
            // Get only Completed Alert, currently everything is residing in JSON, that's why below line of code is needed to fetch all the completedTask
            //Then reusing the DelegateModel for Completed task
            
            //Format
            /* [
                "RETENTION" {
                    //Delegate Model1,
                    //DelegateModel2,
                        .
                        .
                        etc
                }
                "OTHER" {
                    //Delegate Model1,
                    //DelegateModel2,
                        .
                        .
                        etc
                }
                .
                .
                etc
            ]

*/
            if let filterAlert = alerts {
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
                                    if alert.id == alertDB.id  && alertDB.status == "Completed"{
                                        //Get time when this alert was filed
                                        //If it is more than 24 hour, don't show in Complete screen
                                        
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
            }
            // hide loading
            self.spinner.stopAnimatingOnView()

        })
    }
    private func getData() {
        
        DelegateService.getDetailsForDelegate(Constants.DEFAULT_AGENT_ID, completionHandler: {(delegates, error) -> Void in
            
            var jsonDelegateModel:[DelegateModel] = delegates!
            //merge data
            ///get datas form coredata
            let delegateAdapter = CommonFunc.sharedInstanceDelegate as DelegateAdapter
            let delegateEntities:[Delegate]? = delegateAdapter.getDelegates(Constants.DEFAULT_AGENT_ID)
            
            if delegateEntities != nil {
                for delegate in delegateEntities! {
                    var detail:DelegateDetailModel? = DelegateDetailModel(desc: delegate.desc, clientName: delegate.clientName, delegateAgent: delegate.delegateAgent, rank: delegate.rank.integerValue)
                    for delegateModel in jsonDelegateModel {
                        if delegateModel.name == delegate.category.componentsSeparatedByString(" ")[0].uppercaseString {
                            delegateModel.details.append(detail!)
                            detail = nil
                            break
                        }
                    }
                    if detail != nil {
                        let delegateModel = DelegateModel(name: delegate.category, details: [detail!])
                        jsonDelegateModel.append(delegateModel)
                    }
                }
            }
            self.delegateDetail = jsonDelegateModel

            //Reload View
            self.setUI()
            // hide loading
            self.spinner.stopAnimatingOnView()
        })
    }
    private func setUI() {
    
        scrollView = getScrollView() as UIScrollView
        self.view.addSubview(scrollView)
        
        for index in 0...self.delegateDetail!.count - 1 {

            let tableView = getAlertTableView(index) as UITableView
            scrollView.addSubview(tableView)
            scrollView.contentSize = CGSize(width: tableView.frame.origin.x + tableView.frame.size.width, height: tableView.frame.size.height)
        }
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Tap Delegate
    func didTapButtonAtIndex(index:Int,tableIndex:Int) {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.AGENT_COLLECTIONVC_iPHONE) as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else {
            let subView = scrollView.subviews
            
            for view in subView {
                
                if view.tag == tableIndex && view.isKindOfClass(AlertTableView) {
                    
                    let tableView = view as AlertTableView
                    
                    var rect = tableView.convertRect(tableView.rectForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)), toView: tableView)
                    
                    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
                    
                    if let cellFound = cell {
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.AGENT_COLLECTIONVC_iPAD) as AgentImageCollectionViewController
                        vc.modalPresentationStyle = .Popover
                        vc.preferredContentSize   = CGSizeMake(900, 120)
                        
                        rect.origin.y += 60.0
                        let aPopover =  UIPopoverController(contentViewController: vc)
                        aPopover.presentPopoverFromRect(rect, inView: tableView, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
                        break
                    }
                    
                }
            }

        }
       
    }
    
    //MARK: - UIs
    func getScrollView() -> Any {
    
        if scrollView == nil {
            var scrollVw = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            scrollVw.backgroundColor = UIColor.clearColor()
            scrollVw.scrollEnabled = true
            scrollVw.showsHorizontalScrollIndicator = true
            scrollVw.showsVerticalScrollIndicator = true
            scrollVw.setTranslatesAutoresizingMaskIntoConstraints(false)
            return scrollVw
        }
        else {

            return scrollView
        }

    }
    
    func getAlertTableView(index:Int) -> Any {
    
        //let tableViewWidth = Int(scrollView.frame.size.width/3.2)
        let tableViewWidth  = 320
        var startX = index * tableViewWidth
        let height = Int(scrollView.frame.size.height)
        var tableView = AlertTableView(frame: CGRect(x: startX, y: 0, width: tableViewWidth, height: height), style: UITableViewStyle.Plain)
        tableView.delegateAlert = self.delegateDetail![index]
        tableView.isAlertCompleted = isAlertCompleted
        tableView.tag = index
        tableView.buttonTapDelegate = self
        
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;

        return tableView
    }

}
