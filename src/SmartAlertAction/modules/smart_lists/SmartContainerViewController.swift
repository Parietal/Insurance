//
//  SmartContainerViewController.swift
//  SmartAlertAction
//
//  Created by Saurav on 29/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class SmartContainerViewController: UIViewController, BadgeBarDelegate, CategoryViewDelegate, OtherCategoryDelegate {

    private var viewController: UIViewController?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var badgeBar: BadgeBar?
    @IBOutlet var categoryButton: UIBarButtonItem!
    
    var data: [String: AlertCategoryViewModel] = [:]
    var allCategory = "All"
    var selectedCategory: String! {
        didSet{
            self.updateNavigationTitle()

            if selectedCategory != Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue{
                selectedOtherSubCategory = ""
            }
        }
    }
    var selectedOtherSubCategory: String = ""
    var otherSubCategory:[String:AlertCategoryViewModel] = [:]
    
    func updateNavigationTitle() {
        var selectedAlertsCount:Int = self.data[self.selectedCategory] != nil ? self.data[self.selectedCategory]!.number : 0
        
        if  UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.navigationItem.title = "\(self.selectedCategory) (\(selectedAlertsCount))"
        }
        else {
            self.navigationItem.title = "Alerts"
        }

    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            allCategory = "All Alerts"
        }
        selectedCategory = allCategory

        self.badgeBar?.delegate = self
        var alertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("smartListVc") as SmartListsViewController
        alertViewController.selectedCategory = selectedCategory
        self.showViewController(alertViewController)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBadgeForce", name:Constants.FORCE_UPDATEBADGE_NOTIFICATION, object: nil)

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateBadgeForce()
    }

    func showViewController(controller: UIViewController) {
        if viewController != nil {
            viewController?.willMoveToParentViewController(nil)
            viewController?.view.removeFromSuperview()
            viewController?.removeFromParentViewController()
        }
        
        self.addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, containerView.frame.width, containerView.frame.height)
        containerView.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        
        viewController = controller
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Badge

    
    func badgebar(badgebar: BadgeBar, willTap: BadgeButton) -> (Bool) {
        if willTap.titleLabel!.text! == Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue{
            var otherData:AlertCategoryViewModel = self.data[Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue]!
            var otherTableVc:OtherCategoryTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OtherCategoryView") as OtherCategoryTableViewController
            otherTableVc.modalPresentationStyle = .Popover
            otherTableVc.preferredContentSize   = CGSizeMake(250, 160)
            otherTableVc.otherSubCategory = self.otherSubCategory
            otherTableVc.selectedSubCategory = self.selectedOtherSubCategory
            otherTableVc.delegate = self
            let aPopover =  UIPopoverController(contentViewController: otherTableVc)
            aPopover.presentPopoverFromRect(willTap.frame, inView: badgebar, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
            //if you want to block this tap return true.
            return true
        }
        else{
            return false
        }
    }
    
    func badgebar(badgebar: BadgeBar, onTap: BadgeButton) {
        self.selectedCategory = onTap.titleLabel!.text!
        
        //TODO: Change title checking, if condition need to be according to some categoryId as Int
        
        if 	selectedCategory == Constants.SMART_LIST_CATEGORY_NAMES.DELEGATED.rawValue {
            var delegateAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.DELEGATE_VC) as DelegateAlertViewController
            delegateAlertViewController.isAlertCompleted = false
            self.showViewController(delegateAlertViewController)
        }
        else if selectedCategory == Constants.SMART_LIST_CATEGORY_NAMES.COMPLETED.rawValue {
            
            //Show for iPhone
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                var completeViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.COMPLETE_VC_iPHONE) as CompleteViewController
                self.showViewController(completeViewController)
                
            }
            else {
                var completeViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.DELEGATE_VC) as DelegateAlertViewController
                completeViewController.isAlertCompleted = true
                self.showViewController(completeViewController)
            }
            
        }
        else if selectedCategory == Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue {
            
        }
        else {
            var alertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("smartListVc") as SmartListsViewController
            alertViewController.selectedCategory = selectedCategory
            self.showViewController(alertViewController)
        }
    }
    

    // MARK: - OtherCategoryDelegate
    func didSelectedSubCategoryAtIndex(category: String) {
        self.badgeBar?.setButtonSelected("Other")
        self.selectedCategory = Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue
        self.selectedOtherSubCategory = category
        var alertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("smartListVc") as SmartListsViewController
        alertViewController.selectedCategory = Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue
        alertViewController.selectedOtherSubCategory = self.selectedOtherSubCategory
        self.showViewController(alertViewController)
    }
    
    // MARK: - Category
    func categoryView(didSelectedCategory category: String) {
        self.selectedCategory = category
        var count = data[category] != nil ? data[category]!.number : 0

        self.navigationItem.title = "\(category) (\(count))"

        if 	selectedCategory == Constants.SMART_LIST_CATEGORY_NAMES.DELEGATED.rawValue {
            var delegateAlertViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.DELEGATE_VC) as DelegateAlertViewController
            delegateAlertViewController.isAlertCompleted = false
            self.showViewController(delegateAlertViewController)
        }
        else if selectedCategory == Constants.SMART_LIST_CATEGORY_NAMES.COMPLETED.rawValue {
            //Show for iPhone
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                var completeViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.COMPLETE_VC_iPHONE) as CompleteViewController
                self.showViewController(completeViewController)
                
            }
            else {
                var completeViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.DELEGATE_VC) as DelegateAlertViewController
                completeViewController.isAlertCompleted = true
                self.showViewController(completeViewController)
            }
        }
        else {
            var alertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("smartListVc") as SmartListsViewController
            alertViewController.selectedCategory = category
            self.showViewController(alertViewController)
        }
    }
    
    // MARK: - Other Actions
    
    func showAlertDetails(alertId:Int) {
        // show All Alerts category
        var category = allCategory

        var alertViewController = self.storyboard?.instantiateViewControllerWithIdentifier("smartListVc") as SmartListsViewController
        alertViewController.selectedCategory = category
        alertViewController.alertId = alertId
        self.showViewController(alertViewController)
    }
    
    @IBAction func showSettings(sender: AnyObject) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateViewControllerWithIdentifier("AlertNotification") as UIViewController
            
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
        else{
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as UISplitViewController
            controller.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
    }

    @IBAction func category(sender: AnyObject) {
        var controller = CategoryViewController()
        controller.data = data
        controller.selectedCategory = selectedCategory
        controller.delegate = self
        var navigationController = UINavigationController(rootViewController: controller)
        self.navigationController?.tabBarController?.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    //MARK: NSNotificationCenter 
    func updateBadgeForce() {
    
        //Doing force empty to data, as need to update
        self.data = [:]
        if self.data.count == 0
        {
            
            //sample code to get alerts for an agent, currently the agent id can be set to be anything
            AlertService.getAllForAgent(Constants.DEFAULT_AGENT_ID, completionHandler: {(alerts:[AlertModel]?, error:NSError?) -> Void in
                // println(alerts)
                
                if let alerts = alerts {
                    // transform alerts to categories directionay<categoryId, categoryModel>
                    var categoryViewModels = AlertCategoryViewModel.categoryViewModelsFromAlertModes(alerts)
                    // println(categories)
                    
                    /**** temporary hack to create "Other" category ****/
                    if UIDevice.currentDevice().userInterfaceIdiom != UIUserInterfaceIdiom.Phone
                    {
                        var clone:[AlertCategoryViewModel] = [AlertCategoryViewModel]()
                        var other = AlertCategoryViewModel(id: -999, code: Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue, title: Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue, number: 0)
                        for var i:Int=0; i<categoryViewModels.count; i++
                        {
                            var c:AlertCategoryViewModel = categoryViewModels[i]
                            if c.title == Constants.SMART_LIST_CATEGORY_NAMES.RETENTION.rawValue || c.title == Constants.SMART_LIST_CATEGORY_NAMES.LEADS.rawValue || c.title == Constants.SMART_LIST_CATEGORY_NAMES.DELEGATED.rawValue || c.title == Constants.SMART_LIST_CATEGORY_NAMES.COMPLETED.rawValue
                            {
                                clone.append(c)
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
                        clone.insert(other, atIndex: clone.count-2)
                        categoryViewModels = clone
                    }
                    /**** temporary hack to create "Other" category ****/
                    
                    // reset data
                    self.data = [:]
                    var title = self.allCategory
                    
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
                                    break
                                }
                            }
                        }
                        
                        
                        if alert.isCompleted == false && !isAlert_existInDB {
                            allAlerts.number++
                            allAlerts.alerts.append(alert)
                        }
                    }
                    
                    
                    self.data[title] = allAlerts
                    
                    //self.navigationItem.title = "\(title) (\(allAlerts.number))"
                    
                    // data for badgeBar
                    var badgeLabels = ["All"]
                    var noOfItemsInBadges = [allAlerts.number]
                    
                    for categoryViewModel in categoryViewModels {
                        
                        self.data[categoryViewModel.title] = categoryViewModel
                        badgeLabels.append(categoryViewModel.title)
                        noOfItemsInBadges.append(categoryViewModel.number)
                    }
                    //if self.selectedCategory != self.allCategory {
                    //    //This means user in some other Alert, so update alert count of user's current selected alert type
                    //    title = self.selectedCategory
                    //}
                    
                    self.updateNavigationTitle()
                    
                    // println(self.data)
                    self.badgeBar?.configureBadges(badgeLabels.count, badgeLabels: badgeLabels, noOfItemsInBadge: noOfItemsInBadges, selectedTitle: self.selectedCategory)
                }
            })
        }

    }
    
}
