//
//  AlertTableView.swift
//  DelegateAlerts
//
//  Created by Saurav on 14/10/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit


protocol ButtonTapDelegate {
    
    func didTapButtonAtIndex(index:Int,tableIndex:Int)
}
class AlertTableView: UITableView,UITableViewDataSource,UITableViewDelegate {

    var buttonTapDelegate: ButtonTapDelegate!
    var delegateAlert: DelegateModel?
    var isAlertCompleted: Bool = false
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.frame = frame
        self.dataSource = self
        self.delegate = self
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 0.5
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        return delegateAlert!.name
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (delegateAlert?.details.count)!;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("alertCell") as AlertTableViewCell!
        if let myCel = cell {
            
        }
        else {
            cell = AlertTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "alertCell")
            cell.delegateButton.addTarget(self, action: "delegateBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        cell.premiumStatus.text = delegateAlert?.details[indexPath.row].desc
        cell.clientLabel.text = delegateAlert?.details[indexPath.row].clientName
        cell.ratingView.rate = UInt(delegateAlert!.details[indexPath.row].rank)
        if isAlertCompleted {
            
            cell.delegateButton.hidden = true
            cell.delegatedToLabel.text = delegateAlert?.details[indexPath.row].delegateAgent
            cell.delegatedToLabel.textColor = RAColors.GREEN1
            cell.delegatedToLabel.frame = CGRect(x: 20, y: 56, width: 280, height: 25)
        }
        else {
            cell.delegatedToLabel.text = "delegated to"
            cell.delegateButton.setTitle(delegateAlert?.details[indexPath.row].delegateAgent, forState: UIControlState.Normal)
            cell.delegateButton.tag = indexPath.row
            
        }
        
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
        titleLabel.text = delegateAlert!.name.uppercaseString
        titleLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        view.addSubview(titleLabel)
        
        var subTitleLabel = UILabel(frame: CGRect(x: tableView.frame.size.width - 78, y: 0, width: 100, height: view.frame.size.height))
        subTitleLabel.text = NSString(string: "\(delegateAlert!.details.count) alerts")
        subTitleLabel.font = RAFonts.HELVETICA_NEUE_BOLD_13
        view.addSubview(subTitleLabel)
        
        view.backgroundColor = RAColors.GRAY2
        return view
    }
    func delegateBtnTapped(sender:UIButton) {

        if self.buttonTapDelegate != nil {
        
            self.buttonTapDelegate.didTapButtonAtIndex(sender.tag, tableIndex: self.tag)
        }
    }
}
