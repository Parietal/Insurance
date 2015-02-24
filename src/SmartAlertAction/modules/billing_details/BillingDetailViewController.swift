//
//  BillingDetailViewController.swift
//  SmartAlertAction
//
//  Created by cdp on 10/14/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import Foundation

class BillingDetailViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{


    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex
        {
            case 0:
                var productDetailVC = UIStoryboard(name: "ProductDetail", bundle: nil).instantiateViewControllerWithIdentifier("productDetailTV") as ProductDetailTableViewController
            
                productDetailVC.policyId = self.policyID
            
                self.navigationController?.pushViewController(productDetailVC, animated: true)
        //case 1:
            
        default:
            break; 
        }
        
    }
    
    @IBOutlet weak var billingDetailsTableView: UITableView!
    
    //custom cells
    var billingDetailCell : PolicyBillingDetailCell?
    
    var policyBillingDetail : PolicyBillingModel?
    
    var billingArray : [PolicyBillingModel] = []
    
    var policyID : Int = 0
    
    // activity indicator
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    // input params
    class var INPUT_PARAM_POLICY_ID: String { return "policyID" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;

        //load data
        self.loadData()
    }
    
    
    func loadData() {
        
        // show loading
        self.spinner.startAnimatingOnView(self.view)
        
        PolicyService.getBillingsForPolicy(self.policyID, completionHandler: { (billingDetail:[PolicyBillingModel]?, error:NSError?) -> Void in
            
            //self.policyBillingDetail = billingDetail
            
            self.billingArray = billingDetail!
            
            self.billingDetailsTableView.reloadData()
            
            // hide loading
            self.spinner.stopAnimatingOnView()
            
        })
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell: BillingHeaderCell = self.billingDetailsTableView.dequeueReusableCellWithIdentifier("billingHeaderCell") as BillingHeaderCell
        
        cell.billingDateHdr.textColor = RAColors.GRAY8
        cell.billingAmountHdr.textColor = RAColors.GRAY8
        cell.receivedDateHdr.textColor = RAColors.GRAY8
        cell.dueDateHdr.textColor = RAColors.GRAY8
        cell.paidAmountHdr.textColor = RAColors.GRAY8

        
        cell.billingDateHdr.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell.billingAmountHdr.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell.receivedDateHdr.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell.dueDateHdr.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell.paidAmountHdr.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        
        cell.billingDateHdr?.text = "Billing Date"
        cell.billingAmountHdr?.text = "Billed Amount"
        cell.receivedDateHdr?.text = "Received Date"
        cell.dueDateHdr?.text = "Due Date"
        cell.paidAmountHdr?.text = "Payment"
        
        var separatorLabel : UILabel = UILabel()
        separatorLabel.frame = CGRectMake(0, RASizes.DEFAULT_CELL_HEIGHT, self.view.frame.width, 0.5)
        separatorLabel.backgroundColor = RAColors.GRAY3
        cell.addSubview(separatorLabel)
        
        return cell
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  println("return billing array count")
        return self.billingArray.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        billingDetailsTableView.separatorColor = RAColors.GRAY3
        return RASizes.BILLING_DETAILS_HEADER_CELL_HEIGHT
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("billingDetailCell") as PolicyBillingDetailCell
        var row = indexPath.row
        
        cell.billingDate.textColor = RAColors.GRAY8
        cell.billingAmount.textColor = RAColors.GRAY8
        cell.dueDate.textColor = RAColors.GRAY8
        cell.payment.textColor = UIColor.blackColor()
        cell.receivedDate.textColor = UIColor.blackColor()
        
        cell.billingDate.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell.billingAmount.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell.dueDate.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell.payment.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
        cell.receivedDate.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
        
        //set billing date
        if let policyBillingDate = self.billingArray[row].billingDate {
            cell.billingDate.text = StringUtils.convertDateToString(policyBillingDate, format: Constants.BILL_DATE)
        }
        
//        let today:NSDate = NSDate()
//        
//        //set text of label
//        let formatter:NSDateFormatter = NSDateFormatter()
//        formatter.dateFormat = "MMM"
//        let monthLabel:String = formatter.stringFromDate(firstDayOfMonth)
        
        
        // set billed amt
        let billedAmt = self.billingArray[row].amount
        let billedAmt_string = NSString(format: "%.2f", billedAmt)
        let dollar = "$"
        cell.billingAmount.text = dollar + billedAmt_string
        
        //set due date
        if let policyDueDate = self.billingArray[row].dueDate {
            cell.dueDate.text = StringUtils.convertDateToString(policyDueDate, format: Constants.BILL_DATE)
        }
        
        var billingDate = self.billingArray[row].billingDate
        
        var today = NSDate()
        
        var dateCompare :NSComparisonResult = billingDate!.compare(today)
        
        if(dateCompare == NSComparisonResult.OrderedDescending){
            
            cell.payment.text = ""
            cell.receivedDate.text = ""
            
        }else{
            // set payment amt
            let paymentAmt = self.billingArray[row].payment
            let paymentAmt_string = NSString(format: "%.2f", paymentAmt)
            cell.payment.text = dollar + paymentAmt_string
            
            var dueDate = self.billingArray[row].dueDate!
            
            var receivedDate = self.billingArray[row].receivedDate!
            
            //set received date
            if let receivedDate = self.billingArray[row].receivedDate {
                
                cell.receivedDate.layer.masksToBounds = true
                cell.receivedDate.layer.cornerRadius = 5.0
                // cell.receivedDate.layer.frame.size.height += 20
                
                cell.receivedDate.text =  StringUtils.convertDateToString(receivedDate, format: Constants.BILL_DATE)
                var dueDate = self.billingArray[row].dueDate
                var result = receivedDate.compare(dueDate!)
            }
            var padding_str = " "
            
            // Date comparision to compare current date and end date.
            var dateComparisionResult:NSComparisonResult = dueDate.compare(receivedDate)
            
            if dateComparisionResult == NSComparisonResult.OrderedAscending
            {
                // Current date is smaller than end date.
            }
            else if dateComparisionResult == NSComparisonResult.OrderedDescending
            {
                cell.receivedDate.textColor = UIColor.whiteColor()
                cell.receivedDate.backgroundColor = RAColors.RED1
                cell.receivedDate.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
                var str_recevd = StringUtils.convertDateToString(receivedDate, format: Constants.BILL_DATE)
                cell.receivedDate.text = padding_str + padding_str + str_recevd + padding_str + padding_str
                
            }
            else if dateComparisionResult == NSComparisonResult.OrderedSame
            {
                // Current date and end date are same.
            }

        }
        
        
        return cell
    }
    
    
    
    // MARK: - Page Transition Protocol
    
    func setInputParams(params: Dictionary<String, AnyObject>) {
        // get and set client id
        if let id = params[BillingDetailViewController.INPUT_PARAM_POLICY_ID]! as? Int {
            self.policyID = id
        }
    }

    
}