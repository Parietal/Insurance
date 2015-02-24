//
//  ClientInfoIphoneTableVC.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 10/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ClientInfoIphoneTableVC : UITableViewController ,UITableViewDelegate, UITableViewDataSource,PageTransitionProtocol,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate{
 
    // class variables
    var titleOfContactInfo: [String] = ["Address", "Phone", "Mobile", "Email"]
    
    
    var phoneIcons: [UIImage] = [UIImage(named: "icon_phone_up")!, UIImage(named: "icon_phone_down")!]
    
     var addressIcons: [UIImage] = [UIImage(named: "icon_car_up")!, UIImage(named: "icon_car_up")!]
    
    var textIcons: [UIImage] = [UIImage(named: "icon_text_up")!, UIImage(named: "icon_text_down")!]
    var emailIcons: [UIImage] = [UIImage(named: "icon_email_up")!, UIImage(named: "icon_email_down")!]
    
    var clientDetail: ClientModel?
    var clientId: Int = 0
    
    var TAG_ADDRESS_CELL:Int { return 200 }
    var TAG_PHONE_CELL:Int { return 201 }
    var TAG_MOBILE_CELL:Int { return 202 }
    var TAG_EMAIL_CELL:Int { return 203 }
    
    var currentCellTag : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load client data
        self.loadData()
    }
    
    
    func loadData() {
        ClientService.getDetailsForClient(self.clientId, completionHandler: {(client:ClientModel?, error: NSError?) -> Void in
            
            self.title = "Contact Information"
            
            // assign to client detail
            self.clientDetail = client
            var clientAddress = self.clientDetail?.address
            
            self.navigationController?.navigationBar.tintColor = RAColors.BLUE1  // Bruce ** Color Change
            
            // reload client data
            self.tableView.reloadData()
            
        })
        
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell: UITableViewCell?
        
        var cellHeight : CGFloat = 44
        
        if(indexPath.section == 0 && indexPath.row == 0){
            
            cellHeight = 70
        }else{
            cellHeight = 55
        }
        
        return cellHeight
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RASizes.CLIENT_INFO_HEADER_CELL_HEIGHT
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
            
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
            
            //  birthday!.append("()")
            
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
    }
      
    // method to implement for MessageComposeDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult){
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    //button to save contact to device
    
    @IBAction func saveContactBtn(sender: AnyObject) {
    }
    
    //button to add a note for the client
    @IBAction func addNoteBtn(sender: AnyObject) {
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return self.rowsOfSections[section]
    //    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        cell = self.initContactInfoSection(cellForRowAtIndexPath: indexPath)
        
        return cell!
    }
    
    // contact info section
    func initContactInfoSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        switch row {
        case 0:
            cell = self.setContactCell(row,title: self.titleOfContactInfo[row], text: self.clientDetail?.address, firstIcons: self.addressIcons, secondIcons: nil, tag: TAG_ADDRESS_CELL)
            
        case 1:
            cell = self.setContactCell(row,title: self.titleOfContactInfo[row], text: self.clientDetail?.phone, firstIcons: self.phoneIcons, secondIcons: nil, tag: TAG_PHONE_CELL)
        case 2:
            cell = self.setContactCell(row,title: self.titleOfContactInfo[row] ,text: self.clientDetail?.mobile, firstIcons: self.phoneIcons, secondIcons: self.textIcons, tag: TAG_MOBILE_CELL)
        case 3:
            cell = self.setContactCell(row, title: self.titleOfContactInfo[row],text: self.clientDetail?.email, firstIcons: self.emailIcons, secondIcons: nil, tag: TAG_EMAIL_CELL)
        default:
            cell = UITableViewCell()
        }
        
        return cell!
    }
    
    // set each cell according to its type
    
    func setContactCell(index: Int,title: String?, text: String?, firstIcons: [UIImage]?, secondIcons: [UIImage]?, tag : Int) -> UITableViewCell {
        
        var cell : ClientDetailContactTableViewCell?
        
        
        if(tag == TAG_ADDRESS_CELL){
            cell = tableView.dequeueReusableCellWithIdentifier("addressCell") as? ClientDetailContactTableViewCell
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("contactCell") as? ClientDetailContactTableViewCell
        }

        cell?.titleLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        cell?.contentLabel.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
        cell?.titleLabel.text = title!
        cell?.contentLabel.text = text
        if(tag == TAG_ADDRESS_CELL){
            cell?.contentLabel?.numberOfLines = 0
        }
        if firstIcons != nil {
            cell?.cellTag = tag
            
            cell?.rightButton1.setImage(firstIcons?[0], forState: UIControlState.Normal)
            cell?.rightButton1.setImage(firstIcons?[1], forState: UIControlState.Highlighted)
            cell?.rightButton1.hidden = false
            cell?.rightButton1.tag = tag
        } else {
            cell?.rightButton1.hidden = true
        }
        if secondIcons != nil {
            cell?.rightButton2.setImage(secondIcons?[0], forState: UIControlState.Normal)
            cell?.rightButton2.setImage(secondIcons?[1], forState: UIControlState.Highlighted)
            cell?.rightButton2.hidden = false
            cell?.rightButton2.tag = tag
        } else {
            cell?.rightButton2.hidden = true
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableView){
            return 4
        }else{
            return 1
        }
    }
    
    // MARK: - Page Transition Protocol
    
    func setInputParams(params: Dictionary<String, AnyObject>) {
        // get and set client id
        if let id = params[ClientDetailTableViewController.INPUT_PARAM_CLIENT_ID]! as? Int {
            self.clientId = id
        }
    }
    
    
    @IBAction func actionButtonTapped(sender: AnyObject) {
        
       // if(sender.)
        
        
    }
    
    
    @IBAction func rightButton1Tapped(sender: AnyObject) {
        
        switch(sender.tag){
        
            case TAG_MOBILE_CELL:
                textClient(sender)
                break
            default:
                break
        }
        
    }
    
    
    @IBAction func rightButton2Tapped(sender: AnyObject) {
        
                switch(sender.tag){
        
                    case TAG_ADDRESS_CELL:
                        UIAlertView(title: "", message: "Function not yet available", delegate: nil, cancelButtonTitle: "OK").show()
                        break
        
                    case TAG_PHONE_CELL:
                        callClient(sender)
                        break
                    
                    case TAG_MOBILE_CELL:
                        callClient(sender)
                        break
        
                    case TAG_EMAIL_CELL:
                        emailClient(sender)
                        break
                    default:
                        break
                }

    }
    

    
    
    func textClient(sender: AnyObject) {
        var client: ClientModel = self.clientDetail!
        
        var str_number = client.mobile
        
        var mobileNumber = ""
        
        for tempChar in str_number.unicodeScalars {
            let value = tempChar.value
            
            if (value >= 48 && value <= 57) {
                mobileNumber.append(tempChar)
            }
        }
        
            var app:UIApplication = UIApplication.sharedApplication()
            
            if(MFMessageComposeViewController.canSendText()){
                // device can send Message
                var msgController = MFMessageComposeViewController()
                msgController.body = "Hello"
                msgController.recipients = [mobileNumber]
                
                msgController.messageComposeDelegate = self
                //[self presentModalViewController:controller animated:YES];
                // [self presentViewController:controller animated:YES completion:nil];
                self.presentViewController(msgController, animated: true, completion: nil)
                
            }else{
                UIAlertView(title: "", message: "Text message not supported on this device", delegate: nil, cancelButtonTitle: "OK").show()
            }
    }
    
    // MARK: - UI action handling
    
    func callClient(sender: AnyObject) {
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            // no action on iPad
            return
        }else{
            var client: ClientModel = self.clientDetail!
            var str_number = ""
            
            if(sender.tag == TAG_PHONE_CELL){
                str_number = client.phone
            }else if(sender.tag == TAG_MOBILE_CELL){
                str_number = client.mobile
            }
            
            var callingNumber = ""
            
            for tempChar in str_number.unicodeScalars {
                let value = tempChar.value
                
                if (value >= 48 && value <= 57) {
                    callingNumber.append(tempChar)
                }
            }
            
            var app:UIApplication = UIApplication.sharedApplication()
            app.openURL(NSURL(string: "tel:" + callingNumber)!)
        }

    }
    
    func emailClient(sender: AnyObject) {
        var app:UIApplication = UIApplication.sharedApplication()
        var client: ClientModel = self.clientDetail!
      //  app.openURL(NSURL(string: "mailto:" + client.email))
        if MFMailComposeViewController.canSendMail() {
            var mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setToRecipients([client.email])
            mailComposeViewController.mailComposeDelegate = self
            //            var navigationController = UINavigationController(rootViewController: mailComposeViewController)
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }else{
            UIAlertView(title: "", message: "Cannot send email", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
}
