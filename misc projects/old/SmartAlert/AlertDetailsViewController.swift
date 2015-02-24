//
//  AlertDetailsViewController.swift
//  SmartAlert
//
//  Created by Paul Yuan on 2014-08-11.
//  Copyright (c) 2014 Paul Yuan. All rights reserved.
//

import Foundation
import UIKit

class AlertDetailsViewController:UIViewController
{
    
    @IBOutlet var clientLabel:UILabel?
    @IBOutlet var messageTextView:UITextView?
    @IBOutlet var policyLabel:UILabel?
    @IBOutlet var actionsTextView:UITextView?
    @IBOutlet var dateLabel:UILabel?
    
    var selectedAlertId:String = Constants.DEFAULT_ALERT_ID()
    var selectedAlert:AlertDetailsModel?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedAlert = DataUtils.getAlertDetails(self.selectedAlertId)
        self.title = self.selectedAlert?.title
        self.clientLabel?.text = self.selectedAlert!.client + " (" + self.selectedAlert!.age.description + " yrs)"
        self.messageTextView?.text = self.selectedAlert?.message
        self.policyLabel?.text = self.selectedAlert?.policy
        self.actionsTextView?.text = self.selectedAlert?.recommendedActions
        self.dateLabel?.text = self.selectedAlert?.date
    }
    
    @IBAction func callClient() {
        var app:UIApplication = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "tel:" + self.selectedAlert!.phone))
    }
    
}