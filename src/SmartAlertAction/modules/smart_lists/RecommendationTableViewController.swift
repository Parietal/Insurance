//
//  RecommendationTableViewController.swift
//  SmartAlertAction
//
//  Created by Saurav on 19/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class RecommendationTableViewController: UITableViewController {

    var alert:AlertModel?
    var isAlertRecommendation = true
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView?.hidden = true
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.title = "Recommendation"
        self.navigationController?.navigationBar.topItem?.title = "Back"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Configure the cell...
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.RECOMMENDATION_HEADER_CELL) as UITableViewCell!
        cell.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = UIColor.whiteColor()
        if isAlertRecommendation {
            cell.textLabel?.text = alert?.alertRecommendation?.title
        }
        else {
            cell.textLabel?.text = alert?.salesRecommendation?.title
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.RECOMMENDATION_CELL) as UITableViewCell!

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: Constants.RECOMMENDATION_CELL)
            cell.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_14
            cell.textLabel?.textColor = RAColors.GRAY5
            cell.textLabel?.numberOfLines = 0
        }
        
        if isAlertRecommendation {
            cell.textLabel?.text = alert?.alertRecommendation?.detail
        }
        else {
            cell.textLabel?.text = alert?.salesRecommendation?.detail
        }
        return cell
    }
    

}
