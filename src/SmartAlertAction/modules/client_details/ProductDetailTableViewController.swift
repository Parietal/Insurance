//
//  ProductDetail.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 30/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailTableViewController : UITableViewController {
    
    var titleOfSections: [String] = []
    
    var policyDetail: PolicyModel?
    var policyId: Int = 0
    
    var selectedProductName : String = "Product"
    
    var data: [String: [PolicyDetailsItemModel]] = [:]
    
    // activity indicator
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.title = "Product"
        // load client data
        self.loadData()
    }
    
    func loadData() {
        
        // show loading
        self.spinner.startAnimatingOnView(self.view)
        
        // get policy from service
        PolicyService.getDetailsForPolicy(self.policyId, completionHandler: { (policy, error) -> Void in
            
            // assign to client detail
            self.policyDetail = policy
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                var procuctName = self.policyDetail?.type?.subTitle
             //   println("product name...\(procuctName!)")
                self.title = self.policyDetail?.type?.subTitle
            }else{
                self.navigationItem.title = "Product"
            }
            
          //  self.policyNameLabel.text = policy?.type?.title
            
            self.data = [:]
            for group in self.policyDetail!.details! {
                var section = group.title//.uppercaseString
                var list:Array<PolicyDetailsItemModel> = []
                // skip the iPadOnly detail item
                for item in group.items {
                    if item.iPadOnly == false {
                        list.append(item)
                    }
                }
                // skip empty section
                if list.count > 0 {
                    self.data[section] = list
                }
            }
            
            self.titleOfSections = self.data.keys.array
            
            // reload client data
            self.tableView.reloadData()
            
            // hide loading
            self.spinner.stopAnimatingOnView()
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func settingsTapped(sender: AnyObject) {
        
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
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.titleOfSections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleOfSections[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var list = self.data[self.titleOfSections[section]]
        return list!.count      //  return self.rowsOfSections[section]
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return RASizes.DEFAULT_CELL_HEIGHT
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        self.tableView.separatorColor = RAColors.GRAY3
        return 44
        
    }
    
//    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            
//        var productHdrCell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("productHdrCell") as? UITableViewCell
//        productHdrCell?.textLabel.textColor = RAColors.GRAY8
//        productHdrCell?.textLabel.text = titleOfSections[section]
//       // productHdrCell?.detailTextLabel?.font = RAFonts.SMARTLISTS_CELL_TITLE
//        productHdrCell?.backgroundColor = RAColors.GRAY2
//        return productHdrCell
//    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("productDetail") as UITableViewCell?
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "productDetail")
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
       
        cell?.textLabel?.textColor = RAColors.GRAY8
        cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell?.detailTextLabel?.textColor = UIColor.blackColor()
        cell?.detailTextLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
            
          //  cell?.textLabel.text = titlesOfSummary[indexPath.row]
        cell?.detailTextLabel?.textColor = UIColor.blackColor()
        
        var list = self.data[self.titleOfSections[indexPath.section]]!
        var item = list[indexPath.row]
        
        cell?.textLabel?.text = item.name
        cell?.detailTextLabel?.text = item.value
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        var header :CustomTableViewHeaderFooterView = CustomTableViewHeaderFooterView()
        
        header.textLabel.textColor = RAColors.GRAY8
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            header.contentView.backgroundColor = UIColor.whiteColor()
            header.headerFont = RAFonts.SMARTLISTS_CONTACT_SECTION_TITLE
        } else {
            header.topSeparatorColor = RAColors.GRAY5
            header.bottomSeparatorColor = RAColors.GRAY5
            header.headerFont = RAFonts.SMARTLISTS_CONTACT_SECTION_TITLE_IPHONE
        }
        
        return header
    }

    
}


