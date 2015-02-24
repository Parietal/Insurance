//
//  CompleteTableView.swift
//  SmartAlertAction
//
//  Created by Saurav on 04/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class CompleteTableView: UITableView,UITableViewDataSource,UITableViewDelegate {

    var delegateAlert: [DelegateModel]?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.frame = frame
        self.dataSource = self
        self.delegate = self

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return delegateAlert![section].name
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return delegateAlert!.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (delegateAlert?[section].details.count)!;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("alertCell") as AlertTableViewCell!
        if let myCel = cell {
            
        }
        else {
            cell = AlertTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "alertCell")
        }
        
        let delegateModel = delegateAlert![indexPath.section] as DelegateModel
        cell.premiumStatus.text = delegateModel.details[indexPath.row].desc
        cell.clientLabel.text = delegateModel.details[indexPath.row].clientName
        cell.ratingView.rate = UInt(delegateModel.details[indexPath.row].rank)
        cell.delegateButton.hidden = true
        cell.delegatedToLabel.text = delegateModel.details[indexPath.row].delegateAgent
        cell.delegatedToLabel.textColor = RAColors.GREEN1
        cell.delegatedToLabel.frame = CGRect(x: 20, y: 56, width: 280, height: 25)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell;
        
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 86;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        
        var titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: view.frame.size.height))
        titleLabel.text = delegateAlert![section].name.uppercaseString
        titleLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        view.addSubview(titleLabel)
        
        var subTitleLabel = UILabel(frame: CGRect(x: tableView.frame.size.width - 78, y: 0, width: 100, height: view.frame.size.height))
        subTitleLabel.text = NSString(string: "\(delegateAlert![section].details.count) alerts")
        subTitleLabel.font = RAFonts.HELVETICA_NEUE_BOLD_13
        view.addSubview(subTitleLabel)
        
        view.layer.borderColor = RAColors.GRAY4.CGColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = RAColors.GRAY2
        
        return view
    }
}
