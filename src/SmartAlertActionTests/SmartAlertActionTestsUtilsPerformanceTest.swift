//
//  SmartAlertActionTestsUtilsPerformanceTest.swift
//  SmartAlertAction
//
//  Created by Asif Junaid on 02/01/15.
//  Copyright (c) 2015 IBM Corporation. All rights reserved.
//

import UIKit
import MapKit
import XCTest
import CoreData
class SmartAlertActionTestsUtilsPerformanceTest: XCTestCase {
    let moc = NSManagedObjectContext()
    override func setUp() {
        super.setUp()
        // Setting up NSManagedObject
        let mom = NSManagedObjectModel.mergedModelFromBundles(nil)
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom!)
        
        moc.persistentStoreCoordinator = psc
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    
    func testDateFormatterPerformance() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        let date = NSDate()
        self.measureBlock() {
            let string = dateFormatter.stringFromDate(date)
        }
    }
    
    func testCurrencyFormatterPerformance() {
        
        let formatter:NSNumberFormatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        var doubleValue = 100
        self.measureBlock() {
            let string = formatter.stringFromNumber(doubleValue)
        }
    }
    
    func testConvertStringToDate()
    {
        
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var today:NSDate = NSDate()
        let dString = dateFormatter.stringFromDate(today)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.measureBlock() {
            let d:NSDate = dateFormatter.dateFromString(dString)!
        }
        
    }
    func testConvertDateToString()
    {
        let nsDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.measureBlock() {
            let dString = dateFormatter.stringFromDate(nsDate)
        }
    }
    
    func testgetAllCategoryDetail()
    {
        self.measureBlock() {
            let fetchRequest = NSFetchRequest(entityName: "Category")
            let syncDatas = self.moc.executeFetchRequest(fetchRequest, error: nil) as [Category]?
            
        }
    }
    
    func testGetAllAlert()
    {
        self.measureBlock() {
            let fetchRequest = NSFetchRequest(entityName: "Alert")
            let syncDatas = self.moc.executeFetchRequest(fetchRequest, error: nil) as [Category]?
            
        }
    }
    
    func testGetAllAuthorDetail()
    {
        self.measureBlock() {
            let fetchRequest = NSFetchRequest(entityName: "Author")
            let syncDatas = self.moc.executeFetchRequest(fetchRequest, error: nil) as [Category]?
            
        }
    }
    
    func testGetAllDelegate()
    {
        self.measureBlock() {
            let fetchRequest = NSFetchRequest(entityName: "Delegate")
            let syncDatas = self.moc.executeFetchRequest(fetchRequest, error: nil) as [Category]?
            
        }
    }
    func testGetAllSettings()
    {
        self.measureBlock() {
            let fetchRequest = NSFetchRequest(entityName: "Settings")
            let syncDatas = self.moc.executeFetchRequest(fetchRequest, error: nil) as [Category]?
            
        }
    }
    
    func testGetAllNoteDetail()
    {
        self.measureBlock() {
            let fetchRequest = NSFetchRequest(entityName: "Note")
            let syncDatas = self.moc.executeFetchRequest(fetchRequest, error: nil) as [Category]?
            
        }
    }
    
    //Swaym's code
    func testGoogleAPI()
    {
        self.measureBlock(){
            var urlString  = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=";
            var url = NSURL(string: urlString)
            let result = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)
        }
        
    }
    
    func testTimeWillTakeToReach(){
        
        var directionRequest: MKDirectionsRequest = MKDirectionsRequest()
        
        var direction: MKDirections = MKDirections(request: directionRequest)
        
        
        self.measureBlock(){
            
            //getting the route from source to destination
            direction.calculateDirectionsWithCompletionHandler(){(response: MKDirectionsResponse! ,  error: NSError!)
                in
                if let err = error
                {
                    // println("error error error!!")
                    println(error.description)
                }
                else
                {
                    // calculating ETA using the route
                    var routeDetails: MKRoute = response.routes.last as MKRoute
                    
                    var expectedTimeOfArrival = (response.routes.last?.expectedTravelTime)!/3600  //ETA in hours
                    
                    //used to delegate the ETA value after the completion handler finishes execution
                    println("expectedTimeOfArrival  \(expectedTimeOfArrival)")
                    
                }
            }
        }
    }
}

