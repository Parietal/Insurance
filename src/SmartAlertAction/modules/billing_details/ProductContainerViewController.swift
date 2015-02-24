//
//  ProductContainerViewController.swift
//  SmartAlertAction
//
//  Created by Saurav on 12/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ProductContainerViewController: UIViewController {
    
    private var viewController: UIViewController?
    var policyID : Int = 0
    var policyName :  String?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    class var lastIndex: Int {return 0}
    
    let defaultValuesInstance = CommonFunc.sharedInstanceDefaultValues
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = self.policyName
        
        self.title = self.policyName
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(defaultValuesInstance.getSelectedIndex() == 1){
            segmentedControl.selectedSegmentIndex = 1
            loadBillingViewController()
        }else{
            loadOverView()
        }
        
        
    }
    
    @IBAction func settingsTapped(sender: AnyObject) {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as UISplitViewController
            controller.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func loadBillingViewController() {
        
        var billingViewController = UIStoryboard(name: "PolicyBillingDetails", bundle: nil).instantiateViewControllerWithIdentifier(Constants.BILLINGVC) as BillingDetailViewController
        
        billingViewController.policyID = policyID
        
        self.showViewController(billingViewController)
        
    }
    
    func loadOverView() {
        var productOverViewController = UIStoryboard(name: "PolicyDetails", bundle: nil).instantiateViewControllerWithIdentifier(Constants.PRODUCT_OVERVIEWVc) as ProductOverViewTableViewController
        
        productOverViewController.policyId = policyID
        self.showViewController(productOverViewController)
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
    
    @IBAction func segmentValueChanged(sender: AnyObject) {
        
        let segmentedControl = sender as UISegmentedControl
        
        defaultValuesInstance.updateSelectedSegment(segmentedControl.selectedSegmentIndex)
        
      //  lastIndex = segmentedControl.selectedSegmentIndex
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            loadBillingViewController()
            break
        default:
            loadOverView()
            break
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
