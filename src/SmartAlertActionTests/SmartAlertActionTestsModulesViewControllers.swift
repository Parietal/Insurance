//
//  SmartAlertActionTestsModulesViewControllers.swift
//  SmartAlertAction
//
//  Created by Asif Junaid on 17/12/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit
import XCTest

class SmartAlertActionTestsModulesViewControllers: XCTestCase {
    
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    /**
    Testing view controllers.
    */
    
    func testdidAddPhotoOptionsCollectionViewController()
    {
        let viewController = AddPhotoOptionsCollectionViewController()
        XCTAssertNotNil(viewController, "AddPhotoOptionsCollectionViewController Did not Load")
    }
    func testdidLoadAddPhotoOptionsTableViewController()
    {
        let viewController = AddPhotoOptionsTableViewController()
        XCTAssertNotNil(viewController, "AddPhotoOptionsTableViewController Did not Load")
    }
    
    func testdidLoadAddPhotoOptionsViewController()
    {
        let viewController = AddPhotoOptionsViewController()
        XCTAssertNotNil(viewController, "AddPhotoOptionsViewController Did not Load")
    }
    
    
    func testdidLoadAllAgentsViewController()
    {
        let viewController = AllAgentsViewController()
        XCTAssertNotNil(viewController, "AllAgentsViewController Did not Load")
    }
    
    func testdidLoadAlertDetailTableViewController()
    {
        let viewController = AlertDetailTableViewController()
        XCTAssertNotNil(viewController, "AlertDetailTableViewController Did not Load")
        
        
    }
    
    
    func testdidLoadPostponeTableViewController()
    {
        let viewController = PostponeTableViewController()
        XCTAssertNotNil(viewController, "PostponeTableViewController Did not Load")
    }
    
    func testdidLoadAlertNotificationTableViewController()
    {
        let viewController = AlertNotificationTableViewController()
        XCTAssertNotNil(viewController, "AlertNotificationTableViewController Did not Load")
    }
    
    func testdidLoadNotificationImportanceTableViewController()
    {
        let viewController = NotificationImportanceTableViewController()
        XCTAssertNotNil(viewController, "NotificationImportanceTableViewController Did not Load")
    }
    
    func testdidLoadBillingDetailViewController()
    {
        let viewController = BillingDetailViewController()
        XCTAssertNotNil(viewController, "BillingDetailViewController Did not Load")
    }
    
    func testdidLoadProductContainerViewController()
    {
        let viewController = ProductContainerViewController()
        XCTAssertNotNil(viewController, "ProductContainerViewController Did not Load")
    }
    
    func testdidLoadClientProfileTableViewController()
    {
        let viewController = ClientProfileTableViewController()
        XCTAssertNotNil(viewController, "ClientProfileTableViewController Did not Load")
    }
    
    func testdidLoadProductDetailTableViewController()
    {
        let viewController = ProductDetailTableViewController()
        XCTAssertNotNil(viewController, "ProductDetailTableViewController Did not Load")
    }
    func testdidLoadClientDetailTableViewController()
    {
        let viewController = ClientDetailTableViewController()
        XCTAssertNotNil(viewController, "ClientDetailTableViewController Did not Load")
    }
    func testdidLoadClientDetailViewController()
    {
        let viewController = ClientDetailViewController()
        XCTAssertNotNil(viewController, "ClientDetailViewController Did not Load")
    }
    func testdidLoadMasterTableViewController()
    {
        let viewController = MasterTableViewController()
        XCTAssertNotNil(viewController, "MasterTableViewController Did not Load")
    }
    func testdidLoadEmptyDetailViewController()
    {
        let viewController = EmptyDetailViewController()
        XCTAssertNotNil(viewController, "EmptyDetailViewController Did not Load")
    }
    func testdidLoadClientsTableViewController()
    {
        let viewController = ClientsTableViewController()
        XCTAssertNotNil(viewController, "ClientsTableViewController Did not Load")
    }
    func testdidLoadConfirmPhotoViewController()
    {
        let viewController = ConfirmPhotoViewController()
        XCTAssertNotNil(viewController, "ConfirmPhotoViewController Did not Load")
    }
    func testdidLoadContactViewController()
    {
        let viewController = ContactViewController()
        XCTAssertNotNil(viewController, "ContactViewController Did not Load")
    }
    func testdidLoadFinishTableViewController()
    {
        let viewController = FinishTableViewController()
        XCTAssertNotNil(viewController, "FinishTableViewController Did not Load")
    }
    func testdidLoadFinishNotesViewController()
    {
        let viewController = FinishNotesViewController()
        XCTAssertNotNil(viewController, "FinishNotesViewController Did not Load")
    }
    func testdidLoadDelegatesTableViewController()
    {
        let viewController = DelegatesTableViewController()
        XCTAssertNotNil(viewController, "DelegatesTableViewController Did not Load")
    }
    func testdidLoadAddDelegateTableViewController()
    {
        let viewController = AddDelegateTableViewController()
        XCTAssertNotNil(viewController, "AddDelegateTableViewController Did not Load")
    }
    func testdidLoadEditDelegatesViewController()
    {
        let viewController = EditDelegatesViewController()
        XCTAssertNotNil(viewController, "EditDelegatesViewController Did not Load")
    }
//    func testdidLoadLoginViewController()
//    {
//        let viewController = LoginViewController()
//        XCTAssertNotNil(viewController, "LoginViewController Did not Load")
//    }
    
    
    func testdidLoadMainViewController()
    {
        let viewController = MainViewController()
        XCTAssertNotNil(viewController, "MainViewController Did not Load")
    }
    func testdidLoadPhotosLibraryCollectionViewController()
    {
        let viewController = PhotosLibraryCollectionViewController()
        XCTAssertNotNil(viewController, "PhotosLibraryCollectionViewController Did not Load")
    }
    func testdidLoadPolicyDetailTableViewController()
    {
        let viewController = PolicyDetailTableViewController()
        XCTAssertNotNil(viewController, "PolicyDetailTableViewController Did not Load")
    }
    
    func testdidLoadProductOverViewTableViewController()
    {
        let viewController = ProductOverViewTableViewController()
        XCTAssertNotNil(viewController, "ProductOverViewTableViewController Did not Load")
    }
    
    func testdidLoadSettingsTableViewController()
    {
        let viewController = SettingsTableViewController()
        XCTAssertNotNil(viewController, "SettingsTableViewController Did not Load")
    }
    
    
    func testdidLoadAgentImageCollectionViewController()
    {
        let viewController = AgentImageCollectionViewController()
        XCTAssertNotNil(viewController, "AgentImageCollectionViewController Did not Load")
    }
    
    func testdidLoadCategoryViewController()
    {
        let viewController = CategoryViewController()
        XCTAssertNotNil(viewController, "CategoryViewController Did not Load")
    }
    func testdidLoadCompleteViewController()
    {
        let viewController = CompleteViewController()
        XCTAssertNotNil(viewController, "CompleteViewController Did not Load")
    }
    func testdidLoadDelegateAlertViewController()
    {
        let viewController = DelegateAlertViewController()
        XCTAssertNotNil(viewController, "DelegateAlertViewController Did not Load")
    }
    func testdidLoadSmartAlertsViewController()
    {
        let viewController = SmartAlertsViewController()
        XCTAssertNotNil(viewController, "SmartAlertsViewController Did not Load")
    }
    
    func testdidLoadSmartContainerViewController()
    {
        let viewController = SmartContainerViewController()
        XCTAssertNotNil(viewController, "SmartContainerViewController Did not Load")
    }
    func testdidLoadSmartListsViewController()
    {
        let viewController = SmartListsViewController()
        XCTAssertNotNil(viewController, "SmartListsViewController Did not Load")
    }
    
    func testdidLoadRecommendationTableViewController()
    {
        let viewController = RecommendationTableViewController()
        XCTAssertNotNil(viewController, "RecommendationTableViewController Did not Load")
    }
    
    func testdidLoadOtherCategoryTableViewController()
    {
        let viewController = OtherCategoryTableViewController()
        XCTAssertNotNil(viewController, "OtherCategoryTableViewController Did not Load")
    }
    
}
