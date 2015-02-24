//
//  SmartListsViewCell.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/13/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

enum AlertAction: Int {
    case Contact = 1
    case Postpone = 2
    case Delegate = 3
}

protocol SmartListViewCellDelegate: NSObjectProtocol {
    
    //Rect is required for opening PopOver ar particular Frame
    func smartListViewCell(cell: SmartListViewCell, didTriggerAction action: AlertAction,atFrame rect: CGRect)
    
}

protocol RecommendationDelegate {

    func didSelectRecommendation(alert:AlertModel,isAlertRecommendation:Bool)
}
class SmartListViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView:UITableView!
    
    var delegate:SmartListViewCellDelegate?
    var alert:AlertModel?
    private var policyPremiumPercentile:UInt?
    var agentBook:AgentBookModel?
    var recommendationDelegate: RecommendationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // disable scroll on iPad
        self.tableView.scrollEnabled = false
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            // 1 section with 3 cells
            return 1
        } else {
            // 2 section, first section 2 cell, second section for recommendations
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        var header :CustomTableViewHeaderFooterView = CustomTableViewHeaderFooterView()
        
        header.textLabel.font = RAFonts.HELVETICA_NEUE_MEDIUM_14
        header.textLabel.textColor = RAColors.GRAY7

        header.contentView.backgroundColor = UIColor.whiteColor()
        header.bottomSeparatorColor = RAColors.GRAY5
        
        return header
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recommendations"
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            return 3
        } else {
            // both 2 cells in section 1 & 2
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if indexPath.section == 0 {
            if indexPath.row == 0
            {
                if idiom == UIUserInterfaceIdiom.Pad {
                    return 195
                } else {
                    return 162
                }
            }
            if indexPath.row == 1
            {
                if idiom == UIUserInterfaceIdiom.Pad {
                    return 185
                } else {
                    return 160
                }
            }
            else
            {
                return 240
            }
        } else {
            // iPhone, recommendations
            return 44
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = UITableViewCell()
        
        if indexPath.section == 0 && indexPath.row == 0
        {
            cell = tableView.dequeueReusableCellWithIdentifier("AlertClientCell") as? UITableViewCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        else if indexPath.section == 0 && indexPath.row == 1
        {
            cell = tableView.dequeueReusableCellWithIdentifier("AlertDetailCell") as? UITableViewCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCellWithIdentifier("RecommendationsCell") as? UITableViewCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        else if indexPath.section == 1 {
            cell = AlertRecommendationCell2(style: UITableViewCellStyle.Default, reuseIdentifier: "RecommendationCell")
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)!
            cell?.textLabel?.textColor = RAColors.GRAY7
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            if indexPath.row == 0 {
                cell?.textLabel?.text = alert?.alertRecommendation?.title
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = alert?.salesRecommendation?.title
            }
        }
        
        if let alertClientCell = cell as? AlertClientCell {
            alertClientCell.nameLabel.text = alert?.client?.displayName
            var policyPremium = alert?.policyPremiumValue
            var maxPolicyPremium = agentBook?.maxPolicyPremiumValue
            
            alertClientCell.policyPremiumView.max = 100
            alertClientCell.policyPremiumView.value = self.policyPremiumPercentile!
            alertClientCell.policyPremiumView.text = alert!.policyPremium!.value

            alertClientCell.policiesInHouseholdView.max = UInt(agentBook!.maxPoliciesInHousehold!.value.toInt()!)
            alertClientCell.policiesInHouseholdView.value = UInt(alert!.policiesInHousehold!.value.toInt()!)
            
            alertClientCell.yearsAsClientView.setRating(Int(alert!.yearsAsClient!.value.toInt()!))
        }
        else if let alertDetailCell = cell as? AlertDetailCell {
            alertDetailCell.titleLabel.text = alert?.category?.subTitle
            alertDetailCell.subTitleLabel.text = alert?.category?.policyType
            alertDetailCell.messageLabel.text = alert?.message
            alertDetailCell.starRate.rate = UInt(alert!.rank!)
            
            // set the font for the uncompleted alert
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                alertDetailCell.noteLabel.font = RAFonts.SMARTLISTS_CELL_ALERT_NOTE
            }
            else {
                alertDetailCell.noteLabel.font = RAFonts.SMARTLISTS_CELL_ALERT_NOTE_IPHONE
            }
            alertDetailCell.noteLabel.text = alert?.category?.note
            alertDetailCell.noteLabel.textColor = RAColors.RED1
            
            // set the background color for uncompleted alert
            if  (alert?.category?.note != "") {
                alertDetailCell.containerView.backgroundColor = RAColors.GRAY3
            }
            else {
                alertDetailCell.containerView.backgroundColor = RAColors.GRAY2
            }
        }
        else if let alertRecommendationCell = cell as? AlertRecommendationCell {
            alertRecommendationCell.alertRecommendationTitle.text = alert?.alertRecommendation?.title
            alertRecommendationCell.alertRecommendationDetail.text = alert?.alertRecommendation?.detail
            alertRecommendationCell.salesRecommendationTitle.text = alert?.salesRecommendation?.title
            alertRecommendationCell.salesRecommendationDetail.text = alert?.salesRecommendation?.detail
            
            // **Bruce - changed colors
            alertRecommendationCell.alertRecommendationDetail.textColor = RAColors.GRAY7
            alertRecommendationCell.salesRecommendationDetail.textColor = RAColors.GRAY7
            
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {

            if recommendationDelegate != nil {
            
                //recommendationDelegate?.didSelectRecommendation(self.alert!)
                recommendationDelegate?.didSelectRecommendation(self.alert!, isAlertRecommendation: indexPath.row == 0 ? true : false)
            }
        }
    }
    
    func updateAlert(alert: AlertModel, alerts: [AlertModel], agentBook: AgentBookModel) {
        self.alert = alert

        // calc percentile
        var policyPremiumValues:[Double] = []
        for a:AlertModel in alerts {
            policyPremiumValues.append(a.policyPremiumValue)
        }
        policyPremiumValues = sorted(policyPremiumValues)
        self.policyPremiumPercentile = StatisticsUtils.percentile(alert.policyPremiumValue, sorted_array: policyPremiumValues)
        
        self.agentBook = agentBook
        self.tableView.reloadData()
    }
    
    @IBAction func onAction(sender: UIButton) {
        var tag:Int = sender.tag
        var rect = CGRect()
        var action:AlertAction?
        switch tag {
        case AlertAction.Contact.rawValue:
            action = .Contact
        case AlertAction.Postpone.rawValue:
            action = .Postpone
            
            //calculate rect based on parent views
            let indexPath:NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
            let cellRect:CGRect = tableView.rectForRowAtIndexPath(indexPath)
            let x:CGFloat = self.frame.origin.x + cellRect.origin.x + sender.frame.origin.x
            let y:CGFloat = self.frame.origin.y + cellRect.origin.y + sender.frame.origin.y
            let w:CGFloat = sender.frame.width
            let h:CGFloat = sender.frame.height
            rect = CGRectMake(x, y, w, h)
            
        case AlertAction.Delegate.rawValue:
            action = .Delegate
            rect = tableView.convertRect(tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)), toView: tableView)
            

        default:
            return
        }
        // dispath
        delegate?.smartListViewCell(self, didTriggerAction: action!,atFrame :rect)
    }
    
}
