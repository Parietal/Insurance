
//
//  SmartAlertActionTests.swift
//  SmartAlertActionTests
//
//  Created by Asif Junaid on 2014-12-17.
//  Copyright (c) 2014 IBM Corp. All rights reserved.
//

import UIKit
import XCTest
import SmartAlertAction
class SmartAlertActionTests: XCTestCase {
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
            // Put the code you want to measure the time ofx here.
        }
    }
    
    func testGoogleMapURL() {
        let URL = "http://maps.google.com/maps/api/geocode/json?sensor=false&address="
        let expectation = expectationWithDescription("Get \(URL)")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(NSURL(string: URL)!, completionHandler: {(data, response, error) in
            expectation.fulfill()
            
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as NSHTTPURLResponse! {
                XCTAssertEqual(HTTPResponse.URL!.absoluteString!, URL, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(HTTPResponse.MIMEType! as String, "application/json", "HTTP response content type should be text/html")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
        })
        
        task.resume()
        
        waitForExpectationsWithTimeout(task.originalRequest.timeoutInterval, handler: { error in
            task.cancel()
        })
        
        
    }
    
    
    
    
}
