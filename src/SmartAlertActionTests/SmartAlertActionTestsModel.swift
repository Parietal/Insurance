//
//  SmartAlertActionTestsModel.swift
//  SmartAlertAction
//
//  Created by Asif Junaid on 17/12/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit
import XCTest

class SmartAlertActionTestsModel: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code====---- here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    
    
    /**
    Testing Model data
    */
    
    private func openFile(fileName: String) -> AnyObject {
        var filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") as String?
        var raw:NSData? = NSData.dataWithContentsOfMappedFile(filePath!) as NSData?
        var jsonData:AnyObject = NSJSONSerialization.JSONObjectWithData(raw!, options: NSJSONReadingOptions.MutableContainers, error: nil)!
        if let data = jsonData as? NSArray
        {
            return data
        }
        
        return NSArray()
    }
    
    
    func testLIFE_alert_details() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("LIFE_alert_details") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in LIFE_alert_details")
    }
    func testLIFE_client_details() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("LIFE_client_details") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in LIFE_client_details")
    }
    func testLIFE_clients() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("LIFE_clients") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in LIFE_clients")
    }
    func testLIFE_policy_details() {
        var jsonData = NSArray()
        self.measureBlock() {
            
            jsonData = self.openFile("LIFE_policy_details") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in LIFE_policy_details")
    }
    
    func testLIFE_smartlist_alerts() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("LIFE_smartlist_alerts") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in LIFE_smartlist_alerts")
    }
    
    
    func testagents() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("agents") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in agents")
    }
    
    func testalert_details() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("alert_details") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in alert_details")
    }
    
    func testall_agents() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("all_agents") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in all_agents")
    }
    
    func testbillings() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("billings") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in billings")
    }
    func testcategories() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("categories") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in categories")
    }
    func testclient_details() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("client_details") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in client_details")
    }
    func testclients() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("clients") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in clients")
    }
    
    func testdelegates() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("delegates") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in delegates")
    }
    func testfinishAlert() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("finishAlert") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in finishAlert")
    }
    
    func testpolicy_details() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("policy_details") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in policy_details")
    }
    func testsmartlist_alerts() {
        var jsonData = NSArray()
        self.measureBlock() {
            jsonData = self.openFile("smartlist_alerts") as NSArray
        }
        XCTAssert(jsonData.count > 0,"there should be some data in smartlist_alerts")
    }
    
    
    /**
    
    Few models that gave exception , need to check the structure
    
    func testnote() {
    var jsonData = openFile("note") as NSArray
    XCTAssert(jsonData.count > 0,"there should be some data in note")
    }
    
    func testdelegate() {
    var jsonData = openFile("delegate") as NSArray
    XCTAssert(jsonData.count > 0,"there should be some data in delegate")
    }
    func testbadgebar_details() {
    var jsonData = openFile("badgebar_details") as NSArray
    XCTAssert(jsonData.count > 0,"there should be some data in badgebar_details")
    }
    func testagent() {
    var jsonData = openFile("agent") as NSArray
    XCTAssert(jsonData.count > 0,"there should be some data in agent")
    }
    */
    
    
    
    
}
