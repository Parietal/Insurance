//
//  SmartAlertsViewController.swift
//  SmartAlertAction
//
//  Created by Saurav on 23/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class SmartAlertsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SmartListViewCellDelegate {

    @IBOutlet var collectionView: UICollectionView?
    var data: [String: AlertCategoryViewModel] = [:]
    let reuseIdentifier = "SmartListItemCell"
    var agentBook: AgentBookModel?

    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Category", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("category:"))
        }
        
        self.collectionView?.backgroundColor = RAColors.LIGHT_GRAY
        // enable paging only on iPad
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.collectionView?.pagingEnabled = true
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
            
            // transform alerts to categories directionay<categoryId, categoryModel>
            var categoryViewModels = AlertCategoryViewModel.categoryViewModelsFromAlertModes(alerts!)
            // println(categories)
            
            // reset data
            //            self.titleOfSections = ["", self.SECTION_ACT_NOW, self.SECTION_FOLLOW_UP]
            //            self.data = ["": [], self.SECTION_ACT_NOW: [], self.SECTION_FOLLOW_UP: []]
            self.data = [:]
            
            //Get count from DB also about Completed Alert
            let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
            var alert_FromDB:[Alert]! = alertAdapter.getAllAlertDetail()
            
            var allAlerts = AlertCategoryViewModel(id: -1, code: "", title: "All", number: 0)
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
                if alert.isCompleted == false {
                    allAlerts.number++
                }
                allAlerts.alerts.append(alert)
            }
            self.data["all"] = allAlerts
            
            //            for (section:String, sectionCode:String) in self.categoryIds {
            //                for categoryViewModel in categoryViewModels {
            //                    // get sectionId
            //                    var categoryCode = categoryViewModel.code
            //                    var code = categoryCode.substringToIndex(advance(categoryCode.endIndex, -2))
            //
            //                    if code == sectionCode {
            //                        self.data[section]?.append(categoryViewModel)
            //                    }
            //                }
            //            }
            // println(self.data)
            
            // refresh table view
            self.collectionView?.reloadData()
            
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
        return CGSizeMake(320, self.collectionView!.bounds.size.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(1, 0, 0, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if data["all"] != nil {
            return data["all"]!.alerts.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as SmartListViewCell
        
        // Configure the cell
        cell.delegate = self
        cell.updateAlert(data["all"]!.alerts[indexPath.row], alerts: data["all"]!.alerts, agentBook: agentBook!)
        
        return cell
    }
    
    // MARK: -
    
    func smartListViewCell(cell: SmartListViewCell, didTriggerAction action: AlertAction,atFrame rect: CGRect) {
        
        switch action {
        case .Contact:
            // open Contact page
            var contactViewController = UIStoryboard(name: "Contact", bundle: nil).instantiateInitialViewController() as UINavigationController
            
            self.presentViewController(contactViewController, animated: true, completion: nil)
        case .Postpone:
            // open calendar picker
            println()
        case .Delegate:
            // open delegate picker
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.AGENT_COLLECTIONVC_iPHONE) as UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            else {
                var frame = rect
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.AGENT_COLLECTIONVC_iPAD) as AgentImageCollectionViewController
                vc.modalPresentationStyle = .Popover
                vc.preferredContentSize   = CGSizeMake(900, 120)
                
                frame.origin.y += 122.0
                frame.origin.x += 110.0
                
                let aPopover =  UIPopoverController(contentViewController: vc)
                aPopover.presentPopoverFromRect(frame, inView: cell, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }

        }
        
        
    }
    
    
    
    // MARK: - Other Actions
    
    @IBAction func showSettings(sender: AnyObject) {
        var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as UIViewController
        self.navigationController?.presentViewController(controller, animated: true, completion: nil)
    }



}
