//
//  OtherCategoryTableViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/19/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

protocol OtherCategoryDelegate {
    func didSelectedSubCategoryAtIndex(category:String)
}

class OtherCategoryTableViewController: UITableViewController {
    
    var selectedSubCategory:String = ""
    var otherSubCategory:[String:AlertCategoryViewModel] = [:]
    var delegate:OtherCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherSubCategory.keys.array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let key:String = self.otherSubCategory.keys.array[indexPath.row]
        cell.textLabel?.text = "\(key) (\(self.otherSubCategory[key]!.number))";
        cell.textLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
        if key == selectedSubCategory{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.textLabel?.textColor = RAColors.BLUE1
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.textLabel?.textColor = RAColors.GRAY8
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let key:String = self.otherSubCategory.keys.array[indexPath.row]
        self.dismissViewControllerAnimated(true, completion:nil)
        delegate?.didSelectedSubCategoryAtIndex(key)
    }
    
}
