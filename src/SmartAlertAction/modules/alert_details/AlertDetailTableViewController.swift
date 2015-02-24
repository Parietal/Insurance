//
//  AlertDetailTableViewController.swift
//  SmartAlertAction
//
//  Created by SunTeng on 9/8/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit
import MessageUI

class AlertDetailTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, PageTransitionProtocol {
    
    @IBOutlet var clientNameLabel: UILabel!
    @IBOutlet var clientInfoLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    var contactViewController: ContactViewController?
    
    private var clientNameCellIdentifier = "alertDetailClientNameCell"
    private var clientProfileCellIdentifier = "alertDetailClientProfileCell"
    private var clientProductCellIdentifier = "alertDetailClientProductCell"
    
    // input params
    class var INPUT_PARAM_ALERT_ID:String { return "alertId" }

    class var TAG_ACTION_TAKE_PHOTO:Int { return 101 }
    class var TAG_ACTION_SHARE:Int { return 102 }
    class var TAG_ACTION_CALL_CLIENT:Int { return 103 }
    class var TAG_ACTION_TEXT_CLIENT:Int { return 104 }
    
    // class constants
    let STATIC_ROW_NUMBER: Int = 4
    
    // class variables
    var alertId: Int? = Constants.DEFAULT_ALERT_ID
    var alertDetail: AlertModel?
    var selectedPolicyTitle:String!
    private var selectedRow = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Set the font and text color
        self.clientNameLabel.textColor = RAColors.GRAY8
        self.clientNameLabel.font = RAFonts.HELVETICA_NEUE_BOLD_20
        
        self.clientInfoLabel.textColor = RAColors.GRAY8
        self.clientInfoLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_16
        
        // reset text content
        self.clientNameLabel.text = ""

        // load alert data
        self.loadData()
        
        //PHM adjust margins for ipad
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.tableView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
            self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
        }
     
    }
    
    func loadData() {
        // load alert detail
        AlertService.getDetailsForAlert(self.alertId!, completionHandler: {(alert: AlertModel?, error: NSError?) -> Void in

            // assign to alert model
            self.alertDetail = alert
            
            self.clientNameLabel.text = alert?.client?.displayName
            
            // display data on view
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 // profile, products
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                return 6
            } else {
                return 3
            }
        } else if section == 1 {
            if alertDetail?.client?.products != nil {
                return alertDetail!.client!.products.count
            } else {
                return 0
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            return 44 //22
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        var header:ClientInfoHeaderCell = ClientInfoHeaderCell()
        var titleOfSection = ["Profile", "Products"]

        header.textLabel.textColor = RAColors.GRAY8
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            header.backgroundColor = UIColor.whiteColor()
            header.headerFont = RAFonts.SMARTLISTS_CONTACT_SECTION_TITLE
            header.textLabel.text = titleOfSection[section]
            header.paddingTop = 10
        } else {
            header.topSeparatorColor = RAColors.GRAY5
            header.bottomSeparatorColor = RAColors.GRAY5
            //PHM added font and text here
            header.headerFont = RAFonts.SMARTLISTS_CONTACT_SECTION_TITLE_IPHONE
            header.textLabel.text = titleOfSection[section].uppercaseString
        }
        
        return header
    }
    
    /* PHM Moved to viewForHeaderInSection
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleOfSection = ["Profile", "Products"]
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            return titleOfSection[section].uppercaseString
        } else {
            return titleOfSection[section]
        }
    }
*/
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell: UITableViewCell?
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(clientProfileCellIdentifier) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: clientProfileCellIdentifier)
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
            }

            // modify texLabel and detailTextLabel text colors and fonts
            cell?.textLabel?.textColor = RAColors.GRAY8
            cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
            
            cell?.detailTextLabel?.textColor = RAColors.GRAY8
            cell?.detailTextLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
            

            if indexPath.row == 0
            {
                cell?.textLabel?.text = "Client Since"
                cell?.detailTextLabel?.text = alertDetail?.client?.clientSince
            }
            else if indexPath.row == 1
            {
                cell?.textLabel?.text = "Gender"
                cell?.detailTextLabel?.text = alertDetail?.client?.gender?.title
            }
            else if indexPath.row == 2
            {
                cell?.textLabel?.text = "Age"
                cell?.detailTextLabel?.text = (alertDetail?.client?.getAge() == nil ? "" : String(alertDetail!.client!.getAge()!))
            }
            else if indexPath.row == 3
            {
                cell?.textLabel?.text = "Birthday"
                if alertDetail?.client?.birthDate != nil {
                    var df = NSDateFormatter()
                    df.dateStyle = NSDateFormatterStyle.LongStyle
                    cell?.detailTextLabel?.text = df.stringFromDate(alertDetail!.client!.birthDate!)
                } else {
                    cell?.detailTextLabel?.text = ""
                }
            }
            else if indexPath.row == 4
            {
                cell?.textLabel?.text = "Marital Status"
                cell?.detailTextLabel?.text = alertDetail?.client?.maritalStatus?.title
            }
            else if indexPath.row == 5
            {
                cell?.textLabel?.text = "Annualized Premium"
                cell?.detailTextLabel?.text = alertDetail?.client?.annualizedPremium?.value
            }
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier(clientProductCellIdentifier) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: clientProductCellIdentifier)
            }
            // modify texLabel and detailTextLabel text colors and fonts
            cell?.textLabel?.textColor = RAColors.GRAY8
            cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
            
            var policy = alertDetail?.client?.products[indexPath.row]
            cell?.textLabel?.text = policy?.type?.title
            cell?.detailTextLabel?.text = policy?.type?.subTitle
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                //selectedPolicyTitle
                if policy?.type?.title == selectedPolicyTitle {
                    cell?.detailTextLabel?.textColor = UIColor.blackColor()
                }
                else {
                    cell?.detailTextLabel?.textColor = RAColors.BLUE1
                }
            } else {
                cell?.detailTextLabel?.textColor = UIColor.blackColor()
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            cell?.detailTextLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
            

        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
//        // Defect 15376
//        
//        // disconnect PolicyDetailTableViewController and add alertView
//        var alertController = UIAlertController(title: "Function not yet available", message: nil, preferredStyle:.Alert)
//        var okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
//        alertController.addAction(okButton)
//        self.presentViewController(alertController, animated: true, completion: nil)
//        
        
        switch indexPath.section {
        case 1:
            selectedRow = indexPath.row
            var policy = alertDetail?.client?.products[indexPath.row]
            selectedPolicyTitle = policy?.type?.title
            //Reload Product Section, to make detailTextLabel as blue to show that it is selected
            //Can't reload row as there might be multiple row
            let range = NSMakeRange(1, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            self.tableView.reloadSections(sectionToReload, withRowAnimation: UITableViewRowAnimation.Automatic)
            
            var policyDetailController = UIStoryboard(name: "PolicyDetails", bundle: nil).instantiateInitialViewController() as PolicyDetailTableViewController
            
            policyDetailController.policyId = policy!.id
            
            if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) && (contactViewController != nil) {
                self.contactViewController?.showRightViewController(policyDetailController)
            } else {
                self.navigationController?.pushViewController(policyDetailController, animated: true)
            }
            break
        default:
            break
        }


        
    }
    
    // MARK: - Action Sheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch actionSheet.tag {
        case AlertDetailTableViewController.TAG_ACTION_TAKE_PHOTO:
            if buttonIndex == 1 {
                // check if camera is available
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true {
                    var imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera

                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(imagePickerController, animated: true, completion: nil)
                    })
                }
            } else if buttonIndex == 2 {
                // check if library is available
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == true {
                    var imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                    self.presentViewController(imagePickerController, animated: true, completion: nil)
                }
            }
        case AlertDetailTableViewController.TAG_ACTION_SHARE:
            // TODO: share to delegate
            return
        case AlertDetailTableViewController.TAG_ACTION_CALL_CLIENT:
            var app:UIApplication = UIApplication.sharedApplication()
            var client: ClientModel = self.alertDetail!.client!
            if buttonIndex == 1 {
                app.openURL(NSURL(string: "tel:" + client.phone)!)
            }else if buttonIndex == 2 {
                app.openURL(NSURL(string: "tel:" + client.mobile)!)
            }
            return
        default:
            // nop
            return            
        }
    }
    
    // MARK: - MessageComposeDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult){
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        println(result)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - UI action handling
    
    @IBAction func callClient(sender: AnyObject) {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            // no action on iPad
            return
        }
        //****************action sheet for multiple contacts********abhi/
        var client: ClientModel = self.alertDetail!.client!
       
        if(!client.phone.isEmpty && !client.mobile.isEmpty ){
            
            var button = sender as UIButton
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: client.phone, client.mobile)
            actionSheet.tag = AlertDetailTableViewController.TAG_ACTION_CALL_CLIENT
            actionSheet.showFromRect(sender.bounds, inView: button, animated: true)
            
        }else{
            var app:UIApplication = UIApplication.sharedApplication()
            
            if(!client.phone.isEmpty){
                
                app.openURL(NSURL(string: "tel:" + client.phone)!)
                
            }else if(!client.mobile.isEmpty){
                
                app.openURL(NSURL(string: "tel:" + client.phone)!)
            }
            
        }

    }
    
    @IBAction func emailClient(sender: AnyObject) {
        var app:UIApplication = UIApplication.sharedApplication()
        var client: ClientModel = self.alertDetail!.client!
        //app.openURL(NSURL(string: "mailto:" + client.email))
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
    
    @IBAction func textClient(sender: AnyObject) {
        
        //****************action sheet for multiple contacts********abhi/
        var client: ClientModel = self.alertDetail!.client!
        if(!client.phone.isEmpty && !client.mobile.isEmpty ){
            
            var button = sender as UIButton
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: client.phone, client.mobile)
            actionSheet.tag = ClientDetailViewController.TAG_ACTION_CALL_CLIENT
            actionSheet.showFromRect(sender.bounds, inView: button, animated: true)
            
        }else{
            var app:UIApplication = UIApplication.sharedApplication()
            
            if(MFMessageComposeViewController.canSendText()){
                // device can send Message
                var msgController = MFMessageComposeViewController()
                msgController.body = "Hello"
                if(!client.phone.isEmpty){
                    
                    msgController.recipients = [client.phone]
                    
                }else if(!client.mobile.isEmpty){
                    
                    msgController.recipients = [client.mobile]
                }
                
                msgController.messageComposeDelegate = self
                //[self presentModalViewController:controller animated:YES];
                // [self presentViewController:controller animated:YES completion:nil];
                self.presentViewController(msgController, animated: true, completion: nil)
                
            }else{
                UIAlertView(title: "", message: "Text message not supported on this device", delegate: nil, cancelButtonTitle: "OK").show()
            }
            
        }
    }


    @IBAction func submitPhoto(sender: UIButton) {
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Choose Existing")
        actionSheet.tag = AlertDetailTableViewController.TAG_ACTION_TAKE_PHOTO
        actionSheet.showInView(self.view)
    }
    
    @IBAction func share(sender: UIButton) {
        // TODO: get delegates to append as options
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Share with Kamaria Campbell", "Share with Mike Friswald", "Share with Caroline Canning")
        actionSheet.tag = AlertDetailTableViewController.TAG_ACTION_SHARE
        actionSheet.showInView(self.view)
    }
    
    @IBAction func complete(sender: UIButton) {
    }
    
    // MARK: - Navigation data params
    
    func setInputParams(params: Dictionary<String, AnyObject>) {
        if let id = params[AlertDetailTableViewController.INPUT_PARAM_ALERT_ID]! as? Int {
            self.alertId = id
        }
    }

}
