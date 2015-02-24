//
//  ProductOverViewTableViewController.swift
//  SmartAlertAction
//
//  Created by Saurav on 14/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ProductOverViewTableViewController: UITableViewController {

    var titleOfSections: [String] = []
    var isTwoColumnArray:[String] = []
    
    var policyDetail: PolicyModel?
    var policyId: Int = 0
    
    var selectedProductName : String = "Product"
    
    var data: [String: [PolicyDetailsItemModel]] = [:]
    
    // activity indicator
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        for columnName in isTwoColumnArray {
            if columnName == self.titleOfSections[section] {
                let quotient = list!.count / 2
                let remainder = list!.count % 2
                return list!.count / 2 + list!.count % 2
            }
        }
        return list!.count


    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return RASizes.DEFAULT_CELL_HEIGHT
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        self.tableView.separatorColor = RAColors.GRAY3
        return 44
        
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        var header :CustomTableViewHeaderFooterView = CustomTableViewHeaderFooterView()
        
        header.textLabel.textColor = RAColors.GRAY8
        header.contentView.backgroundColor = UIColor.whiteColor()
        header.textLabel.font = RAFonts.HELVETICA_NEUE_MEDIUM_18
        
        return header
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var isTwoColoumn = false
        var list = self.data[self.titleOfSections[indexPath.section]]
        
        for columnName in isTwoColumnArray {
            if columnName == self.titleOfSections[indexPath.section] {
                isTwoColoumn = true
                break
            }
        }
        
        if isTwoColoumn {
        
            let multiCell = tableView.dequeueReusableCellWithIdentifier(Constants.MULTICOLUMN_CELL, forIndexPath: indexPath) as MultiColumnTableViewCell
            var list = self.data[self.titleOfSections[indexPath.section]]!
            var item = list[indexPath.row]
            multiCell.leftTextLabel.text = item.name
            multiCell.leftDetailLabel.text = item.value
            
            var rightIndex = list.count / 2 + list.count % 2
            rightIndex += indexPath.row
            if rightIndex < list.count {
                var rightItem = list[rightIndex]

                multiCell.rightTextLabel.text = rightItem.name
                multiCell.rightDetailLabel.text = rightItem.value
                
            }
            else {
                multiCell.rightTextLabel.text = ""
                multiCell.rightDetailLabel.text = ""
            }
            
            return multiCell
        }
        else {
            let prodCell = tableView.dequeueReusableCellWithIdentifier(Constants.PRODUCTDETAIL_CELL, forIndexPath: indexPath) as ProductDetailTableViewCell
            var list = self.data[self.titleOfSections[indexPath.section]]!
            var item = list[indexPath.row]
            
            prodCell.proTextLabel.text = item.name
            prodCell.proDetailLabel.text = item.value

            return prodCell
        }
    }



    
    func loadData() {
        
        // show loading
        self.spinner.startAnimatingOnView(self.view)
        
        // get policy from service
        PolicyService.getDetailsForPolicy(self.policyId, completionHandler: { (policy, error) -> Void in
            
            // assign to client detail
            self.policyDetail = policy
            
            var procuctName = self.policyDetail?.type?.subTitle
            self.title = self.policyDetail?.type?.subTitle
            
            //  self.policyNameLabel.text = policy?.type?.title
            
            self.data = [:]
            for group in self.policyDetail!.details! {
                var section = group.title//.uppercaseString
                var isTwoColumn = group.twoColumns
                var list:Array<PolicyDetailsItemModel> = []
                for item in group.items {
                    
                    //No need to check 'iPadOnly' criteria, as this file(ViewController) is only for iPad
                    list.append(item)

                }
                // skip empty section
                if list.count > 0 {
                    self.data[section] = list
                    if isTwoColumn {
                        self.isTwoColumnArray.append(section)
                    }
                }
            }
            
            self.titleOfSections = self.data.keys.array
            
            // reload client data
            self.tableView.reloadData()
            
            // hide loading
            self.spinner.stopAnimatingOnView()
        })
    }


}
