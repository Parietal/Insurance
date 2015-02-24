//
//  SmartAlertActionTestsReusableComponentsViews.swift
//  SmartAlertAction
//
//  Created by Asif Junaid on 17/12/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit
import XCTest

class SmartAlertActionTestsReusableComponentsViews: XCTestCase {
    
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
    Testing reusable components .
    */
    func testDidLoadBadgeBar()
    {
        let badgeBar = BadgeBar(frame: CGRectMake(0, 0, 0, 0))
        XCTAssertNotNil(badgeBar, "BadgeBar View Did not Load")
    }
    
    func testDidLoadBarMeterView()
    {
        let barMeter = BarMeterView(frame: CGRectMake(0, 0, 0, 0))
        XCTAssertNotNil(barMeter, "BarMeter View Did not Load")
    }
    
    func testDidLoadCircularMeterView()
    {
        let circularMeterView = CircularMeterView(frame: CGRectMake(0, 0, 0, 0))
        XCTAssertNotNil(circularMeterView, "CircularMeter View Did not Load")
    }
    
    func testDidLoadDiamondRatingViewr()
    {
        let diamondRatingView = DiamondRatingView(frame: CGRectMake(0, 0, 0, 0))
        XCTAssertNotNil(diamondRatingView, "DiamondRating View View Did not Load")
    }
}
