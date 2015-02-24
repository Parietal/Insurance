//
//  PaymentViewController.swift
//  SmartAlertAction
//
//  Created by Saurav on 22/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,  UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {

    var clientDetail: ClientModel?
    var clientId: Int = 0
    
    var currentTextField : UITextField?   // tracks the selected textField
    var cardholderName : String = ""
    
    var paymentAmountDictionary: [String:String] = [:]
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    var amountKeyArray = ["Amount Due","Remaining Balance"]
    
    var cardKeyArray = [String]()
    var popUpPickerView = UIPickerView()
    var popUpView = UIView()
    var timePopUpView = UIView()
    var timeControl:UITextField!

    @IBOutlet weak var lineView: UIView!
    
    // Used for new UIPicker view for credit card expiration date
    lazy var cardTypeArray: [String] =  {
        
        // enumerate the enum to populate the array
        var types = [String]()
        for type in Constants.PaymentTypes.allValues {
            types.append(type.rawValue)
        }
        return types
    }()
    lazy var monthsArray: [String] = {
        
        // enumerate the enum to populate the array
        var months = [String]()
        for month in Constants.MonthNames.allValues {
            months.append(month.rawValue)
        }
        return months
        
    }()
    lazy var numericalMonthsArray: [String] = {
        
        // enumerate the enum to populate the array
        var months = [String]()
        for month in Constants.MonthNames.allValues {
            months.append(Constants.MonthNames.numericalValue(month))
        }
        return months
    }()
    
    lazy var yearsArray: [String] = {
        
        let currentYear = StringUtils.convertDateToString(NSDate(), format:Constants.YEAR_DATE)
        let currentYearInt = currentYear.toInt()
        
        var years = [String]()
        for var i = currentYearInt!;i < currentYearInt! + 11; i++ {
            
            years.append("\(i)")
        }
        
        return years
    }()
    let currentYear = StringUtils.convertDateToString(NSDate(), format: Constants.YEAR_DATE)
    let currentMonth = StringUtils.convertDateToString(NSDate(), format: Constants.MONTH_2DIGIT_DATE)
    var yearPicked = ""
    var monthPicked = ""

    @IBOutlet weak var paymentAmountTableView: UITableView!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var paymentInfoTableView: UITableView!
    @IBOutlet weak var submitButton: UIBarButtonItem!  // needed for iPhone only
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.preferredContentSize.height = 445
        self.preferredContentSize = preferredContentSize
        
        paymentInfoTableView.tableFooterView?.hidden = true
        paymentInfoTableView.tableFooterView = UIView(frame: CGRectZero)

        paymentAmountTableView.separatorColor = RAColors.GRAY3
        paymentInfoTableView.separatorColor = RAColors.GRAY3
        
        // set the month/year
        yearPicked = currentYear
        monthPicked = currentMonth
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func loadData() {
        
        self.spinner.startAnimatingOnView(self.view)

        ClientService.getDetailsForClient(self.clientId, completionHandler: {(client:ClientModel?, error: NSError?) -> Void in
            
            // assign to client detail
            self.clientDetail = client
            
            //currentcy formatter
            var formatter:NSNumberFormatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            
            //Checking if value is 0 then don't show Currency and value, show Empty string
            self.paymentAmountDictionary = [
                self.amountKeyArray[0]:self.clientDetail!.account!.amountDue == 0 ? "" : String(formatter.stringFromNumber(self.clientDetail!.account!.amountDue)!),
                self.amountKeyArray[1]:self.clientDetail!.account!.remainingBalance == 0 ? "" : String(formatter.stringFromNumber(self.clientDetail!.account!.remainingBalance)!)]
            
            self.paymentAmountTableView.reloadData()
            
            // hide loading
            self.spinner.stopAnimatingOnView()
        })
    }
    
    
    @IBAction func cancelBtnTapped(sender: AnyObject) {
        pickerCancelSelected()
        
        // hide the keyboard before dismissing self
        if currentTextField != nil {
            
            currentTextField?.resignFirstResponder()
            
            TimeUtils.PerformAfterDelay(0.4, completionHandler: { () -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func submitBtnTapped(sender: AnyObject) {
        
        pickerCancelSelected()

        var paymentAmount : String
        
        // Check that a payment has been selected, at least payment should have "checkBox_ON"
        let amountDueCell = paymentAmountTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as PaymentAmountTableViewCell
        let remainingBalanceCell = paymentAmountTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as PaymentAmountTableViewCell
        
        if amountDueCell.button.imageForState(UIControlState.Normal) == UIImage(named: "checkBox_OFF") && remainingBalanceCell.button.imageForState(UIControlState.Normal) == UIImage(named: "checkBox_OFF") {
            
            let alertController = UIAlertController(title: nil, message: "Please select a payment amount.", preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil)
            alertController.addAction(okButton)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        else {   // at least one of the payments is selected, get the payment amount
            
            if amountDueCell.button.imageForState(UIControlState.Normal) == UIImage(named: "checkBox_ON") {
                
                paymentAmount  = amountDueCell.subTitle.text!
            }
            else {  // remaining is selected
                paymentAmount = remainingBalanceCell.subTitle.text!
            }
        }
        
        if typeButton.titleForState(UIControlState.Normal) == "Select One" {
        
            UIAlertView(title: "", message: "Please select payment option.", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        //Do Validation of TextField
        for (index,value) in enumerate(cardKeyArray) {
            
            if value == "Client provide consent" {
            
                let cell = paymentInfoTableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as ClientConsentTableViewCell
                if  cell.consentSwitch.on == false {
                    
                    let alertController = UIAlertController(title: nil, message: "Please receive consent from client.", preferredStyle: UIAlertControllerStyle.Alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil)
                    alertController.addAction(okButton)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
            }
            else {
            
                let cell = paymentInfoTableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as PaymentInfoTableViewCell
                if cell.valueTextField.text.isEmpty {
                    UIAlertView(title: "", message: "Please enter all fields", delegate: nil, cancelButtonTitle: "OK").show()
                    return
                }
            }

        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        UIAlertView(title: "Payment sent successfully", message: "Your payment for \(paymentAmount) has been processed.", delegate: nil, cancelButtonTitle: "OK").show()


    }
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == paymentAmountTableView {
            return paymentAmountDictionary.count

        }
        else {
            return cardKeyArray.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        if tableView == paymentAmountTableView {
            cell = self.initPaymentAmountTableViewSection(cellForRowAtIndexPath: indexPath)

            return cell!
        }
        
        else if tableView == paymentInfoTableView {
            cell = self.initPaymentInfoTableViewSection(cellForRowAtIndexPath: indexPath)
            return cell!
        }
        return cell!
    }
    
    // Payment Amount TableView
    func initPaymentAmountTableViewSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        cell = self.setPaymentAmountCell(indexPath.row)
        return cell!
    }
    
    // set each cell according to its type
    
    func setPaymentAmountCell(row:Int) -> UITableViewCell {
        var cell = paymentAmountTableView.dequeueReusableCellWithIdentifier("paymentCell") as PaymentAmountTableViewCell
        cell.title.text = amountKeyArray[row]
        cell.subTitle.text = paymentAmountDictionary[amountKeyArray[row]]
        cell.button.tag = row
        return cell
    }
    //MARK: - UITableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var cells:[PaymentAmountTableViewCell] = tableView.visibleCells() as [PaymentAmountTableViewCell]
        for cell:PaymentAmountTableViewCell in cells {
            cell.setSelected(false, animated: true)
        }
        
        var cell:PaymentAmountTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as PaymentAmountTableViewCell
        cell.setSelected(true, animated: true)
    }
    
    // Payment info section
    func initPaymentInfoTableViewSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        switch row {

            //If it is last Row show Consent TableView Cell
        case cardKeyArray.count - 1:
            cell
                = self.setConsentCell(cardKeyArray[row])

        default:
            cell = self.setPaymentInfoCell(cardKeyArray[row], placeHolder: "Required", tag: indexPath.row)
        }
        
        return cell!
    }
    
    // set each cell according to its type
    
    func setPaymentInfoCell(title:String,placeHolder:String,tag:Int) -> UITableViewCell {
        var cell = paymentInfoTableView.dequeueReusableCellWithIdentifier("paymentTVc") as PaymentInfoTableViewCell
        cell.title.text = title
        cell.valueTextField.text = ""
        cell.valueTextField.placeholder = placeHolder
        cell.valueTextField.tag = tag
        cell.valueTextField.delegate = self

        if title == "Expiration Date" {
            timePopUpView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height.0, UIScreen.mainScreen().bounds.size.width, 260)
            
            var popUpBar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
            popUpBar.barStyle=UIBarStyle.Default
            popUpBar.translucent=true
            
            var barItems=NSMutableArray()
            
    
            var flexSpace=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
            barItems.addObject(flexSpace)
            
            
            var titleDone=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("timePickerDoneSelected"))
            barItems.addObject(titleDone)
            
            // Used for credit card expiration date
            var datePicker = UIPickerView()
            datePicker.delegate = self;
            datePicker.frame = CGRectMake(0, 44, UIScreen.mainScreen().bounds.size.width, 216)
            datePicker.showsSelectionIndicator=true
            datePicker.backgroundColor = UIColor.whiteColor()
            datePicker.tag = 2
            
            // set the picker wheels to current month/year
            datePicker.selectRow(find(numericalMonthsArray, monthPicked)!, inComponent: 0, animated: false)
            datePicker.selectRow(find(yearsArray, yearPicked)!, inComponent: 1, animated: false)

            popUpBar.setItems(barItems, animated: true)
            timePopUpView.addSubview(popUpBar)
            timePopUpView.addSubview(datePicker)
            
            cell.valueTextField.inputView = timePopUpView
            cell.valueTextField.delegate = self
            cell.valueTextField.placeholder = "MM/YYYY"
            timeControl = cell.valueTextField

        }
        else {
            cell.valueTextField.keyboardType = CommonFunc.getKeyBoardType(title)
            cell.valueTextField.autocapitalizationType = CommonFunc.getKeyboardAutocapitalizationType(title)
            cell.valueTextField.returnKeyType = CommonFunc.getKeyBoardReturnKeyType(title)
            cell.valueTextField.enablesReturnKeyAutomatically = true
            cell.valueTextField.autocorrectionType = .No
            
            if cell.valueTextField.keyboardType == UIKeyboardType.NumberPad && UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                cell.valueTextField.inputAccessoryView = self.createInputAccessoryView(tag)
            }
        }
        
        return cell
    }
    
    func setConsentCell(title:String) -> UITableViewCell {
        var cell = paymentInfoTableView.dequeueReusableCellWithIdentifier("consentTVc") as ClientConsentTableViewCell
        cell.consentLabel.text = title
        
        return cell
    }
    //MARK: - Action
    
    @IBAction func typeBtnTapped(sender: AnyObject) {
        
        getPickerView()
    }
    
    //MARK: - 
    
    func getPickerView() {
        
        popUpPickerView.backgroundColor = UIColor.whiteColor()
        popUpView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height.0, UIScreen.mainScreen().bounds.size.width, 260)
        
        popUpPickerView.frame = CGRectMake(0, 44, UIScreen.mainScreen().bounds.size.width, 216)
        
        popUpPickerView.showsSelectionIndicator=true
        popUpPickerView.delegate = self
        
        // added to differentiate between creditcard expiration date pickerView
        popUpPickerView.tag = 1

        var popUpBar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        popUpBar.barStyle=UIBarStyle.Default
        popUpBar.translucent=true
        
        var barItems=NSMutableArray()
        
        var fixedSpace=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
        fixedSpace.width = 10
        barItems.addObject(fixedSpace)
        
        var flexSpace=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barItems.addObject(flexSpace)
        
        
        var titleDone=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("pickerDoneSelected"))
        barItems.addObject(titleDone)
        barItems.addObject(fixedSpace)

        
        popUpBar.setItems(barItems, animated: true)
        popUpView.addSubview(popUpBar)
        popUpView.addSubview(popUpPickerView)
    
        var window = UIApplication.sharedApplication().delegate?.window!
        window!.addSubview(popUpView)
        
        if  currentTextField != nil {
            currentTextField?.resignFirstResponder()
            currentTextField = nil
        }
        
        UIView.animateWithDuration(0.4, animations: {
            
            self.popUpView.frame=CGRectMake(0, UIScreen.mainScreen().bounds.size.height-260, UIScreen.mainScreen().bounds.size.width, 260)
        })
        
    }
    
    
    func pickerCancelSelected(){
        
        UIView.animateWithDuration(0.4, animations: {
            
            self.popUpView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.popUpView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
        
    }

    
    func pickerDoneSelected(){
        
        typeButton.setTitle(cardTypeArray[popUpPickerView.selectedRowInComponent(0)], forState: UIControlState.Normal)
        typeButton.setTitleColor(RAColors.BLUE1, forState: UIControlState.Normal)
        lineView.hidden = false
        
        if popUpPickerView.selectedRowInComponent(0) == 4 {
            
            cardKeyArray = ["Routing Number","Account Number","Client provide consent"]
            self.paymentInfoTableView.reloadData()
        }
        else {
            cardKeyArray = ["Cardholder Name","Card Number","Security Code","Expiration Date","Client provide consent"]
            self.paymentInfoTableView.reloadData()
        }
        
        
        UIView.animateWithDuration(0.4, animations: {
            
            self.popUpView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.popUpView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func timePickerDoneSelected(){
        self.timeControl.resignFirstResponder()
    }
    
    //MARK: UIPickerView Data Source
    
    // Changes for new UIPickerView credit card expiration date
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        // credit card picker
        if pickerView.tag == 1 {
            return 1
        }
        // monthDate picker
        else {
            return 2
        }
    }

    // Changes for new UIPickerView credit card expiration date
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        

        // credit card picker
        if  pickerView.tag == 1 {
            
            return cardTypeArray.count

        }
        // monthDate picker
        else {
            
            if component == 0 {
                
                return monthsArray.count
            }
            else {
                return yearsArray.count
            }
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if  pickerView.tag == 2 {
        
            if  component == 0 {
                monthPicked = numericalMonthsArray[row]
            }
            else {
                yearPicked = yearsArray[row]
            }

            // validate the selected month/year
            if self.validateMonthAndYear(monthPicked, year: yearPicked) == false {  // month is greater than current month
                monthPicked = currentMonth   // set selected month to current month
                pickerView.selectRow(find(numericalMonthsArray, currentMonth)!, inComponent: 0, animated: true)
            }
            self.expirationDateChanged()

        }

    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView{
        
        var label = UILabel(frame: self.view.frame)
        label.textAlignment = NSTextAlignment.Center
        label.font = RAFonts.DELEGATE_CELL_AGENTNAMEBUTTON
        
        if  pickerView.tag == 1 {
            label.text = cardTypeArray[row]
        }
        else {
            if component == 0 {
                label.text = monthsArray[row]
            }
            else {
                label.text = yearsArray[row]
            }
        }
        return label
    }
    // Changes for new UIPickerView credit card expiration date
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        
//        if  pickerView.tag == 1 {
//            return cardTypeArray[row]
//        }
//        else {
//            if component == 0 {
//                return monthsArray[row]
//            }
//            else {
//                return yearsArray[row]
//            }
//        }
//    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    
        if pickerView.tag == 1 {  // Payment Type
            
            return 200
        }
        else {  // Expiration Date
            return 140
        }
    }
    
    // Changes for new UIPickerView credit card expiration date

    func expirationDateChanged() {

        let cell = paymentInfoTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as PaymentInfoTableViewCell
        cell.valueTextField.text = monthPicked + "/" + yearPicked

    }
    func validateMonthAndYear (month: String, year: String) -> Bool {
        
        let currentYearInt = currentYear.toInt()
        let currentMonthInt = currentMonth.toInt()
        
        let selectedYearInt = year.toInt()
        let selectedMonthInt = month.toInt()
        
        if selectedMonthInt >= currentMonthInt {
            
            return true
        }
        else {
            
            if selectedYearInt > currentYearInt {
                return true
            }
            else {
                return false
            }
        }
    }
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.paymentInfoTableView.scrollEnabled = false
    }

    //MARK: - UITextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.pickerCancelSelected()
        
        currentTextField = textField
        
        if textField.tag == 3 && textField.text == "" {
            
            textField.text = self.monthPicked + "/" + self.yearPicked
        }
        else if textField.tag == 2 && UIDevice.currentDevice().userInterfaceIdiom == .Phone {  // move the tableView up
            
            var contentInsets = UIEdgeInsetsMake(0.0, 0.0, 200, 0.0)
            self.paymentInfoTableView.scrollEnabled = true
            self.paymentInfoTableView.contentInset = contentInsets
        }
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if typeButton.titleForState(UIControlState.Normal) == "Bank Account" {
            switch textField.tag {
            default:
                return CommonFunc.isDigit(string)
            }
        }
        else {
            switch textField.tag {
            case 0:
                return CommonFunc.isAlphabetExtra(string)
            case 1:
                return CommonFunc.isDigit(string)
            case 2:
                return CommonFunc.isDigit(string)
            default:
                return true
            }
        }

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        
        if let payType = Constants.PaymentTypes(rawValue: typeButton.titleLabel!.text!) {
            
            if payType == Constants.PaymentTypes.Bank_Account {
                
                textField.resignFirstResponder()
                return
            }
        }
        if textField.tag == 0 && UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            // temporarily store the cardHolder name - will be lost when the row disappears
            cardholderName = textField.text
        }
            
        else if textField.tag == 2 && UIDevice.currentDevice().userInterfaceIdiom == .Phone {  // move the tableView dowbn
            
            UIView.animateWithDuration(0.4, animations: {() -> Void in
                
                self.paymentInfoTableView.contentInset = UIEdgeInsetsZero
                self.paymentInfoTableView.scrollEnabled = false
                
            })
            
            // restore the cardHolder name - lost when the row disappeared
            let cell = self.paymentInfoTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as PaymentInfoTableViewCell
            cell.valueTextField.text = cardholderName
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if let payType = Constants.PaymentTypes(rawValue: typeButton.titleLabel!.text!) {
            
            if payType == Constants.PaymentTypes.Bank_Account {
                
                textField.resignFirstResponder()
                return true
            }
        }
        if let text = textField.text {
            
            if textField.tag == 1 {
                
                if let payType = Constants.PaymentTypes(rawValue: typeButton.titleLabel!.text!) {
                    if payType != Constants.PaymentTypes.Bank_Account {
                        if self.verifyCreditCard(payType, cardNumberType: Constants.PaymentNumberType.CardNumber, countOfDigits: countElements(text)) == true {
                            textField.resignFirstResponder()
                        }
                    }
                }
            }
            else if currentTextField?.tag == 2 {
                
                if let payType = Constants.PaymentTypes(rawValue: typeButton.titleLabel!.text!) {
                    if payType != Constants.PaymentTypes.Bank_Account {
                        if self.verifyCreditCard(payType, cardNumberType: Constants.PaymentNumberType.SecurityCode, countOfDigits: countElements(text)) == true {
                            textField.resignFirstResponder()
                        }
                    }
                }
            }
            else {
                textField.resignFirstResponder()
            }
        }
        currentTextField = nil
        return true
    }
    //MARK: - UIKeyboardWillHide Notification function
    func keyboardDidHide(notif: NSNotification) {

        if let text = currentTextField?.text {
            
            if currentTextField?.tag == 1 {
                
                if let payType = Constants.PaymentTypes(rawValue: typeButton.titleLabel!.text!) {
                    if payType != Constants.PaymentTypes.Bank_Account {
                        if self.verifyCreditCard(payType, cardNumberType: Constants.PaymentNumberType.CardNumber, countOfDigits: countElements(text)) == true {
                            currentTextField = nil
                        }
                    }
                }
                
            }
            else if currentTextField?.tag == 2 {
                
                if let payType = Constants.PaymentTypes(rawValue: typeButton.titleLabel!.text!) {
                    if payType != Constants.PaymentTypes.Bank_Account {
                        if self.verifyCreditCard(payType, cardNumberType: Constants.PaymentNumberType.SecurityCode, countOfDigits: countElements(text)) == true {
                            currentTextField = nil
                        }
                    }
                }
            }
        }
    }
    func verifyCreditCard(cardType : Constants.PaymentTypes, cardNumberType: Constants.PaymentNumberType, countOfDigits: Int) -> Bool{
        
        if  cardType == Constants.PaymentTypes.American_Express {
            if cardNumberType == Constants.PaymentNumberType.CardNumber {
                if  countOfDigits != Constants.AMEX_CREDIT_NUMBER_CARD_DIGITS {
                    self.firePaymentInfoAlertController("American Express Card Number requires \(Constants.AMEX_CREDIT_NUMBER_CARD_DIGITS) digits.")
                    
                    return false
                }
            }
            else {
                if  countOfDigits != Constants.AMEX_CREDIT_NUMBER_SECURITY_DIGITS {
                    self.firePaymentInfoAlertController("America Express Security Code requires \(Constants.AMEX_CREDIT_NUMBER_SECURITY_DIGITS) digits.")
                    
                    return false
                }
            }
        }
        else { // Visa/MasterCard/Discover
            if cardNumberType == Constants.PaymentNumberType.CardNumber {
                if  countOfDigits != Constants.OTHER_CREDIT_NUMBER_CARD_DIGITS {
                    self.firePaymentInfoAlertController("\(cardType.rawValue) Card Number requires \(Constants.OTHER_CREDIT_NUMBER_CARD_DIGITS) digits.")
                    
                    return false
                }
            }
            else {
                if  countOfDigits != Constants.OTHER_CREDIT_NUMBER_SECURITY_DIGITS {
                    self.firePaymentInfoAlertController("\(cardType.rawValue) Security Code requires \(Constants.OTHER_CREDIT_NUMBER_SECURITY_DIGITS) digits.")
                    
                    return false
                }
            }
        }
        return true
    }
    
    func firePaymentInfoAlertController(message: String) {
        
        let alertController = UIAlertController(title: "Invalid Entry", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler:{(action: UIAlertAction!) in
            
            if (self.presentedViewController?.isMemberOfClass(UIAlertAction) != nil) {
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        })
        
        alertController.addAction(okButton)
        self.presentViewController(alertController, animated: true, completion: nil);
    }
    
    //MARK: - Numberpad inputAccessoryView functions
    func createInputAccessoryView(tag: Int) -> UIToolbar {
        
        var toolbar = UIToolbar(frame: CGRectZero)
        var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissNubmerPad:")
        doneButton.tag = tag
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbar.items = [flexibleSpace,doneButton]
        
        toolbar.userInteractionEnabled = true
        
        toolbar.sizeToFit()
        
        return toolbar
        
    }
    func dismissNubmerPad(sender: UIBarButtonItem) {
        
        
        var numberField = UITextField()
        
        switch sender.tag {
        
        case 0:
            let cell = paymentInfoTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as PaymentInfoTableViewCell
            numberField = cell.valueTextField
            break
        case 1:
            let cell = paymentInfoTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as PaymentInfoTableViewCell
            numberField = cell.valueTextField
            break
        case 2:
            let cell = paymentInfoTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as PaymentInfoTableViewCell
            numberField = cell.valueTextField
            break
        default:
            break
        }

        //println("Toolbar tag: \(sender.tag)")
        
        if let text = numberField.text {
            if let payType = Constants.PaymentTypes(rawValue: typeButton.titleLabel!.text!) {
                
                if payType == Constants.PaymentTypes.Bank_Account {
                    
                    numberField.resignFirstResponder()
                    return
                }
                
                switch sender.tag {
                
                case 0:
                    if self.verifyCreditCard(payType, cardNumberType: Constants.PaymentNumberType.CardNumber, countOfDigits: countElements(text)) == true {
                        numberField.resignFirstResponder()
                    }
                    break
                case 1:
                    if self.verifyCreditCard(payType, cardNumberType: Constants.PaymentNumberType.CardNumber, countOfDigits: countElements(text)) == true {
                        numberField.resignFirstResponder()
                    }
                    break
                case 2:
                    if self.verifyCreditCard(payType, cardNumberType: Constants.PaymentNumberType.SecurityCode, countOfDigits: countElements(text)) == true {
                        numberField.resignFirstResponder()
                    }
                    break
                default:
                    break
                }
            }
        }
    }
}
