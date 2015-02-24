//
//  ClientProfileTableViewController.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 30/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class ClientProfileTableViewController: UITableViewController {
    
    var titleOfSections: [String] = ["PROFILE", "ACCOUNT NOTES"]
    // class variables
    var titleOfContactInfo: [String] = ["Gender", "Marital Status", "Annualized Premium", "Retention Risk Score"]
    
    var heightOfRationaleText :CGFloat = 0
    
    var rowsOfSections: [Int] = [4, 0]
    
    var clientDetail: ClientModel?
    var clientId: Int = 0
    var alertId: Int = 1
    
    // activity indicator
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    var alertDetail: AlertModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load client data
        self.loadData()
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            self.tableView.tableHeaderView?.hidden = true
        }
    }
    
    func loadData() {
	// show loading
        self.spinner.startAnimatingOnView(self.view)
        ClientService.getDetailsForClient(self.clientId, completionHandler: {(client:ClientModel?, error: NSError?) -> Void in
            
            // assign to client detail
            self.clientDetail = client
            
            // set navigation title & color
              self.navigationItem.title = "Client Profile"
            self.navigationController?.navigationBar.tintColor = RAColors.DARK_BLUE
            
            // reset rows number
            self.rowsOfSections[1] = client!.notes.count
            
            // reload client data
            self.tableView.reloadData()
        })
        
        // load alert detail
        AlertService.getDetailsForAlert(self.alertId, completionHandler: {(alert: AlertModel?, error: NSError?) -> Void in
            
            // assign to alert model
            self.alertDetail = alert
            
            self.title = "Client Profile"
            //self.clientNameLabel.text = alert?.client?.displayName
            
            // display data on view
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.clientDetail == nil){
            return 0
        }else{
            return self.rowsOfSections[section]
        }

    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            if(section == 0){
                return RASizes.CLIENT_INFO_HEADER_CELL_HEIGHT
            }else{
                return RASizes.DEFAULT_CELL_HEIGHT
            }

        }else{
            return 0;
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cell: UITableViewCell?
        
        if(indexPath.section == 0 && indexPath.row == 3){
           
                var cellHeight : CGFloat = 0
                var notesStr = self.clientDetail!.rationaleModel?.text
                
                cellHeight = SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_15,labelSize: tableView.frame.size,labelText: "Retention Risk Score")
            
                var textht = SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_14,labelSize: tableView.frame.size,labelText: notesStr)
            
                self.heightOfRationaleText = textht
            
                cellHeight += textht + 20
                return cellHeight
            

        }else if(indexPath.section == 1){
           // cell = tableView.cellForRowAtIndexPath(indexPath)
            var cellHeight : CGFloat = 15
            
            cellHeight += SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_15,labelSize: tableView.frame.size,labelText: self.clientDetail?.notes[indexPath.row].text)
            
            cellHeight += SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_15,labelSize: tableView.frame.size,labelText: self.clientDetail?.notes[indexPath.row].getNoteTitle())
            
            return cellHeight
        }else{
            return 44
        }
        
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // var cell : UITableViewCell?
        if(section == 0){
            
            var clientHdrCell:ClientDetailHeaderCell? = tableView.dequeueReusableCellWithIdentifier("clientDetailheaderCell") as? ClientDetailHeaderCell
            //  clientHdrCell.separatorColor = RAColors.GRAY5
            // clientHdrCell.bottomSeparatorColor = RAColors.GRAY5
            clientHdrCell?.clientName.text = self.clientDetail?.getFullName()
            clientHdrCell?.clientName.font = RAFonts.HELVETICA_NEUE_BOLD_16
            clientHdrCell?.dobAge.font = RAFonts.HELVETICA_NEUE_REGULAR_15
            clientHdrCell?.clientSince.font = RAFonts.HELVETICA_NEUE_REGULAR_15
            
            //   years.text.toInt()!
            
            let age : Int! = self.clientDetail?.getAge()
            
            var str_age : String?
            
            if let age = age {
                str_age = String(age)
            }
            
            var birthday:String!
            if let birthDate = self.clientDetail?.birthDate {
                var bDay = StringUtils.convertDateToString(birthDate, format: Constants.BIRTHDAY_FORMAT)
                bDay += " (" + str_age! + ")"
                
                birthday = bDay
            }
            
            clientHdrCell?.dobAge.text = birthday
            
            if (clientDetail?.clientSince != nil) {
                
                var str_clientSince = clientDetail?.clientSince!
                
                if(countElements(str_clientSince!)>4){
                    let end = advance(str_clientSince!.startIndex, 4)
                    var year = str_clientSince?.substringToIndex(end)
                    clientHdrCell?.clientSince.text = "Client Since " + year!
                }else{
                    clientHdrCell?.clientSince.text = "Client Since " + str_clientSince!
                }
            }else{
                clientHdrCell?.clientSince.text = "Client Since "
            }
            
            clientHdrCell?.contentView.backgroundColor = RAColors.GRAY2
            
            var separatorLabel : UILabel = UILabel()
            separatorLabel.frame = CGRectMake(0, RASizes.CLIENT_INFO_HEADER_CELL_HEIGHT, 320, 0.5)
            separatorLabel.backgroundColor = RAColors.GRAY5
            clientHdrCell?.addSubview(separatorLabel)
            
            return clientHdrCell
        }else{
            
            var customSectionHeader : UIView = UIView()
            customSectionHeader.frame = CGRectMake(0, 0, 320, 44)
            customSectionHeader.backgroundColor = RAColors.LIGHT_GRAY  //UIColor.lightGrayColor()
            
            var topSeparatorLabel : UILabel = UILabel()
            topSeparatorLabel.frame = CGRectMake(0, 0, 320, 0.5)
            topSeparatorLabel.backgroundColor = RAColors.GRAY5
            customSectionHeader.addSubview(topSeparatorLabel)
            
            var titleLabel : UILabel = UILabel()
            titleLabel.frame = CGRectMake(10, 20, 200, 24)
            titleLabel.backgroundColor = UIColor.clearColor()
            titleLabel.textColor = UIColor.blackColor()
            titleLabel.text = self.titleOfSections[section]
            titleLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_15
            titleLabel.textColor = RAColors.GRAY8
            customSectionHeader.addSubview(titleLabel)
            
            var separatorLabel : UILabel = UILabel()
            separatorLabel.frame = CGRectMake(0, 44.5, 320, 0.5)
            separatorLabel.backgroundColor = RAColors.GRAY5
            customSectionHeader.addSubview(separatorLabel)
            
            customSectionHeader.backgroundColor = RAColors.GRAY2
            return customSectionHeader
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        var currentSection = indexPath.section
        if(currentSection == 0){
            cell = self.initBasicInfoSection(cellForRowAtIndexPath: indexPath)
        }else if(currentSection == 1){
            cell = self.initAccountNotesSection(cellForRowAtIndexPath: indexPath)
        }
        else{
            cell = UITableViewCell()
        }
        
        return cell!
    }

    
    // basic info section
    func initBasicInfoSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("profileInfoCell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "profileInfoCell")
        }
        
        var row = indexPath.row
        
        cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell?.textLabel?.textColor = RAColors.GRAY8
        cell?.textLabel?.text = self.titleOfContactInfo[row]
 
        cell?.detailTextLabel?.textColor = UIColor.blackColor()
        cell?.detailTextLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
        switch row {
        case 0:
            cell?.detailTextLabel?.text = self.clientDetail?.gender?.title
            if self.clientDetail?.gender?.title == nil {
                cell?.detailTextLabel?.text = "Gender"
            }
        case 1:
            var maritalStatus = self.clientDetail?.maritalStatus?.title
            cell?.detailTextLabel?.text = maritalStatus
            if self.clientDetail?.maritalStatus?.title == nil {
                cell?.detailTextLabel?.text = "Status"
            }
        case 2:
            var annualPremium = self.clientDetail?.annualizedPremium?.value
            cell?.detailTextLabel?.text = annualPremium
            if self.clientDetail?.annualizedPremium?.value == nil {
                cell?.detailTextLabel?.text = "Premium"
            }
        case 3:
            var retentionCell = tableView.dequeueReusableCellWithIdentifier("retentionRiskCell") as? RetentionRiskCell
            
            retentionCell?.titleLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
            retentionCell?.titleLabel?.textColor = RAColors.GRAY8
            retentionCell?.titleLabel?.text = "Retention Risk Score"
          //  retentionCell?.subtitleLabel?.frame.size.height = self.heightOfRationaleText
            println("heightOfRationaleText HT======\(heightOfRationaleText)")
          //  retentionCell?.subtitleLabel?.text = self.clientDetail?.rationaleModel?.text
            retentionCell?.retentionRiskScore?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
         //   retentionCell?.subtitleLabel?.numberOfLines = 0
          //  retentionCell?.subtitleLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_14
         //   retentionCell?.subtitleLabel?.textColor = RAColors.GRAY6
            retentionCell?.retentionRiskScore.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
            let retentionRiskScore : Int! = self.clientDetail?.retentionRiskScore
            
            var str_retentionScore : String?
            //   println("age.....\(age!)")
            
            
            if let retentionRiskScore = retentionRiskScore {
                str_retentionScore = String(retentionRiskScore)
            }
            retentionCell?.retentionRiskScore.text = str_retentionScore
            
           // retentionCell?.clientDetail = self.clientDetail
            
            retentionCell?.addContent(self.clientDetail)
            
            return retentionCell!
        default:
            return cell!
        }
        
        return cell!
    }
    
    // account notes section
    func initAccountNotesSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        var row = indexPath.row
        
        var notes: AccountNoteModel? = self.clientDetail?.notes[row]
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "noteCell")
        }
        cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell?.detailTextLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        cell?.textLabel?.text = notes?.text
        cell?.detailTextLabel?.text = notes?.getNoteTitle()
        cell?.textLabel?.numberOfLines = 0
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.textColor = RAColors.GRAY7
        
        return cell!
    }
    
    func setBasicInfoCell(index: Int, text: String?) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("profileInfoCell") as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.textLabel?.text = self.titleOfContactInfo[index]
        switch(index){
        case 0:
            cell.detailTextLabel?.text = self.clientDetail?.gender?.title
            break
        case 1:
            cell.detailTextLabel?.text = self.clientDetail?.maritalStatus?.title
            break
        case 2:
            cell.detailTextLabel?.text = self.clientDetail?.annualizedPremium?.value
            break
        default:
            break
            
        }
        
        return cell
        
        
        
    }
    
}
