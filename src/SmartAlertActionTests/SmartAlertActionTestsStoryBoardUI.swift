//
//  SmartAlertActionTestsStoryBoardUI.swift
//  SmartAlertAction
//
//  Created by Sunny on 02/01/15.
//  Copyright (c) 2015 IBM Corporation. All rights reserved.
//

import UIKit
import XCTest

class SmartAlertActionTestsStoryBoardUI: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    
    
    func testStoryBoard(){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("MainVC") as MainViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        
    }
    
    func testAddPhotosConfirmStoryBoard(){
        let storyboard = UIStoryboard(name: "AddPhotosConfirm", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("AddPhotosVC") as AddPhotosConfirmVC
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        XCTAssertNotNil(vc.imageView, "imageView cannot be nil")
        
    }
    
    func testAddPhotoOptionsStoryBoard(){
        let storyboard = UIStoryboard(name: "AddPhotoOptions", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("AddPhotoOptionsVC") as AddPhotoOptionsViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        
    }
    
    func testAllAgentsStoryBoard(){
        let storyboard = UIStoryboard(name: "AllAgents", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("AllAgentsVC") as AllAgentsViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        XCTAssertNotNil(vc.tableView, "table view cannot be nil")
        
    }
    
    func testAlertDetailsStoryBoard(){
        let storyboard = UIStoryboard(name: "AlertDetails", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("AlertDetailsVC") as AlertDetailTableViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        XCTAssertNotNil(vc.clientNameLabel, "Client name label cannot be nil")
        XCTAssertNotNil(vc.clientInfoLabel, "Client info label cannot be nil")
        XCTAssertNotNil(vc.tableView, "tableView cannot be nil")
        
    }
    
    func testAlertNotificationsStoryBoard(){
        let storyboard = UIStoryboard(name: "AlertNotifications", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("AlertNotificationsVC") as AlertNotificationTableViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        
    }
    
    
    func testApplicationsStoryBoard(){
        let storyboard = UIStoryboard(name: "Applications", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("ApplicationsVC") as UINavigationController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
    }
    
    func testPolicyBillingDetailsStoryBoard(){
        let storyboard = UIStoryboard(name: "PolicyBillingDetails", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("productContainerVc") as ProductContainerViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        XCTAssertNotNil(vc.segmentedControl,"segmented control is not connected" )
        XCTAssertNotNil(vc.containerView, "container view cannot be nil")
        var vc1 = storyboard.instantiateViewControllerWithIdentifier("billingVc") as BillingDetailViewController
        XCTAssertNotNil(vc1,"Storyboard is not connected with a viewcontroller" )
        
        vc1.loadView()
        XCTAssertNotNil(vc1.billingDetailsTableView, "tableview cannot be nil")
        
        
    }
    
    func testCalendarDatePickerStoryBoard(){
        let storyboard = UIStoryboard(name: "CalendarDatePicker", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("CalendarDatePickerVC") as CalendarDatePickerController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        
        vc.loadView()
        XCTAssertNotNil(vc.tableView, "tableview cannot be nil")
        XCTAssertNotNil(vc.todayBtn, "Button outlet should be connected")
        XCTAssertNotNil(vc.selectedBtn, "Button outlet should be connected")
        //XCTAssertNotNil(vc.cancelBtn, "Button outlet should be connected")
        
        let actions  = vc.todayBtn?.action
        XCTAssertTrue(actions == "goToToday:", "Button action is not linked")
        
        let actions1  = vc.selectedBtn?.action
        
        XCTAssertTrue(actions1 == "goToSelectedDay:", "Button action is not linked")
        
        
        
    }
    
    
    func testClientInfoViewIphoneStoryBoard(){
        let storyboard = UIStoryboard(name: "ClientInfoViewIphone", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("clientInformation") as ClientInfoIphoneTableVC
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        
    }
    
    func testClientProfileIpadViewStoryBoard(){
        let storyboard = UIStoryboard(name: "ClientProfileIpadView", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("ClientProfileIpadViewVC") as ClientProfileIpadTableVC
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        XCTAssertNotNil(vc.profileInfoTableView, "cannot be nil")
        XCTAssertNotNil(vc.notesTableView, "cannot be nil")
        XCTAssertNotNil(vc.acceptButton, "cannot be nil")
        XCTAssertNotNil(vc.cancelButton, "cannot be nil")
        XCTAssertNotNil(vc.noteTextView, "cannot be nil")
        
        let actions:NSArray = vc.acceptButton.actionsForTarget(vc, forControlEvent: UIControlEvents.TouchUpInside)!
        XCTAssertTrue(actions.containsObject("acceptButtonTapped:"),"Button action not linked")
        
        let actions1:NSArray = vc.cancelButton.actionsForTarget(vc, forControlEvent: UIControlEvents.TouchUpInside)!
        XCTAssertTrue(actions1.containsObject("cancelButtonTapped:"), "Button action not linked")
    }
    
    func testProductDetailStoryBoard(){
        let storyboard = UIStoryboard(name: "ProductDetail", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("productDetailTV") as ProductDetailTableViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        
    }
    
    func testClientProfileInfoStoryBoard(){
        let storyboard = UIStoryboard(name: "ClientProfileInfo", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("profileInfo") as ClientProfileTableViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        
    }
    
    func testClientDetailsStoryBoard(){
        let storyboard = UIStoryboard(name: "ClientDetails", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("ClientDetailsVC") as ClientDetailTableViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        
    }
    
    func testClientDetailViewStoryBoard(){
        let storyboard = UIStoryboard(name: "ClientDetailView", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("ClientDetailViewVC") as ClientDetailViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        XCTAssertNotNil(vc.contactTableView, "cannot be nil")
        XCTAssertNotNil(vc.addressMapView, "cannot be nil")
    }
    
    
    func testClientsStoryBoard(){
        let storyboard = UIStoryboard(name: "Clients", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("ClientsVCTable") as ClientsTableViewController
        
        vc.loadView()
        XCTAssertNotNil(vc.clientSearchBar, "Not Nil")
        XCTAssertNotNil(vc.tableView, "Not Nil")
        
        var vc1 = storyboard.instantiateViewControllerWithIdentifier("EmptyDetailVC") as EmptyDetailViewController
        vc1.loadView()
        XCTAssertNotNil(vc1.settingButton, "cannot be nil")
        let actions  = vc1.settingButton.action
        XCTAssertTrue(actions == "settingsTapped:", "Button action is not linked")
        
    }
    
    func testContactStoryBoard(){
        let storyboard = UIStoryboard(name: "Contact", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("ContactVC") as ContactViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        
       
        XCTAssertNotNil(vc.topView, "cannot be nil")
        XCTAssertNotNil(vc.leftView, "cannot be nil")
        XCTAssertNotNil(vc.rightView, "cannot be nil")
        XCTAssertNotNil(vc.toolbar, "cannot be nil")
        XCTAssertNotNil(vc.photoButton, "cannot be nil")
        XCTAssertNotNil(vc.creditCardButton, "cannot be nil")
        XCTAssertNotNil(vc.alertMessageLabel, "cannot be nil")
        XCTAssertNotNil(vc.alertTitleLabel, "cannot be nil")
        XCTAssertNotNil(vc.alertTypeLabel, "cannot be nil")
        XCTAssertNotNil(vc.starRate, "cannot be nil")
        
       
        let actions2 = vc.photoButton.action
        XCTAssertTrue(actions2 == ("sendPhotoTapped:"), " photoButton not binded")
        let actions3 = vc.creditCardButton.action
        XCTAssertTrue(actions3 == ("collectPaymentBtnTapped:"), " creditCardButton not binded")
        
    }
    func testDashboardStoryBoard(){
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("DashboardVC") as UINavigationController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.viewDidLoad()
    }
    
    func testDelegatesStoryBoard(){
        let storyboard = UIStoryboard(name: "Delegates", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("DelegatesVC") as DelegatesTableViewController
        vc.loadView()
        
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        XCTAssertNotNil(vc.editButton,"cannot be nil" )
        XCTAssertNotNil(vc.removeButton,"cannot be nil" )
        XCTAssertNotNil(vc.cancelButton,"cannot be nil" )
        
        let actions  = vc.editButton.action
        
        
        XCTAssertTrue(actions == "editAction:", "editButton not binded")
        
        let actions2  = vc.removeButton.action
        XCTAssertTrue(actions2 == "removeAction:", "removeButton not binded")
        
        let actions3  = vc.cancelButton.action
        XCTAssertTrue(actions3 == "cancelAction:", "cancelButton not binded")
        
    }
    
    func testEditDelegatesStoryBoard(){
        let storyboard = UIStoryboard(name: "EditDelegates", bundle: NSBundle(forClass: self.dynamicType))
        var vc = storyboard.instantiateViewControllerWithIdentifier("EditDelegatesVC") as EditDelegatesViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        
        vc.loadView()
        XCTAssertNotNil(vc.collectionView, "collectionview cannot be nil")
        XCTAssertNotNil(vc.instructionLabel, "cannot be nil")
    }
    
//    func testLoginStoryBoard(){
//        let storyboard = UIStoryboard(name: "Login", bundle:NSBundle(forClass: self.dynamicType) )
//        var vc = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as LoginViewController
//        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
//        vc.loadView()
//        XCTAssertNotNil(vc.form, "cannot be nil")
//        XCTAssertNotNil(vc.badgeCutout, "cannot be nil")
//        XCTAssertNotNil(vc.usernameField, "cannot be nil")
//        XCTAssertNotNil(vc.passwordField, "cannot be nil")
//        XCTAssertNotNil(vc.rememberLabel, "cannot be nil")
//        XCTAssertNotNil(vc.rememberSwitch, "cannot be nil")
//        XCTAssertNotNil(vc.spinner, "cannot be nil")
//        XCTAssertNotNil(vc.versionLabel, "cannot be nil")
//        XCTAssertNotNil(vc.signInButton, "cannot be nil")
//        XCTAssertNotNil(vc.forgetPassword, "cannot be nil")
//        
//        let actions : NSArray = vc.signInButton.actionsForTarget(vc, forControlEvent: UIControlEvents.TouchUpInside)!
//        XCTAssertTrue(actions.containsObject("login"), " signInButton not binded")
//        
//        let actions1 : NSArray = vc.forgetPassword.actionsForTarget(vc, forControlEvent: UIControlEvents.TouchUpInside)!
//        XCTAssertTrue(actions1.containsObject("forgotPassword"), " forgetPassword not binded")
//        
//        let actions2 : NSArray = vc.rememberLabel.actionsForTarget(vc, forControlEvent: UIControlEvents.TouchUpInside)!
//        XCTAssertTrue(actions2.containsObject("toggleRememberSwitch"), " signInButton not binded")
//    }
    
    
    
    func testPhotosLibraryStoryBoard(){
        let storyboard = UIStoryboard(name: "PhotosLibrary", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("PhotosLibraryVC") as PhotosLibraryCollectionViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        XCTAssertNotNil(vc.collectionView, "collectionview is not nil")
    }
    
    func testPolicyDetailsStoryBoard(){
        let storyboard = UIStoryboard(name: "PolicyDetails", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("PolicyDetailsVC") as PolicyDetailTableViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        XCTAssertNotNil(vc.tableView, "cannot be nil")
        XCTAssertNotNil(vc.policyNameLabel, "cannot be nil")
        XCTAssertNotNil(vc.policyInfoLabel, "cannot be nil")
        
    }
    
    
    
    
    
    func testSmartListsStoryBoard(){
        let storyboard = UIStoryboard(name: "SmartLists", bundle:NSBundle(forClass: self.dynamicType) )
        var vc = storyboard.instantiateViewControllerWithIdentifier("SmartContainerVC") as SmartContainerViewController
        XCTAssertNotNil(vc,"Storyboard is not connected with a viewcontroller")
        vc.loadView()
        XCTAssertNotNil(vc.containerView,"cannot be nil")
        XCTAssertNotNil(vc.badgeBar,"cannot be nil")
        
        XCTAssertNotNil(vc.categoryButton,"cannot be nil")
        let actions  = vc.categoryButton.action
        XCTAssertTrue(actions == "category:", "categoryButton not binded")
    }
    
    
    
}
