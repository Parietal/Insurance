//
//  ClientDetailTableViewController.swift
//  SmartAlertAction
//
//  Created by SunTeng on 9/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import AddressBookUI
import AddressBook

class ClientDetailTableViewController: UITableViewController, ABNewPersonViewControllerDelegate, PageTransitionProtocol {
    
    // input params
    class var INPUT_PARAM_CLIENT_ID: String { return "clientId" }
    
    // ui controls
    var contactCell: ClientDetailContactTableViewCell?
    var actionCell: UITableViewCell?
    var infoCell: UITableViewCell?
    var productCell: UITableViewCell?
    var settingsCell: UITableViewCell?
    
    var phoneIcons: [UIImage] = [UIImage(named: "icon_phone_up")!, UIImage(named: "icon_phone_down")!]
    var textIcons: [UIImage] = [UIImage(named: "icon_text_up")!, UIImage(named: "icon_text_down")!]
    var emailIcons: [UIImage] = [UIImage(named: "icon_email_up")!, UIImage(named: "icon_email_down")!]
    
    // class variables
    var titleOfSections: [String] = ["CONTACT INFO", "BASIC INFO", "PRODUCTS", "SMART ALERTS SETTINGS", "ACCOUNT NOTES"]
    var rowsOfSections: [Int] = [5, 3, 0, 1, 0]
    var titleOfContactInfo: [String] = ["Address", "Phone", "Mobile", "Email"]
    var actionOfContactInfo: [String] = ["Create New Contact", "Add to Existing Contact List"]
    var labelOfBasicInfo: [String] = ["Gender", "Age", "Date of Birth"]
    var showAlertTitle = "Show Alerts"
    var clientDetail: ClientModel?
    var clientId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load client data
        self.loadData()
    }
    
    func loadData() {
        ClientService.getDetailsForClient(self.clientId, completionHandler: {(client:ClientModel?, error:NSError?) -> Void in

            // assign to client detail
            self.clientDetail = client
            
            // set navigation title & color
            self.navigationItem.title = client!.getFullName()
            self.navigationController?.navigationBar.tintColor = RAColors.BLUE1  // Bruce ** Color Change
            
            // reset rows number
            self.rowsOfSections[2] = client!.products.count
            self.rowsOfSections[4] = client!.notes.count
            
            // reload client data
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.titleOfSections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowsOfSections[section]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell: ListTableHeaderCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as ListTableHeaderCell
        
        var title: String = self.titleOfSections[section]
        cell.titleLabel?.text = title
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            cell.titleLabel?.font = RAFonts.SMARTLISTS_CONTACT_SECTION_TITLE
        } else {
           cell.titleLabel?.font = RAFonts.SMARTLISTS_CONTACT_SECTION_TITLE_IPHONE
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RASizes.LIST_TABLE_HEADER_HEIGHT
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if ((indexPath.section == 0 && indexPath.row < 4) || indexPath.section == 4 ) {
            return 70
        } else {
            return RASizes.DEFAULT_CELL_HEIGHT
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var section = indexPath.section
        switch section {
        case 0:
            cell = self.initContactInfoSection(cellForRowAtIndexPath: indexPath)
        case 1:
            cell = self.initBasicInfoSection(cellForRowAtIndexPath: indexPath)
        case 2:
            cell = self.initProductsSection(cellForRowAtIndexPath: indexPath)
        case 3:
            cell = self.initSettingsSection(cellForRowAtIndexPath: indexPath)
        case 4:
            cell = self.initAccountNotesSection(cellForRowAtIndexPath: indexPath)
        default:
            cell = UITableViewCell()
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 4 {
                var newContactViewController = ABNewPersonViewController()
                newContactViewController.newPersonViewDelegate = self
                //self.navigationController?.pushViewController(newContactViewController, animated: true)
                var navigationController = UINavigationController(rootViewController: newContactViewController)
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        } else if indexPath.section == 2 {
            var policyModel: PolicyModel? = self.clientDetail?.products[indexPath.row]

            var policyDetailController = UIStoryboard(name: "PolicyDetails", bundle: nil).instantiateInitialViewController() as PolicyDetailTableViewController
            
            policyDetailController.policyId = policyModel!.id
            self.navigationController?.pushViewController(policyDetailController, animated: true)

        } else {
            // nop
        }
    }
    
    // contact info section
    func initContactInfoSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        switch row {
        case 0:
            cell = self.setContactCell(row, text: self.clientDetail?.address, firstIcons: nil, secondIcons: nil)
        case 1:
            cell = self.setContactCell(row, text: self.clientDetail?.phone, firstIcons: self.phoneIcons, secondIcons: nil)
        case 2:
            cell = self.setContactCell(row, text: self.clientDetail?.mobile, firstIcons: self.phoneIcons, secondIcons: self.textIcons)
        case 3:
            cell = self.setContactCell(row, text: self.clientDetail?.email, firstIcons: self.emailIcons, secondIcons: nil)
        case 4:
            cell = self.setActionCell(0)
        case 5:
            cell = self.setActionCell(1)
        default:
            cell = UITableViewCell()
        }
        
        return cell!
    }
    
    // basic info section
    func initBasicInfoSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        switch row {
        case 0:
            cell = self.setBasicInfoCell(row, text: self.clientDetail?.gender?.title)
        case 1:
            cell = self.setBasicInfoCell(row, text: (self.clientDetail?.getAge() == nil ? "" : self.clientDetail?.getAge()?.description))
        case 2:
            var birthday:String?
            if let birthDate = self.clientDetail?.birthDate {
                birthday = StringUtils.convertDateToString(birthDate, format: Constants.BIRTHDAY_FORMAT)
            }
            cell = self.setBasicInfoCell(row, text: birthday)
        default:
            cell = UITableViewCell()
        }
        
        return cell!
    }
    
    // products section
    func initProductsSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        var product: PolicyModel? = self.clientDetail?.products[row]
        cell = self.setProductCell(row, title: product?.type?.subTitle, detail: product?.type?.title)
        
        return cell!
    }
    
    // settings section
    func initSettingsSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        var showAlert: Bool? = self.clientDetail?.settings?.showAlert
        cell = self.setSettingsCell(row, title: self.showAlertTitle, switchOn: showAlert)
        
        return cell!
    }
    
    // account notes section
    func initAccountNotesSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        var notes: AccountNoteModel? = self.clientDetail?.notes[row]
        cell = self.setNoteCell(row, title: notes?.getNoteTitle(), content: notes?.text)
        
        return cell!
    }
    
    // set each cell according to its type
    
    func setContactCell(index: Int, text: String?, firstIcons: [UIImage]?, secondIcons: [UIImage]?) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("contactCell") as ClientDetailContactTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.titleLabel.text = self.titleOfContactInfo[index]
        cell.contentLabel.text = text
        if firstIcons != nil {
            cell.rightButton1.setImage(firstIcons?[0], forState: UIControlState.Normal)
            cell.rightButton1.setImage(firstIcons?[1], forState: UIControlState.Highlighted)
            cell.rightButton1.hidden = false
        } else {
            cell.rightButton1.hidden = true
        }
        if secondIcons != nil {
            cell.rightButton2.setImage(secondIcons?[0], forState: UIControlState.Normal)
            cell.rightButton2.setImage(secondIcons?[1], forState: UIControlState.Highlighted)
            cell.rightButton2.hidden = false
        } else {
            cell.rightButton2.hidden = true
        }
        return cell
    }
    
    func setActionCell(index: Int) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("actionCell") as ClientDetailActionTableViewCell
        cell.actionLabel.text = self.actionOfContactInfo[index]
        return cell
    }
    
    func setBasicInfoCell(index: Int, text: String?) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("infoCell") as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = self.labelOfBasicInfo[index]
        cell.detailTextLabel?.text = text
        return cell
    }
    
    func setProductCell(index: Int, title: String?, detail: String?) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("productCell") as UITableViewCell
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        return cell
    }
    
    func setSettingsCell(index: Int, title: String?, switchOn: Bool?) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("settingsCell") as ClientDetailSettingsTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.settingsLabel.text = title
        if let on = switchOn {
            cell.settingsSwitch.setOn(on, animated: true)
        }
        return cell
    }
    
    func setNoteCell(index: Int, title: String?, content: String?) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("noteCell") as ClientDetailNotesTableViewCell
        cell.titleLabel.text = title
        cell.contentLabel.text = content
        return cell
    }
    
    // MARK: - ABNewPersonViewControllerDelegate
    
    func newPersonViewController(newPersonView: ABNewPersonViewController!, didCompleteWithNewPerson person: ABRecord!) {
//        newPersonView.navigationController?.popViewControllerAnimated(true)
        newPersonView.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Page Transition Protocol
    
    func setInputParams(params: Dictionary<String, AnyObject>) {
        // get and set client id
        if let id = params[ClientDetailTableViewController.INPUT_PARAM_CLIENT_ID]! as? Int {
            self.clientId = id
        }
    }

}
