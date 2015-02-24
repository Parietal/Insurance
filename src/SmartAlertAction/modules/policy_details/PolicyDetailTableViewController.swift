//
//  PolicyDetailTableViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/12/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class PolicyDetailTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var policyNameLabel: UILabel!
    @IBOutlet var policyInfoLabel: UILabel!
    
    var titleOfSections: [String] = []

    var policyDetail: PolicyModel?
    var policyId: Int = 0
    
    var data: [String: [PolicyDetailsItemModel]] = [:]
    
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the font and text color
        self.policyNameLabel.textColor = RAColors.GRAY8
        self.policyNameLabel.font = RAFonts.HELVETICA_NEUE_BOLD_20
        
        self.policyInfoLabel.textColor = RAColors.GRAY8
        self.policyInfoLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_16
        
        // reset text content
        self.policyNameLabel.text = ""

        // load alert data
        self.loadData()
        
        //PHM adjust margins for ipad
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.tableView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
            //can't just change the inset because of ios bug
            //self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
    }

    func loadData() {

        // show loading
        self.spinner.startAnimatingOnView(self.view)

        // get policy from service
        PolicyService.getDetailsForPolicy(self.policyId, completionHandler: { (policy, error) -> Void in
            
            // assign to client detail
            self.policyDetail = policy
            
            self.policyNameLabel.text = policy?.type?.subTitle
            
            self.navigationItem.title = policy?.type?.subTitle

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

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.titleOfSections.count
    }
    
    /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleOfSections[section]
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var list = self.data[self.titleOfSections[section]]
        return list!.count
    }
   
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return RASizes.DEFAULT_CELL_HEIGHT
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell:PolicyDetailsCell? = tableView.dequeueReusableCellWithIdentifier("policyDetailCell") as? PolicyDetailsCell
        var cell: UITableViewCell?

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            cell = PolicyDetailsCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "policyDetailCell") as PolicyDetailsCell
            cell?.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 30)
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "policyDetailCell")
        }
        
        // modify texLabel and detailTextLabel text colors and fonts
        cell?.textLabel?.textColor = RAColors.GRAY8
        cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        
        cell?.detailTextLabel?.textColor = RAColors.GRAY8
        cell?.detailTextLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_15

        var list = self.data[self.titleOfSections[indexPath.section]]!
        var item = list[indexPath.row]
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.textLabel?.text = item.name
        cell?.detailTextLabel?.text = item.value
        
        return cell!
    }

    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        var header:ClientInfoHeaderCell = ClientInfoHeaderCell()
        
        header.textLabel.textColor = RAColors.GRAY8

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            header.backgroundColor = UIColor.whiteColor()
            header.textLabel.font = RAFonts.HELVETICA_NEUE_MEDIUM_17
            header.paddingTop = 10
        } else {
            header.topSeparatorColor = RAColors.GRAY5
            header.bottomSeparatorColor = RAColors.GRAY5
            header.textLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_16
        }
        
        header.textLabel.text = self.titleOfSections[section]

        return header
    }
}
