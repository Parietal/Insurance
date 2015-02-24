//
//  SmartListsViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/13/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class SmartListsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SmartListViewCellDelegate, ContactViewDelegate, AgentImageViewDelegate, CalendarDatePickerControllerDelegate, RecommendationDelegate
{
    
    @IBOutlet var collectionView: UICollectionView?

    let reuseIdentifier = "SmartListItemCell"
    let nodataReuseIdentifier = "NoDataCell"

    private var showTip:Bool = false

    var data: [String: AlertCategoryViewModel] = [:]
    var agentBook: AgentBookModel?
    var allCategory = "All"
    var selectedCategory = "All"
    var selectedOtherSubCategory = ""
    var otherSubCategory:[String:AlertCategoryViewModel] = [:]
    
    var alertId: Int?
    
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    private var popoverController:UIPopoverController?

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            allCategory = "All Alerts"
        }

        // Do any additional setup after loading te view.
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Category", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("category:"))
        }
        
        self.collectionView?.backgroundColor = RAColors.LIGHT_GRAY
        // enable paging only on iPad
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.collectionView?.pagingEnabled = true
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.showTip = false
        self.data = [:]

        if self.data.count == 0
        {
            getData()
        }
    }

    private func getData() {
        // show loading
        spinner.startAnimatingOnView(self.view)
        
        // fake an agentBook
        self.agentBook = AgentBookModel(alertToActionRate: 0, alertsPerDay: 1, mostActiveAgent: 1, taskTypes: [], productTypes: [])
        self.agentBook?.maxPolicyPremium = AlertAttributeModel(title: "Annualized Premium", value: "$6,000.00")
        self.agentBook?.maxPoliciesInHousehold = AlertAttributeModel(title: "Policies in Household", value: "3")
        self.agentBook?.maxYearsAsClient = AlertAttributeModel(title: "Years as Client", value: "19")
        
        //sample code to get alerts for an agent, currently the agent id can be set to be anything
        AlertService.getAllForAgent(Constants.DEFAULT_AGENT_ID, completionHandler: {(alerts:[AlertModel]?, error:NSError?) -> Void in
            // println(alerts)
            if let alerts = alerts {
                // transform alerts to categories directionay<categoryId, categoryModel>
                var categoryViewModels = AlertCategoryViewModel.categoryViewModelsFromAlertModes(alerts)
                // println(categories)
                
                // reset data
                self.data = [:]
                
                var title = self.allCategory
                //self.selectedCategory = title
                
                //Get count from DB also about Completed Alert
                let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
                var alert_FromDB:[Alert]! = alertAdapter.getAllAlertDetail()
                
                var allAlerts = AlertCategoryViewModel(id: -1, code: "", title: title, number: 0)
                for alert in alerts {
                    // append & count to AllAlerts
                    
                    var isAlert_existInDB = false
                    if alert_FromDB != nil {
                        for (index, alertDB) in enumerate(alert_FromDB) {
                            if alert.id == alertDB.id && (alertDB.status == "Completed" || alertDB.status == "Delegated") {
                                
                                //This alert has been marked as completed and stored in DB previously
                                isAlert_existInDB = true
                                alert_FromDB.removeAtIndex(index)
                                break;
                            }
                        }
                    }
                    
                    if alert.isCompleted == false && !isAlert_existInDB {
                        allAlerts.number++
                        allAlerts.alerts.append(alert)
                    }
                }
                allAlerts.alerts.sort({ $0.rank > $1.rank})
                
                self.data[title] = allAlerts
                
                // data for badgeBar
                //            var badgeLabels = ["All"]
                //            var noOfItemsInBadges = [allAlerts.number]
                
                //for iphone create all categories, for ipad, group some into "Other" category
                for categoryViewModel in categoryViewModels
                {
                    //                badgeLabels.append(categoryViewModel.title)
                    //                noOfItemsInBadges.append(categoryViewModel.alerts.count)
                    
                    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
                    {
                        self.data[categoryViewModel.title] = categoryViewModel
                    }
                    else
                    {
                        var other = AlertCategoryViewModel(id: -999, code: Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue, title: Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue, number: 0)
                        for var i:Int=0; i<categoryViewModels.count; i++
                        {
                            var c:AlertCategoryViewModel = categoryViewModels[i]
                            if c.title == Constants.SMART_LIST_CATEGORY_NAMES.RETENTION.rawValue || c.title == Constants.SMART_LIST_CATEGORY_NAMES.LEADS.rawValue || c.title == Constants.SMART_LIST_CATEGORY_NAMES.COMPLETED.rawValue
                            {
                                self.data[categoryViewModel.title] = categoryViewModel
                            }
                            else
                            {
                                other.number += c.number
                                for alert in c.alerts {
                                    other.alerts.append(alert)
                                }
                                self.otherSubCategory[c.title] = c
                            }
                        }
                        self.data[other.title] = other
                    }
                }
                
                if self.selectedOtherSubCategory != "" && self.selectedCategory == Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue
                {
                    var subOther:AlertCategoryViewModel = self.otherSubCategory[self.selectedOtherSubCategory]!
                    var all:AlertCategoryViewModel = self.data[self.allCategory]!
                    self.data = [Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue:subOther, self.allCategory:all]
                }
                
                // refresh table view
                self.showTip = true
                self.collectionView?.reloadData()

                // scroll to Alert
                if self.alertId != nil {
                    self.showAlertDetails(self.alertId!)
                    self.alertId = nil
                }
            }
            
            // hide loading
            self.spinner.stopAnimatingOnView()
        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            return CGSizeMake(self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height)
        }
        else{
            if data[selectedCategory] != nil && data[selectedCategory]?.alerts.count > 0 {
                return CGSizeMake(320, self.collectionView!.bounds.size.height)
            }
            else{
                ///no data cell
                return CGSizeMake(self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let category = data[selectedCategory] {
            if category.alerts.count > 0 {
                return category.alerts.count
            }
        }
        /// no data cell
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell:UICollectionViewCell!
        if data[selectedCategory] != nil && data[selectedCategory]?.alerts.count > 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as SmartListViewCell
            (cell as SmartListViewCell).delegate = self
            (cell as SmartListViewCell).recommendationDelegate = self
            (cell as SmartListViewCell).updateAlert(data[selectedCategory]!.alerts[indexPath.row], alerts: data[allCategory]!.alerts, agentBook: agentBook!)
        }else{
            ///no data cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(nodataReuseIdentifier, forIndexPath: indexPath) as NoDataCell
            
            if(self.showTip == true){
                if selectedCategory == allCategory {
                    (cell as NoDataCell).tipLabel.text = "You don’t have any alerts at this time"
                } else {
                    (cell as NoDataCell).tipLabel.text = "You don’t have any alerts of this type"
                }
            }
        }
        
        return cell
    }

    // MARK: -
    func smartListViewCell(cell: SmartListViewCell, didTriggerAction action: AlertAction,atFrame rect: CGRect)
    {
        
        var indexPath = self.collectionView!.indexPathForCell(cell)!
        if let alert = data[selectedCategory]?.alerts[indexPath.row] {
        
            switch action {
            case .Contact:
                // open Contact page
                var navigationController = UIStoryboard(name: "Contact", bundle: nil).instantiateInitialViewController() as UINavigationController
                if let contactViewController = navigationController.viewControllers[0] as? ContactViewController {
                    contactViewController.alertId = alert.id
                    contactViewController.delegate = self
                }
                self.presentViewController(navigationController, animated: true, completion: nil)
                
            case .Postpone:
                // open calendar picker
                //UIAlertView(title: "", message: "Function not yet available", delegate: nil, cancelButtonTitle: "OK").show()
                self.postponeForAlert(alert, popoverByRect: rect)
                
            case .Delegate:
                // open delegate picker
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                    
                    let nc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.AGENT_COLLECTIONVC_iPHONE) as UINavigationController
                    let vc = nc.viewControllers[0] as AgentImageViewController
                    vc.delegate = self
                    vc.alertId = alert.id
                    
                    self.presentViewController(nc, animated: true, completion: nil)
                }
                else {
                    var frame = rect
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.AGENT_COLLECTIONVC_iPAD) as AgentImageCollectionViewController
                    vc.modalPresentationStyle = .Popover
                    vc.preferredContentSize   = CGSizeMake(900, 120)
                    vc.delegate = self
                    vc.alertId = alert.id
                    
                    frame.origin.y += 122.0
                    frame.origin.x += 110.0
                    let aPopover =  UIPopoverController(contentViewController: vc)
                    aPopover.presentPopoverFromRect(frame, inView: cell, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
                }
            }
        }
    }
    
    //show the calendar picker based on the device
    private func postponeForAlert(alert:AlertModel, popoverByRect rect:CGRect?)
    {
        self.alertId = alert.id
        
        let storyboard:UIStoryboard = UIStoryboard(name: "CalendarDatePicker", bundle: nil)
        let nc:UINavigationController = storyboard.instantiateInitialViewController() as UINavigationController
        let vc:CalendarDatePickerController = nc.viewControllers[0] as CalendarDatePickerController
        vc.setTitle("Postpone")
        vc.disablePastDates = true
        vc.delegate = self
        
        //show as popover for tablet and full screen for phone
        let uiIdiom:UIUserInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom
        if uiIdiom == UIUserInterfaceIdiom.Phone
        {
            self.presentViewController(nc, animated: true, completion: nil)
        }
        else
        {
            var frame:CGRect = self.collectionView!.convertRect(rect!, toView: self.collectionView!.superview)
            self.popoverController = UIPopoverController(contentViewController: nc)
            self.popoverController?.setPopoverContentSize(CGSizeMake(300, 500), animated: true)
            self.popoverController?.presentPopoverFromRect(frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    /**** delegate method for the calendar date picker ****/
    func calendarDatePickerOnDaySelected(day: NSDate)
    {
        println("date selected: " + day.description)
        self.setAlertAsPostponed(self.alertId!, toDate: day)
        
        //delay so user can see their selection
        TimeUtils.PerformAfterDelay(0.25, completionHandler: {() -> Void in
            self.hideDatePicker()
        })
    }
    
    func calendarDatePickerOnCancel() {
        self.hideDatePicker()
    }
    
    //hide the date picker based on the type of device
    private func hideDatePicker()
    {
        self.alertId = nil
        let uiIdiom:UIUserInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom
        if uiIdiom == UIUserInterfaceIdiom.Phone
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            if self.popoverController != nil {
                self.popoverController?.dismissPopoverAnimated(true)
            }
        }
    }
    
    //remove the alert but not marking it as complete
    private func setAlertAsPostponed(alertId:Int, toDate date:NSDate)
    {
        AlertService.getDetailsForAlert(alertId, completionHandler: {(alertDetail: AlertModel?, error: NSError?) -> Void in
            
            if let alertDetail = alertDetail {
                //code from contactviewcontroller to mark an allert as complete
                let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
                var alert:Alert! = alertAdapter.getAlertDetailStatus(alertDetail.id, categoryId: alertDetail.category?.id, status:"Completed")
                
                if alert == nil {
                    alert = alertAdapter.createAlert()
                }
                let dateString : String = StringUtils.convertDateToString(date, format: Constants.POSTPONE_NOTE_DATE)
                var isDestructive:Bool = false
                alert.id = NSNumber(integer: alertId)
                alert.status = "NotCompleted"
                alert.finishNote = "Postponed to " + dateString
                alert.date = NSDate()
                
                var category: AlertCategoryModel = alertDetail.category!
                
                alert.categoryId = NSNumber(integer:category.id)
                alert.isDestructive = isDestructive
                
                alertAdapter.insertAlert()
                
                self.onContactFinish(alertId)
                
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                    self.forceUpdateBadges()
                }
            }
        })
    }

    //remove alert and reload collection view
    func onContactFinish(alertId: Int)
    {
        //sample code to get alerts for an agent, currently the agent id can be set to be anything
        AlertService.getAllForAgent(Constants.DEFAULT_AGENT_ID, completionHandler: {(alerts:[AlertModel]?, error:NSError?) -> Void in

            //Following code is removing alert from CollectionView, but problem is it is leaving empty screen for removed view
            
            /*
            var index:Int = 0
            var previousAlerts:[AlertModel] = self.data[self.selectedCategory]!.alerts
            
            //find matching alert
            for index=0; index<previousAlerts.count; index++ {
                var alert:AlertModel = previousAlerts[index]
                if alert.id == alertId {
                    break
                }
            }
            
            //fade out cell
            var cell:UICollectionViewCell! = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell.alpha = 1
            UIView.animateWithDuration(0.25, delay: 1, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
                
                cell.alpha = 0
                
                }, completion: {(finished:Bool) -> Void in
                    
                    //remove alert after delay
                    TimeUtils.PerformAfterDelay(1.25, completionHandler: {() -> Void in
                        
                        previousAlerts.removeAtIndex(index)
                        self.data[self.selectedCategory]!.alerts = previousAlerts
                        self.showTip = true
                        self.collectionView?.reloadData()
                        
                    })
            })
            
            */

            // transform alerts to categories directionay<categoryId, categoryModel>
            var categoryViewModels = AlertCategoryViewModel.categoryViewModelsFromAlertModes(alerts!)
            // println(categories)
            
            // reset data
            self.data = [:]
            
            var title = "All"
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
                title = "All Alerts"
            }
            //self.selectedCategory = title
            
            //Get count from DB also about Completed Alert
            let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
            var alert_FromDB:[Alert]! = alertAdapter.getAllAlertDetail()
            
            var allAlerts = AlertCategoryViewModel(id: -1, code: "", title: title, number: 0)
            for alert in alerts! {
                // append & count to AllAlerts
                
                var isAlert_existInDB = false
                if alert_FromDB != nil {
                    for (index, alertDB) in enumerate(alert_FromDB) {
                        if alert.id == alertDB.id && (alertDB.status == "Completed" || alertDB.status == "Delegated") {
                            
                            //This alert has been marked as completed and stored in DB previously
                            isAlert_existInDB = true
                            alert_FromDB.removeAtIndex(index)
                            break;
                        }
                    }
                }
                
                if alert.isCompleted == false && !isAlert_existInDB {
                    allAlerts.number++
                    allAlerts.alerts.append(alert)
                }
            }
            allAlerts.alerts.sort({ $0.rank > $1.rank})
            
            self.data[title] = allAlerts

            for categoryViewModel in categoryViewModels {
                
                // self.data[categoryViewModel.title] = categoryViewModel
                
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
                {
                    self.data[categoryViewModel.title] = categoryViewModel
                }
                else
                {
                    var other = AlertCategoryViewModel(id: -999, code: Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue, title: Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue, number: 0)
                    for var i:Int=0; i<categoryViewModels.count; i++
                    {
                        var c:AlertCategoryViewModel = categoryViewModels[i]
                        if c.title == Constants.SMART_LIST_CATEGORY_NAMES.RETENTION.rawValue || c.title == Constants.SMART_LIST_CATEGORY_NAMES.LEADS.rawValue || c.title == Constants.SMART_LIST_CATEGORY_NAMES.COMPLETED.rawValue
                        {
                            self.data[categoryViewModel.title] = categoryViewModel
                        }
                        else
                        {
                            other.number += c.number
                            for alert in c.alerts {
                                other.alerts.append(alert)
                            }
                            self.otherSubCategory[c.title] = c
                        }
                    }
                    self.data[other.title] = other
                }
                
            }
            
            if self.selectedOtherSubCategory != "" && self.selectedCategory == Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue
            {
                var subOther:AlertCategoryViewModel = self.otherSubCategory[self.selectedOtherSubCategory]!
                var all:AlertCategoryViewModel = self.data[self.allCategory]!
                self.data = [Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue:subOther, self.allCategory:all]

            }
            
            self.showTip = true
            self.collectionView?.reloadData()

        })

    }
    
    /**** AgentImageView delegate method ****/
    //remove the current alert
    func agentImageViewDelegateSelected(agent: PersonModel, forAlertId alertId: Int)
    {
        AlertService.getDetailsForAlert(alertId, completionHandler: {(alertDetail: AlertModel?, error: NSError?) -> Void in
            //save delegate to coredata.
            let delegateAdapter = CommonFunc.sharedInstanceDelegate as DelegateAdapter
            var del:Delegate! = delegateAdapter.getDelegate(agentId: Constants.DEFAULT_AGENT_ID , alertId: alertId)
            if del == nil {
                del = delegateAdapter.createDelegate()
            }
            del.alertId = alertId
            del.agentId = Constants.DEFAULT_AGENT_ID
            del.category = alertDetail!.category!.title
            del.desc = alertDetail!.message
            del.clientName = alertDetail!.client!.displayName
            del.rank = alertDetail!.rank!
            
            del.delegateAgent = agent.displayName
            delegateAdapter.insertDelegate()
            
            //code from contactviewcontroller to mark an allert as complete
            let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
            var alert:Alert! = alertAdapter.getAlertDetailStatus(alertDetail?.id, categoryId: alertDetail?.category?.id, status:"Delegated")
            
            if alert == nil {
                alert = alertAdapter.createAlert()
            }
            alert.date = NSDate()
            let dateString : String = StringUtils.convertDateToString(alert.date, format: Constants.FINISH_NOTE_DATE)
            
            alert.id = NSNumber(integer: alertId)
            alert.status = "Delegated"
            alert.finishNote = "Delegated to " + agent.displayName
            alert.date = NSDate()

            var category: AlertCategoryModel = alertDetail!.category!
            
            alert.categoryId = NSNumber(integer:category.id)
            alert.isDestructive = false
            
            alertAdapter.insertAlert()
            
            self.onContactFinish(alertId)

            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                self.forceUpdateBadges()
            }
        })

    }

    func showAlertDetails(alertId:Int) {
        var alerts = data[selectedCategory]!.alerts
        for i: Int in 0..<alerts.count {
            var alert: AlertModel = alerts[i]
            if alertId == alert.id {
                var indexPath = NSIndexPath(forRow: i, inSection: 0)
                collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
            }
        }
    }
    
    func forceUpdateBadges() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.FORCE_UPDATEBADGE_NOTIFICATION, object: nil)
    }
    
    //MARK: RecommendationDelegate
    func didSelectRecommendation(alert:AlertModel,isAlertRecommendation:Bool) {
    
        var recommendationTvc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.RECOMMENDATION_TVC) as RecommendationTableViewController
        recommendationTvc.alert = alert
        recommendationTvc.isAlertRecommendation = isAlertRecommendation
        self.navigationController?.pushViewController(recommendationTvc, animated: true)
    }
    //MARK: -

}
