//
//  ClientDetailViewController.swift
//  SmartAlertAction
//
//  Created by cdp on 10/7/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import MessageUI
import CoreLocation

protocol LocationDelegate
{
    func expectedTOA (ETA: NSTimeInterval)   //protocol for the expected time of arrival
}

class ClientDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,PageTransitionProtocol, UIActionSheetDelegate,CLLocationManagerDelegate,LocationDelegate {
    
    var delegate:LocationDelegate?
    
    var TAG_PHONE_CELL:Int { return 201 }
    var TAG_MOBILE_CELL:Int { return 202 }
    var TAG_EMAIL_CELL:Int { return 203 }
    
    // Table view to display the contact details of the client
    @IBOutlet weak var contactTableView: UITableView!
    
    //mapview to display the address on map
    @IBOutlet weak var addressMapView : MKMapView!
    
    // latitude and longitudes for client address
    var latitude:CLLocationDegrees = 0.0
    var longitude:CLLocationDegrees = 0.0
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    var resultCoordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var location = MKPointAnnotation()
    
    var lblETA = UILabel()
    
    // input params
    class var INPUT_PARAM_CLIENT_ID: String { return "clientId" }
    class var TAG_ACTION_CALL_CLIENT:Int { return 103 }
    class var TAG_ACTION_TEXT_CLIENT:Int { return 104 }
    
    // ui controls
    //    var contactCell: ClientDetailContactTableViewCell?
    var actionCell: UITableViewCell?
    var infoCell: UITableViewCell?
    var productCell: UITableViewCell?
    var settingsCell: UITableViewCell?
    
    var phoneIcons: [UIImage] = [UIImage(named: "icon_phone_up")!, UIImage(named: "icon_phone_down")!]
    var textIcons: [UIImage] = [UIImage(named: "icon_text_up")!, UIImage(named: "icon_text_down")!]
    var emailIcons: [UIImage] = [UIImage(named: "icon_email_up")!, UIImage(named: "icon_email_down")!]
    
    
    // class variables
    var titleOfContactInfo: [String] = ["Address", "Phone", "Mobile", "Email"]
    var actionOfContactInfo: [String] = ["Save contact to Device"]
    
    
    var showAlertTitle = "Show Alerts"
    var clientDetail: ClientModel?
    var clientId: Int = 0
    
    // activity indicator
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CLLocationManager.locationServicesEnabled()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        addressMapView.delegate = self
        locationManager.startUpdatingLocation()

        // load client data
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        println("***********MEMORY WARNING RECEIVED...")
    }
    
    func loadData() {
        // show loading
        self.spinner.startAnimatingOnView(self.view)
        
        ClientService.getDetailsForClient(self.clientId, completionHandler: {(client:ClientModel?, error: NSError?) -> Void in
            
            self.title = "Contact Information"
            
            // assign to client detail
            self.clientDetail = client
            var clientAddress = self.clientDetail?.address
            self.resultCoordinates = self.addressToLatLong(address: clientAddress!)
            self.drawMap(self.resultCoordinates.latitude, long: self.resultCoordinates.longitude)
            
            self.navigationController?.navigationBar.tintColor = RAColors.BLUE1  // Bruce ** Color Change
            
            // reload client data
            self.contactTableView.reloadData()
            
            // hide loading
            self.spinner.stopAnimatingOnView()

            
        })
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func settingsTapped(sender: AnyObject) {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateViewControllerWithIdentifier("AlertNotification") as UIViewController
            
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
        else{
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as UISplitViewController
            controller.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if(indexPath.row == 0){
            return 75
        }else{
            return 55
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection indexPath: NSIndexPath) -> CGFloat{
        var cell: UITableViewCell?
        // header.bottomSeparatorColor = RAColors.GRAY5
        self.contactTableView.separatorColor = RAColors.GRAY3
        return 0
    }
    
    func addressToLatLong(#address:String) ->CLLocationCoordinate2D
    {
        var esc_addr: String? = address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlString  = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=";
        urlString += esc_addr!
        var url = NSURL(string: urlString)
        let result: NSString? = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)
       // println("result\(result)")
        var resultCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        if(result != nil){
            let scanner:NSScanner = NSScanner(string: result!)
            if(scanner.scanUpToString("\"location\"", intoString: nil) && scanner.scanString("\"location\"", intoString: nil))
            {
                if(scanner.scanUpToString("\"lat\" :", intoString: nil) && scanner.scanString("\"lat\" :", intoString: nil))
                {
                    scanner.scanDouble(&latitude)
                }
                if(scanner.scanUpToString("\"lng\" :", intoString: nil) && scanner.scanString("\"lng\" :", intoString: nil))
                {
                    scanner.scanDouble(&longitude);
                }
            }
            if(latitude != 0.0 && longitude != 0.0)
            {
                //setting the result coordinate with the searched latitude and longitude values
                resultCoordinate.latitude = latitude;
                resultCoordinate.longitude = longitude;
            }
        }else{
            
            var center:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0);
            center.latitude = latitude;
            center.longitude = longitude;
            return center;
        }
        return resultCoordinate;
    }

    
    
    func drawMap(lat:CLLocationDegrees, long:CLLocationDegrees)
    {
        
        var deltaLati:CLLocationDegrees = 0.01
        var deltaLong:CLLocationDegrees = 0.01
        
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(deltaLati, deltaLong)
        addressMapView.frame.size.width = 260
        addressMapView.frame.size.height = 260
        addressMapView.delegate = self
        
        var workLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)

        var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(workLocation, theSpan)
        addressMapView.setRegion(theRegion, animated: true)
        addressMapView.showsUserLocation = true
        
        //PHM commented out, was causing bad zoom level
        //addressMapView.setCenterCoordinate(workLocation, animated: true)

        // Pin the Location using Annotation
        var location1:MKPointAnnotation = MKPointAnnotation()
    
        location1.coordinate = workLocation
        
      //  println("My Current Location is \(workLocation)")
        location1.title = self.clientDetail?.address
        addressMapView.addAnnotation(location1)
        addressMapView.selectAnnotation(location1, animated: true)


    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
       
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
            var calloutView = UIView(frame: CGRectMake(0, 10, 70, 50))
            calloutView.backgroundColor = RAColors.BLUE1
            
            var button = UIButton(frame: CGRectMake(0, 3, 70, 25))
            button.backgroundColor = RAColors.BLUE1
            button.setImage(UIImage(named: "icon_car_map"), forState: UIControlState.Normal)
            calloutView.addSubview(button)
            
            lblETA.frame = CGRectMake(0, 25, 70, 20)
           // lblDistance = UILabel(frame: CGRectMake(0, 25, 50, 20))
            lblETA.backgroundColor = RAColors.BLUE1
            lblETA.font = UIFont.systemFontOfSize(12)
            lblETA.textColor = UIColor.whiteColor()
            lblETA.textAlignment = NSTextAlignment.Center

            calloutView.addSubview(lblETA)
            
            anView.leftCalloutAccessoryView = calloutView
            
        }
        else
        {
            anView.annotation = annotation
        }
        anView.image = UIImage(named: "icon_pin")
        
        return anView
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
       // println("new Location: \(newLocation)")
        let currentLocation = newLocation
        if currentLocation != nil
        {
//            println(currentLocation.coordinate.latitude)
//            println(currentLocation.coordinate.longitude)
    
        }
        
        var timeToReach:NSTimeInterval = getETAUsingLatLong(sourceCoordinate: currentLocation.coordinate, destinationCoordinate: resultCoordinates)
    }
    
    
    //calculate distance between two points in km using the latitude and longitude
    func getDistanceUsingLatLong(#sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D)-> CLLocationDistance
    {
        var noDistanceCalculated: CLLocationDistance = CLLocationDistance(0.0)
        
        //checking if the coordinates provided by user are in the correct range
        if(sourceCoordinate.latitude <= 90) && (sourceCoordinate.latitude >= -90) && (sourceCoordinate.longitude <= 180) && (sourceCoordinate.longitude >= -180)
        {
            if(destinationCoordinate.latitude <= 90) && (destinationCoordinate.latitude >= -90) && (destinationCoordinate.longitude <= 180) && (destinationCoordinate.longitude >= -180)
            {
                //variable to store destination and source location
                var destLocation: CLLocation = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
                
                var sourceLocation: CLLocation = CLLocation(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude)
                
                //calculate the distance in meters using latitude and longitude
                var distanceInMeter: CLLocationDistance =   ((destLocation as CLLocation).distanceFromLocation(sourceLocation) )as CLLocationDistance
                
                return distanceInMeter/1000      //returning the distance in km
            }
        }
        
        //when the user entered coordinates are out of valid range
        return noDistanceCalculated
    }

    
    
    internal func getETAUsingLatLong(#sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) -> NSTimeInterval
    {
        //variable to store the Expected Time of Arrival (ETA)
        var expectedTimeOfArrival: NSTimeInterval = NSTimeInterval()
        
        //checking if the coordinates provided by user are in the correct range
        if(sourceCoordinate.latitude <= 90) && (sourceCoordinate.latitude >= -90) && (sourceCoordinate.longitude <= 180) && (sourceCoordinate.longitude >= -180)
        {
            if(destinationCoordinate.latitude <= 90) && (destinationCoordinate.latitude >= -90) && (destinationCoordinate.longitude <= 180) && (destinationCoordinate.longitude >= -180)
            {
                //variable to make a MKDirection request
                var directionRequest: MKDirectionsRequest = MKDirectionsRequest()
                
                //variables to store the source and destination placemark
                var sourcePlacemark: MKPlacemark = MKPlacemark(coordinate: sourceCoordinate, addressDictionary: nil)
                var destinationPlacemark: MKPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil )
                
                //variables to store the source and destination mapItem
                var sourceItem: MKMapItem = MKMapItem(placemark: sourcePlacemark)
                var destinationItem: MKMapItem = MKMapItem(placemark: destinationPlacemark)
                
                //setting the source and destination for the direction request
                directionRequest.setSource(sourceItem)
                directionRequest.setDestination(destinationItem)
                //setting the transport type to be automobile
                directionRequest.transportType = MKDirectionsTransportType.Automobile
                //making the direction request
                var direction: MKDirections = MKDirections(request: directionRequest)
                
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
                       
                        expectedTimeOfArrival = (response.routes.last?.expectedTravelTime)!/3600  //ETA in hours
                        
                        //used to delegate the ETA value after the completion handler finishes execution
                        println("expectedTimeOfArrival  \(expectedTimeOfArrival)")
                        self.expectedTOA(expectedTimeOfArrival)
                    }
                }
                return expectedTimeOfArrival  //returning the Expected Time Of Arrival in hours
            }
        }
        
        //when the user entered coordinates are out of valid range
        return expectedTimeOfArrival
    }

    
    
    @IBAction func rightButton1Tapped(sender: AnyObject) {
        
        switch(sender.tag){
            
        case TAG_MOBILE_CELL:
            textClient(sender)
            break
        default:
            break
        }
        
    }
    
    
    // method to implement for MessageComposeDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult){
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func rightButton2Tapped(sender: AnyObject) {
        switch(sender.tag){
            
        case TAG_PHONE_CELL:
            callClient(sender)
            break
            
        case TAG_MOBILE_CELL:
            callClient(sender)
            break
            
        case TAG_EMAIL_CELL:
            emailClient(sender)
            break
        default:
            break
        }
        
    }
    
    
    func textClient(sender: AnyObject) {
        if(self.clientDetail != nil){
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
    
    // MARK: - UI action handling
    
    func callClient(sender: AnyObject) {
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            // no action on iPad
            return
        }else{
            if(self.clientDetail != nil){
                var client: ClientModel = self.clientDetail!
                var str_number = ""
                
                if(sender.tag == TAG_PHONE_CELL){
                    str_number = client.phone
                }else if(sender.tag == TAG_MOBILE_CELL){
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
    
    func emailClient(sender: AnyObject) {
        if(self.clientDetail != nil){
            var client: ClientModel = self.clientDetail!
            var app:UIApplication = UIApplication.sharedApplication()
            
            //  app.openURL(NSURL(string: "mailto:" + client.email))
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
    }
    
    
    
    //button to save contact to device
    
    @IBAction func saveContactBtn(sender: AnyObject) {
    }
    
    //button to add a note for the client
    @IBAction func addNoteBtn(sender: AnyObject) {
        
    }
    
    // MARK: - Action Sheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch actionSheet.tag {
        case ClientDetailViewController.TAG_ACTION_CALL_CLIENT:
            if(self.clientDetail != nil){
                var app:UIApplication = UIApplication.sharedApplication()
                var client: ClientModel = self.clientDetail!
                if buttonIndex == 1 {
                    app.openURL(NSURL(string: "tel:" + client.phone)!)
                }else if buttonIndex == 2 {
                    app.openURL(NSURL(string: "tel:" + client.mobile)!)
                }
            }
            return
        case ClientDetailViewController.TAG_ACTION_TEXT_CLIENT:
            if(self.clientDetail != nil){
                var app:UIApplication = UIApplication.sharedApplication()
                var client: ClientModel = self.clientDetail!
                if buttonIndex == 1 {
                    app.openURL(NSURL(string: "tel:" + client.phone)!)
                }else if buttonIndex == 2 {
                    app.openURL(NSURL(string: "tel:" + client.mobile)!)
                }
                
                if(MFMessageComposeViewController.canSendText()){
                    // device can send Message
                    var msgController = MFMessageComposeViewController()
                    msgController.body = "Hello"
                    if buttonIndex == 1 {
                        msgController.recipients = [client.phone]
                    }else if buttonIndex == 2 {
                        msgController.recipients = [client.mobile]
                    }
                    
                    msgController.messageComposeDelegate = self
                    //[self presentModalViewController:controller animated:YES];
                    // [self presentViewController:controller animated:YES completion:nil];
                    self.presentViewController(msgController, animated: true, completion: nil)
                    
                }else{
                    UIAlertView(title: "", message: "Text message not supported on this device", delegate: nil, cancelButtonTitle: "OK").show()
                }
            }

            return
        default:
            // nop
            return
        }
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return self.rowsOfSections[section]
    //    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if(tableView == self.contactTableView){
            cell = self.initContactInfoSection(cellForRowAtIndexPath: indexPath)
        }
        else{
            cell = UITableViewCell()
        }
        
        return cell!
    }

    // contact info section
    func initContactInfoSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var row = indexPath.row
        switch row {
        case 0:
            cell = self.setAddressCell(row,title: self.titleOfContactInfo[row], text: self.clientDetail?.address, firstIcons: nil, secondIcons: nil)
        case 1:
            cell = self.setContactCell(row,title: self.titleOfContactInfo[row], text: self.clientDetail?.phone, firstIcons: self.phoneIcons, secondIcons: nil, tag: TAG_PHONE_CELL)
        case 2:
            cell = self.setContactCell(row,title: self.titleOfContactInfo[row] ,text: self.clientDetail?.mobile, firstIcons: self.phoneIcons, secondIcons: self.textIcons, tag: TAG_MOBILE_CELL)
        case 3:
            cell = self.setContactCell(row, title: self.titleOfContactInfo[row],text: self.clientDetail?.email, firstIcons: self.emailIcons, secondIcons: nil, tag: TAG_EMAIL_CELL)
        
        // hiding "Save contact to device row
        //case 4:
          //  cell = self.setActionCell(0)
        default:
            cell = UITableViewCell()
        }
        
        return cell!
    }

    
    // set each cell according to its type
    
    func setAddressCell(index: Int,title: String?, text: String?, firstIcons: [UIImage]?, secondIcons: [UIImage]?) -> UITableViewCell {
        
        var cell : ClientDetailContactTableViewCell? = contactTableView?.dequeueReusableCellWithIdentifier("addressCell") as? ClientDetailContactTableViewCell
        cell?.titleLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        cell?.contentLabel.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
        
        cell?.titleLabel.text = title!
        cell?.contentLabel.text = text
        if firstIcons != nil {
            cell?.rightButton1.setImage(firstIcons?[0], forState: UIControlState.Normal)
            cell?.rightButton1.setImage(firstIcons?[1], forState: UIControlState.Highlighted)
            cell?.rightButton1.hidden = false
        } else {
            cell?.rightButton1.hidden = true
        }
        if secondIcons != nil {
            cell?.rightButton2.setImage(secondIcons?[0], forState: UIControlState.Normal)
            cell?.rightButton2.setImage(secondIcons?[1], forState: UIControlState.Highlighted)
            cell?.rightButton2.hidden = false
        } else {
            cell?.rightButton2.hidden = true
        }
        return cell!
    }
    
    
    // set each cell according to its type
    
    func setContactCell(index: Int,title: String?, text: String?, firstIcons: [UIImage]?, secondIcons: [UIImage]?, tag : Int) -> UITableViewCell {
        
        var cell : ClientDetailContactTableViewCell? = contactTableView?.dequeueReusableCellWithIdentifier("contactCell") as? ClientDetailContactTableViewCell
        cell?.titleLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        cell?.contentLabel.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
        
        cell?.titleLabel.text = title!
        cell?.contentLabel.text = text
        if firstIcons != nil {
            cell?.rightButton1.setImage(firstIcons?[0], forState: UIControlState.Normal)
            cell?.rightButton1.setImage(firstIcons?[1], forState: UIControlState.Highlighted)
            cell?.rightButton1.hidden = false
            cell?.rightButton1.tag = tag

        } else {
            cell?.rightButton1.hidden = true
        }
        if secondIcons != nil {
            cell?.rightButton2.setImage(secondIcons?[0], forState: UIControlState.Normal)
            cell?.rightButton2.setImage(secondIcons?[1], forState: UIControlState.Highlighted)
            cell?.rightButton2.hidden = false
            cell?.rightButton2.tag = tag

        } else {
            cell?.rightButton2.hidden = true
        }
        return cell!
    }
    
    func setActionCell(index: Int) -> UITableViewCell {
        var cell = contactTableView.dequeueReusableCellWithIdentifier("saveContactCell") as? ActionTableViewCell
        cell?.saveContactButton?.titleLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_17
        cell?.saveContactButton?.titleLabel?.text = self.actionOfContactInfo[index]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.contactTableView){
            
            //return 5
            return 4   // hiding the "Save contact to device" row
        }else{
            return 1
        }
    }
    
    // MARK: - Page Transition Protocol
    
    func setInputParams(params: Dictionary<String, AnyObject>) {
        // get and set client id
        if let id = params[ClientDetailTableViewController.INPUT_PARAM_CLIENT_ID]! as? Int {
            self.clientId = id
        }
    }
    
    func expectedTOA (ETA: NSTimeInterval)
    {
        var time: Double = (ETA.description as NSString).doubleValue
        var hrsTime: Int = Int(time)
        lblETA.text = toString(hrsTime) + " hrs"
        locationManager.stopUpdatingLocation()
        // getETA.text = toString(hrsTime) + " " + "hours"
    }
    
}









