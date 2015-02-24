//
//  CategoryViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/28/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

protocol CategoryViewDelegate{
    func categoryView(didSelectedCategory category: String)
}

class CategoryViewController: UITableViewController
{
    var delegate:CategoryViewDelegate?
    var categories: [String] = []
    var selectedCategory: String = ""
    var data: [String: AlertCategoryViewModel] = [:] {
        didSet {
            categories = [Constants.SMART_LIST_CATEGORY_NAMES.ALL_ALERTS.rawValue,
                Constants.SMART_LIST_CATEGORY_NAMES.RETENTION.rawValue,
                Constants.SMART_LIST_CATEGORY_NAMES.LEADS.rawValue,
                Constants.SMART_LIST_CATEGORY_NAMES.DELEGATED.rawValue,
                Constants.SMART_LIST_CATEGORY_NAMES.COMPLETED.rawValue]
            //for (key, value) in data {
            //    categories.append(key)
            //}
            
            //temporary solution for showing "Other" for iPad and all categories for iPhone
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                //dynamically get all categories from data
                var dynamicCategories:[String:Int] = [String:Int]()
                AlertService.getAllForAgent(0, completionHandler: {(alerts:[AlertModel]?, error:NSError?) -> Void in
                    if alerts != nil
                    {
                        for alert in alerts!
                        {
                            var title:String = alert.category!.title
                            if title != Constants.SMART_LIST_CATEGORY_NAMES.RETENTION.rawValue && title != Constants.SMART_LIST_CATEGORY_NAMES.LEADS.rawValue
                            {
                                var count:Int = dynamicCategories[title] == nil ? 0 : dynamicCategories[title]! + 1
                                dynamicCategories[title] = count
                            }
                        }
                        
                        for (key, value) in dynamicCategories {
                            self.categories.insert(key, atIndex: self.categories.count-2)
                        }
                        
                        self.tableView.reloadData()
                    }
                })
            }
            else
            {
                //this is only used for the iphone so if it comes here, something is wrong
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Category"
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "categoryCell")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancel:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("categoryCell") as UITableViewCell?

        var category = categories[indexPath.row]
        
        //TODO: Need to make alerts as optional, as it might be the case that there are no alert for some category
        var count = self.data[category] != nil ? self.data[category]!.number : 0
        cell?.textLabel?.text = "\(category) (\(count))"

        if category == selectedCategory {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell?.accessoryView?.tintColor = RAColors.BLUE1
            cell?.textLabel?.textColor = RAColors.BLUE1
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell?.textLabel?.textColor = UIColor.blackColor()
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var category = categories[indexPath.row]
        delegate?.categoryView(didSelectedCategory: category)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func cancel(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
