//
//  MasterTableViewController.swift
//  SmartAlertAction
//
//  Created by cdp on 10/7/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class MasterTableViewController: UITableViewController,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate, UIActionSheetDelegate{
    
    class var INPUT_PARAM_CLIENT_ID: String { return "clientId" }
    
    var selectedRow = 0
    
    var selectedSection = 0
    
    var selectedScreen = ""
    
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    var selectedProduct : PolicyModel?
    
    var clientsWithDisabledAlerts = [NSManagedObject]()
    
    // ui controls
    var actionCell: UITableViewCell?
    var infoCell: UITableViewCell?
    var productCell: UITableViewCell?
    var settingsCell: UITableViewCell?
    
    // class variables
    var titleOfSections: [String] = ["PROFILE", "PRODUCTS", "ALERT SETTINGS"]
    var rowsOfSections: [Int] = [2, 0, 1]
    //  var labelsOfProfileInfo: [String] = ["Client Since", "Gender", "Age", "Birthday","Marital Status", "Annualized Premium"]
    var labelsOfProfileInfo: [String] = ["Contact Information", "Client Profile"]
    
    var showAlertTitle = "Show Alerts for this client"
    var clientDetail: ClientModel?
    var clientId: Int?
    
    var showAlertStatus: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone){
            
            let settingsImage = UIImage(named: "icon_settings") as UIImage?
            var settingsButton = UIBarButtonItem(image: settingsImage,style:
                UIBarButtonItemStyle.Plain, target: self, action: "settingsTapped:")
            self.navigationItem.rightBarButtonItem = settingsButton
        }
        
        // load client data
        self.loadData()
        
    }
    
    @IBAction func settingsTapped(sender: AnyObject) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateViewControllerWithIdentifier("AlertNotification") as UIViewController
            
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func loadData() {
        
        self.spinner.startAnimatingOnView(self.view)
        
        ClientService.getDetailsForClient(self.clientId!, completionHandler: {(client:ClientModel?, error: NSError?) -> Void in
            
            if(client != nil){
                
                // assign to client detail
                self.clientDetail = client
                
                // set navigation title & color
                //  self.navigationItem.title = client?.getFullName()
                self.navigationController?.navigationBar.tintColor = RAColors.BLUE1  // Bruce ** Color Change
                
                // reset rows number
                self.rowsOfSections[1] = client!.products.count
                
                // reload client data
                if(self.clientDetail != nil){
                    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()

                            let indexPath = NSIndexPath(forRow: self.selectedRow, inSection: self.selectedSection)
                            
                            var cell = self.tableView.cellForRowAtIndexPath(indexPath)
                            self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
                            self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath)

                        })
                    }else{
                        self.tableView.reloadData()
                    }
                }
                
            }else{
                var alertController = UIAlertController(title: "Client detail not yet available", message: nil, preferredStyle:.Alert)
                
                var action = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.pop()
                }
                
                var okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
            // hide loading
            self.spinner.stopAnimatingOnView()
            
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
//            
//           // self.loadData()
//            
//        }
        super.viewDidAppear(animated)
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            if(self.clientDetail != nil){
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    
                    let indexPath = NSIndexPath(forRow: self.selectedRow, inSection: self.selectedSection)
                    
                    var cell = self.tableView.cellForRowAtIndexPath(indexPath)
                    self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
                    self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath)
                    
                })
            }
        }
    }
    
    
    func pop(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.clientDetail == nil){
            return 0
        }
        return self.titleOfSections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowsOfSections[section]
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        self.tableView.separatorColor = RAColors.GRAY3
        if(section == 0){
            return RASizes.CLIENT_INFO_HEADER_CELL_HEIGHT
        }else{
            return RASizes.CLIENT_INFO_SECTION_HEADER_HEIGHT
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
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                    bDay += " (" + str_age! + " yrs.)"
                }else{
                    bDay += " (" + str_age! + ")"
                }
                
                
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
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                clientHdrCell?.textClientButton.hidden = true
                
                clientHdrCell?.callClientButton.hidden = true
                
                clientHdrCell?.emailClientButton.hidden = true
                
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
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                titleLabel.font = RAFonts.SMARTLISTS_CONTACT_SECTION_TITLE
            }else{
                titleLabel.font = RAFonts.SMARTLISTS_CONTACT_SECTION_TITLE_IPHONE
            }
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
        
        var section = indexPath.section
        switch section {
        case 0:
            cell = self.initProfileInfoSection(cellForRowAtIndexPath: indexPath)
        case 1:
            cell = self.initProductsSection(cellForRowAtIndexPath: indexPath)
        case 2:
            cell = self.initSettingsSection(cellForRowAtIndexPath: indexPath)
        default:
            cell = UITableViewCell()
        }
        
        /*
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.selectedBackgroundView =
        */
        
        //PHM Set selected cell highlight color
        var selectedCellView = UIView()
        selectedCellView.backgroundColor = RAColors.BLUE1
        selectedCellView.tintColor = UIColor.whiteColor()
        cell?.selectedBackgroundView = selectedCellView
        cell?.textLabel?.highlightedTextColor = UIColor.whiteColor()
        cell?.detailTextLabel?.highlightedTextColor = UIColor.whiteColor()
        
        return cell!
    }
    
    
    // basic info section
    func initProfileInfoSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        switch row {
        case 0:
            var clientSince = self.clientDetail?.clientSince
            
            cell = self.setProfileInfoCell(row, text: clientSince)
        case 1:
            cell = self.setProfileInfoCell(row, text: self.clientDetail?.gender?.title)
        case 2:
            cell = self.setProfileInfoCell(row, text: (self.clientDetail?.getAge() == nil ? "" : self.clientDetail?.getAge()?.description))
        case 3:
            var birthday:String?
            if let birthDate = self.clientDetail?.birthDate {
                birthday = StringUtils.convertDateToString(birthDate, format: Constants.BIRTHDAY_FORMAT)
            }
            cell = self.setProfileInfoCell(row, text: birthday)
        case 4:
            var maritalStatus = self.clientDetail?.maritalStatus?.title
            
            cell = self.setProfileInfoCell(row, text: maritalStatus)
        case 5:
            var annualPremium = self.clientDetail?.annualizedPremium?.value
            cell = self.setProfileInfoCell(row, text: annualPremium)
        default:
            cell = UITableViewCell()
        }
        
        return cell!
    }
    
    func setProfileInfoCell(index: Int, text: String?) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("clientDetailCell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "clientDetailCell")
        }
        cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell?.textLabel?.text = self.labelsOfProfileInfo[index]
        
        // cell?.detailTextLabel?.text = text
        cell?.textLabel?.textColor = RAColors.GRAY8
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        //cell?.detailTextLabel?.textColor = UIColor.blackColor()
        return cell!
    }
    
    // products section
    func initProductsSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        var product: PolicyModel? = self.clientDetail?.products[row]
        cell = self.setProductCell(row, title: product?.type?.title, detail: product?.type?.subTitle)
        
        return cell!
    }
    
    func setProductCell(index: Int, title: String?, detail: String?) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("profileDetailCell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "profileDetailCell")
        }
        
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            cell?.textLabel?.text = title
            cell?.detailTextLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
            cell?.detailTextLabel?.textColor = UIColor.blackColor()
            cell?.detailTextLabel?.text = detail
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textLabel?.text = detail
            cell?.detailTextLabel?.text = ""
        }
        
        
        cell?.textLabel?.textColor = RAColors.GRAY8
        cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        
        return cell!
    }
    
    
    // settings section
    func initSettingsSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        var showAlert: Bool? = self.clientDetail?.settings?.showAlert
        cell = self.setSettingsCell(row, title: self.showAlertTitle, switchOn: showAlertStatus)
        //PHM don't highlight alert setting toggle cell
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
    func setSettingsCell(index: Int, title: String?, switchOn: Bool?) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("settingsCell") as ClientDetailSettingsTableViewCell
        cell.settingsLabel.text = title
        cell.settingsLabel.textColor = RAColors.GRAY8
        cell.settingsLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        if let on = switchOn {
            cell.settingsSwitch.setOn(on, animated: true)
        }
        
        return cell
    }
    
    //MARK: UITableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedRow = indexPath.row
        self.selectedSection = indexPath.section
        
        switch(indexPath.section){
        case 0:
            //*******************//
            if(indexPath.row == 0){
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                    // set client id
                    var clientDetailController = (UIStoryboard(name: "ClientDetailView", bundle: nil).instantiateInitialViewController() as UINavigationController).viewControllers[0] as ClientDetailViewController
                    //clientDetailController.clientDetail = clientDetail
                    clientDetailController.clientId = self.clientId!
                    self.navigationController?.splitViewController?.showDetailViewController(clientDetailController.navigationController, sender: nil)
                }else{
                    var clientInfoVC = UIStoryboard(name: "ClientInfoViewIphone", bundle: nil).instantiateViewControllerWithIdentifier("clientInformation") as ClientInfoIphoneTableVC
                    clientInfoVC.clientId = self.clientId!
                    self.navigationController?.pushViewController(clientInfoVC, animated: true)
                }
                
                
            }else if(indexPath.row == 1){
                
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                    
                    var clientProfileIpad = (UIStoryboard(name: "ClientProfileIpadView", bundle: nil).instantiateInitialViewController() as UINavigationController).viewControllers[0] as ClientProfileIpadTableVC
                    
                    clientProfileIpad.clientId = self.clientId!
                    
                    self.navigationController?.splitViewController?.showDetailViewController(clientProfileIpad.navigationController, sender: nil)
                    
                }else{
                    var masterDetailController = UIStoryboard(name: "ClientProfileInfo", bundle: nil).instantiateViewControllerWithIdentifier("profileInfo") as ClientProfileTableViewController
                    masterDetailController.clientId = self.clientId!
                    self.navigationController?.pushViewController(masterDetailController, animated: true)
                }
            }
            //********************//
            break
        case 1:
            self.selectedProduct = self.clientDetail?.products[indexPath.row]
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                
                
                var productContainerViewController = (UIStoryboard(name: "PolicyBillingDetails", bundle: nil).instantiateInitialViewController() as UINavigationController).viewControllers[0] as ProductContainerViewController
                
                productContainerViewController.policyID = self.selectedProduct!.id
                productContainerViewController.policyName = self.selectedProduct!.type?.subTitle
                
                self.navigationController?.splitViewController?.showDetailViewController(productContainerViewController.navigationController, sender: nil)
                
                
            }else{
                self.selectedProduct = self.clientDetail?.products[indexPath.row]
                
                var productDetailVC = UIStoryboard(name: "ProductDetail", bundle: nil).instantiateViewControllerWithIdentifier("productDetailTV") as ProductDetailTableViewController
                
                productDetailVC.policyId = self.selectedProduct!.id
                
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
            break
        case 3:
            break
        default:
            break
        }
        
        //        // Set selected cell highlight color
        //        var cell = self.tableView.cellForRowAtIndexPath(indexPath)
        //        var selectedCellView = UIView()
        //        selectedCellView.backgroundColor = RAColors.BLUE1
        //        selectedCellView.tintColor = UIColor.whiteColor()
        //        cell?.selectedBackgroundView = selectedCellView
        //        cell?.textLabel.highlightedTextColor = UIColor.whiteColor()
        //        cell?.detailTextLabel?.highlightedTextColor = UIColor.whiteColor()
    }
    
    //MARK: -
    
    @IBAction func textClient(sender: AnyObject) {
        
        //****************action sheet for multiple contacts********abhi/
        var client: ClientModel = self.clientDetail!
        if(!client.phone.isEmpty && !client.mobile.isEmpty ){
            
            var button = sender as UIButton
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: client.phone, client.mobile)
            actionSheet.tag = ClientDetailViewController.TAG_ACTION_TEXT_CLIENT
            actionSheet.showFromRect(sender.bounds, inView: button, animated: true)
            
        }else{
            
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
        
    }
    
    // method to implement for MessageComposeDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult){
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
       // println(result)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func callClientTapped(sender: AnyObject) {
        //****************action sheet for multiple contacts********abhi/
        var client: ClientModel = self.clientDetail!
        
        if(!client.phone.isEmpty && !client.mobile.isEmpty){
            
            var button = sender as UIButton
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: client.phone, client.mobile)
            actionSheet.tag = AlertDetailTableViewController.TAG_ACTION_CALL_CLIENT
            actionSheet.showFromRect(sender.bounds, inView: button, animated: true)
            
        }else{
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                // no action on iPad
                return
            }else{
                var client: ClientModel = self.clientDetail!
                var str_number = ""
                
                if(!client.phone.isEmpty){
                    
                    str_number = client.phone
                    
                }else if(!client.mobile.isEmpty){
                    
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
    }
    
    @IBAction func emailClientTapped(sender: AnyObject) {
        var app:UIApplication = UIApplication.sharedApplication()
        var client: ClientModel = self.clientDetail!
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
    
    
    @IBAction func alertSwitchToggled(sender: AnyObject){
        
        let showAlertSwitch =  sender as UISwitch
        
        if showAlertSwitch.on{
            
            var recExists = fetchAlertStatus(clientId!, showAlert: true)
            
            if(recExists == -1){
                saveAlertStatus(true)
            }
            
        }else{
            var recExists = fetchAlertStatus(clientId!, showAlert: false)
            
            if(recExists == -1){
                saveAlertStatus(false)
            }
        }
        
    }
    
    
    func saveAlertStatus(alertStatus: Bool){
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity = NSEntityDescription.entityForName("ClientAlerts", inManagedObjectContext: managedContext)
        
        let showAlertObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //  showAlertObject.showAlerts = NSNumber(bool: alertStatus)
        
        var id = Int(self.clientId!)
        
        //3
        showAlertObject.setValue(id, forKey: "id")
        
        var status: NSNumber = alertStatus
        
        showAlertObject.setValue(status, forKey: "showAlerts")
        
        //4
        var error: NSError?
        
        if(!managedContext.save(&error)){
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    
    // MARK: - Action Sheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch actionSheet.tag {
        case ClientDetailViewController.TAG_ACTION_CALL_CLIENT:
            var app:UIApplication = UIApplication.sharedApplication()
            var client: ClientModel = self.clientDetail!
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                // no action on iPad
                return
            }else{
                var client: ClientModel = self.clientDetail!
                var str_number = ""
                
                if buttonIndex == 1 {
                    
                    str_number = client.phone
                    
                }else if buttonIndex == 2 {
                    
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
            
            return
        case ClientDetailViewController.TAG_ACTION_TEXT_CLIENT:
            
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
            
            return
        default:
            // nop
            return
        }
    }
    
    
    func setInputParams(params: Dictionary<String, AnyObject>) {
        if let id = params[MasterTableViewController.INPUT_PARAM_CLIENT_ID]! as? Int {
            self.clientId = id
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            
            let noClinetNavVc = UIStoryboard(name: "Clients", bundle: nil).instantiateViewControllerWithIdentifier(Constants.NOCLIENT_NAVVC) as UINavigationController
            self.navigationController?.splitViewController?.showDetailViewController(noClinetNavVc, sender: nil)
        }
        
        
        
    }
    
    func fetchAlertStatus(clientId: Int,showAlert: Bool)-> Int{
        
        var showAlertsDisabled = -1
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchReq = NSFetchRequest(entityName: "ClientAlerts")
        
        //3
        var error : NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchReq, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            clientsWithDisabledAlerts = results
            
            for index in 0..<clientsWithDisabledAlerts.count{
                var client: NSManagedObject = self.clientsWithDisabledAlerts[index]
                let id : Int = client.valueForKey("id") as Int
               
                if(self.clientId == id){
                    showAlertsDisabled = 1
                    //  let status = client.valueForKey("showAlerts") as NSNumber
                    
                    client.setValue(showAlert, forKey: "showAlerts")
                    
                    managedContext.save(&error)
                    
                }
            }
            
            
        }else{
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        return showAlertsDisabled
        
    }
    
    
}
