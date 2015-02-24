//
//  ContactViewController.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/14/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import AssetsLibrary

// MARK: - Remove UIActionSheetDelegate when UIAlertController fully implemented
class ContactViewController: UIViewController ,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate, FinishAlertDelegate, AddPhotoOptionsPopoverDelegate, PhotosLibraryDelegate, AddPhotoOptionsCollectionViewControllerDelegate, AddPhotosConfirmDelegate, photoLibraryDelegate, FinishNoteDelegate
{
    
    @IBOutlet var topView: UIView!
    @IBOutlet var leftView: UIView!
    @IBOutlet var rightView: UIView!
    
    var TAG_ALERT_OK:Int { return 100 }
    var TAG_ALERT_CANCEL:Int { return 101 }
    
    // iPhone
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var photoButton: UIBarButtonItem!   // misspell of photo
    @IBOutlet weak var creditCardButton: UIBarButtonItem!
    
    var chosenImage : UIImage!
    
    @IBOutlet var alertMessageLabel: UILabel!
    @IBOutlet var alertTitleLabel: UILabel!
    @IBOutlet var alertTypeLabel: UILabel!
    @IBOutlet weak var starRate: DiamondRatingView!
    
    var alertId: Int = Constants.DEFAULT_ALERT_ID
    var alertDetail: AlertModel?
    
    var delegate:ContactViewDelegate?
    
    //PHM added here so it is available throughout all functions for custom camera overlay.
    var imagePickerController = UIImagePickerController()
    
    private var leftViewController: UIViewController?
    private var rightViewController: UIViewController?
    
    private var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    private var finishTitlesList:[FinishTitlesModel] = []
    
    var _addPhotoOptionsPopoverController:AddPhotosPopoverController?
    var _addPhotoOptionsNC:AddPhotoOptionsNavController?
    
    var selectedPolicyTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.topView.backgroundColor = RAColors.LIGHT_GRAY
        
        // Set the font and text color
        self.alertTitleLabel.textColor = RAColors.GRAY8
        self.alertTypeLabel.textColor = RAColors.GRAY8
        self.alertMessageLabel.textColor = RAColors.GRAY8

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.alertTitleLabel.font = RAFonts.HELVETICA_NEUE_BOLD_20
            self.alertTypeLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_16
            self.alertMessageLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_16
        } else {
            self.alertTitleLabel.font = RAFonts.HELVETICA_NEUE_MEDIUM_18
            self.alertTypeLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_13
            self.alertMessageLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_13
        }
        
        
        // clear
        self.alertTitleLabel.text = ""
        self.alertTypeLabel.text = ""
        self.alertMessageLabel.text = ""
        self.starRate.hidden = true
        
        // Bruce **setup toolbar barButtonItems for iPhone
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            var spacer : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            spacer.width = 8
            self.toolbar.items = [self.photoButton,spacer,self.creditCardButton]
            
        }
        
        loadData()
        
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:RAFonts.HELVETICA_NEUE_MEDIUM_17, NSForegroundColorAttributeName:RAColors.BLUE1], forState: UIControlState.Normal)
    }
    
    func loadData() {
        // load alert detail
        AlertService.getDetailsForAlert(self.alertId, completionHandler: {(alert: AlertModel?, error: NSError?) -> Void in
            
            // assign to alert model
            self.alertDetail = alert
            dispatch_async(dispatch_get_main_queue(), {
                // display data on view
                if let category: AlertCategoryModel = alert?.category {
                    self.alertTitleLabel.text = category.subTitle
                    self.alertTitleLabel.sizeToFit()
                    self.alertTypeLabel.text = alert?.policy?.type?.title
                    self.alertTypeLabel.sizeToFit()
                    self.alertMessageLabel.text = alert!.message
                    self.alertMessageLabel.numberOfLines = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ? 1 : 3
                    self.alertMessageLabel.sizeToFit()
                    self.starRate.hidden = false
                    self.starRate.rate = UInt(alert!.rank!)
                    
                    
                    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                        // right view
                        var policyDetailController = UIStoryboard(name: "PolicyDetails", bundle: nil).instantiateInitialViewController() as PolicyDetailTableViewController
                        
                        //Load parent policy in right View
                        //If user has selected 'Universal Life' in Smart List screen, then select 'Univeral Life' in Contact screen also
                        if let client = self.alertDetail?.client {
                            
                            if let products = self.alertDetail?.client?.products {
                                
                                if products.count > 0 {
                                    
                                    for policy in products {
                                    
                                        if alert?.policy?.type?.title == policy.type?.title {
                                            policyDetailController.policyId = policy.id
                                        }

                                    }

                                }
                            }
                        }
                        
                        self.showRightViewController(policyDetailController)
                        
                        var centerDivider :UIView = UIView(frame: CGRectMake(-0.25, 0, 0.5, self.view.frame.size.height))
                        centerDivider.backgroundColor = RAColors.GRAY5
                        policyDetailController.view.addSubview(centerDivider)
                        
                    } else {
                        self.rightView.hidden = true
                    }
                    
                    
                    // left view
                    var alertDetailController = (UIStoryboard(name: "AlertDetails", bundle: nil).instantiateInitialViewController() as UINavigationController).viewControllers[0] as AlertDetailTableViewController
                    alertDetailController.alertId = self.alertId
                    alertDetailController.selectedPolicyTitle = alert?.policy?.type?.title//alert?.policy?.type?.title!
                    alertDetailController.contactViewController = self
                    
                    self.showLeftViewController(alertDetailController) 
                }
            })

        })
    }
    
    func showLeftViewController(controller: UIViewController) {
        if leftViewController != nil {
            leftViewController?.willMoveToParentViewController(nil)
            leftViewController?.view.removeFromSuperview()
            leftViewController?.removeFromParentViewController()
        }
        
        self.addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, leftView.frame.width, leftView.frame.height)
        leftView.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        
        leftViewController = controller
    }
    
    func showRightViewController(controller: UIViewController) {
        if rightViewController != nil {
            rightViewController?.willMoveToParentViewController(nil)
            rightViewController?.view.removeFromSuperview()
            rightViewController?.removeFromParentViewController()
        }
        
        self.addChildViewController(controller)
        controller.view.frame = CGRectMake(0, 0, rightView.frame.width, rightView.frame.height)
        rightView.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        
        rightViewController = controller
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendPhotoTapped(sender: UIBarButtonItem)
    {
        /*
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Choose existing photo", "Take Photo")
        actionSheet.tag = AlertDetailTableViewController.TAG_ACTION_TAKE_PHOTO
        actionSheet.showFromBarButtonItem(sender, animated: true)  // Bruce**
        */
        
        /* Bruce **  Need to be able to set the tintColor of the UIActionSheet button titles.  No way to do this without using the new IOS8 UIAlertController*/
        var actionController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var takePhotoButton = UIAlertAction(title: "Take photo", style: UIAlertActionStyle.Default, handler:{(action: UIAlertAction!) in
            
            // check if camera is available
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true
            {
                self.imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
                
                //B.PHM
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                    self.takePhonePhoto()
                    
                }
                //E.PHM
                
                
                self.imagePickerController.delegate = self
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(self.imagePickerController, animated: true, completion: nil)
                })
            }
            
        })
        
        

        var chooseExistingButton = UIAlertAction(title: "Choose existing photo", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == true {
                    var imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                    imagePickerController.delegate = self
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(imagePickerController, animated: true, completion: nil)
                    })
                }
            }else{
                self._showAddPhotoPopover()
            }
            
            // check if library is available
            
            
            
        })
        
        var cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionController.addAction(chooseExistingButton)
        actionController.addAction(takePhotoButton)
        actionController.addAction(cancelButton)
        
        actionController.popoverPresentationController?.barButtonItem = self.photoButton
        actionController.view.tintColor = RAColors.BLUE1
        actionController.view.tag = AlertDetailTableViewController.TAG_ACTION_TAKE_PHOTO
        
        self.presentViewController(actionController, animated: true, completion: nil)
        
    }
    //B.PHM Custom Photo overlay and actions.
    
    func takePhonePhoto(){
        //PHM Generate custom overlay when taking picture
        self.imagePickerController.showsCameraControls=false
        var customCameraOverlay=UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        customCameraOverlay.backgroundColor=UIColor.clearColor()
        customCameraOverlay.layer.cornerRadius=0
        customCameraOverlay.layer.borderWidth=0
        
        var topBar=UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 43))
        topBar.backgroundColor=UIColor.blackColor().colorWithAlphaComponent(0.6)
        
        var cameraFlashButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        cameraFlashButton.backgroundColor = UIColor.clearColor()
        cameraFlashButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cameraFlashButton.setTitle("Auto", forState: UIControlState.Normal)
        cameraFlashButton.titleLabel?.font = RAFonts.CAMERA_FLASH_TEXT
        cameraFlashButton.frame = CGRectMake(10, 10, 60, 20)
        cameraFlashButton.setImage(UIImage(named: "cameraFlash"), forState: UIControlState.Normal)
        cameraFlashButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cameraFlashButton.tintColor = UIColor.whiteColor()
        cameraFlashButton.imageEdgeInsets = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 45)
        cameraFlashButton.titleEdgeInsets = UIEdgeInsets(top:0, left: -30, bottom: 0, right: 0)
        cameraFlashButton.addTarget(self, action: "changeFlash:", forControlEvents: UIControlEvents.TouchUpInside)
        topBar.addSubview(cameraFlashButton)
        
        var cameraCancelButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        cameraCancelButton.backgroundColor = UIColor.clearColor()
        cameraCancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cameraCancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cameraCancelButton.frame = CGRectMake(self.view.frame.size.width-60, 10, 60, 20)
        cameraCancelButton.addTarget(self, action: "cancelPhonePhoto", forControlEvents: UIControlEvents.TouchUpInside)
        topBar.addSubview(cameraCancelButton)
        cameraCancelButton.titleLabel?.font = RAFonts.CAMERA_CANCEL_TEXT
        
        customCameraOverlay.addSubview(topBar)
        
        var bottomBar=UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height-101.5, UIScreen.mainScreen().bounds.size.width, 101.5))
        bottomBar.backgroundColor=UIColor.blackColor().colorWithAlphaComponent(0.6)
        
        var takePhotoButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        takePhotoButton.backgroundColor = UIColor.clearColor()
        takePhotoButton.setImage(UIImage(named: "cameraCircle"), forState: UIControlState.Normal)
        takePhotoButton.tintColor = UIColor.whiteColor()
        takePhotoButton.frame = CGRectMake((bottomBar.frame.size.width-80)/2, (bottomBar.frame.size.height-80)/2, 80, 80)
        takePhotoButton.addTarget(self.imagePickerController, action: "takePicture", forControlEvents: UIControlEvents.TouchUpInside)
        bottomBar.addSubview(takePhotoButton)
        
        customCameraOverlay.addSubview(bottomBar)
        
        
        var screenSize:CGSize = UIScreen.mainScreen().bounds.size
        var cameraAspectRatio:CGFloat = CGFloat(4.0) / CGFloat(3.0)
        var imageWidth:CGFloat = floor(CGFloat(screenSize.width) * CGFloat(cameraAspectRatio));
        var scale:CGFloat = ceil((screenSize.height / imageWidth) * 10.0) / 10.0;
        
        self.self.imagePickerController.cameraViewTransform = CGAffineTransformMakeScale(scale, scale + 0.23);
        
        self.imagePickerController.cameraOverlayView = customCameraOverlay
        
        //self.imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0.0,40.0)

    }
    
    func changeFlash(sender:UIButton!){
        //PHM Alter flash button
        println(self.imagePickerController.cameraFlashMode)
        
        if(self.imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashMode.Auto){
            self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            sender.tintColor = UIColor.whiteColor()
            sender.setTitle("Off", forState: UIControlState.Normal)
        }
        else if(self.imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashMode.Off){
            self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.On
            sender.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            sender.tintColor = UIColor.yellowColor()
            sender.setTitle("On", forState: UIControlState.Normal)
        }
        else if(self.imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashMode.On){
            self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Auto
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            sender.tintColor = UIColor.whiteColor()
            sender.setTitle("Auto", forState: UIControlState.Normal)
        }
        sender.titleLabel?.font = RAFonts.CAMERA_FLASH_TEXT
    }
    
    func completePhonePhoto(){
        //PHM dismiss picture confimation overlay
        self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        //PHM show alert
        self._showPhotoSentConfirmation()
    }
    
    func cancelPhonePhoto(){
        self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    //E.PHM Custom Photo overlay and actions.
    
    //show options popover
    func _showAddPhotoPopover()
    {
        var storyboard:UIStoryboard = UIStoryboard(name: "AddPhotoOptions", bundle: nil)
        self._addPhotoOptionsNC = storyboard.instantiateInitialViewController() as? AddPhotoOptionsNavController
        (self._addPhotoOptionsNC!.viewControllers[0] as AddPhotoOptionsViewController).delegate = self
        self._addPhotoOptionsPopoverController = AddPhotosPopoverController(contentViewController: self._addPhotoOptionsNC!)
        var view:UIView = self.photoButton.valueForKey("view") as UIView
        var frame:CGRect = CGRect(x: view.frame.origin.x-2, y: self.toolbar.frame.origin.y+10, width: view.frame.width, height: view.frame.height)
        self._addPhotoOptionsPopoverController!.presentPopoverFromRect(frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Down, animated: true)
        
        //skip the popover options, go directly to photos library
        self._addPhotoOptionsNC?.showPhotosLibrary(self)
        self._addPhotoOptionsPopoverController?.setPopoverContentSize(CGSizeMake(275, 325), animated: false)
    }
    
    func _showPictureConfirmation(image:UIImage){
        //  var storyboard:UIStoryboard = UIStoryboard(name: "AddPhotosConfirm", bundle: nil)
        
        var photoConfirmVC = self.storyboard?.instantiateViewControllerWithIdentifier("pictureSendConfirm") as ConfirmPhotoViewController
        photoConfirmVC.image = image
        photoConfirmVC.delegate = self
        //  self.navigationController?.pushViewController(photoConfirmVC, animated: true)
        
        self.presentViewController(photoConfirmVC, animated: true, completion: nil)
    }
    
    
    //handle when a photo has been captured from the camera
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info:NSDictionary)
    {
        //PHM Removed since we needed to allow the custom picture confirmation.
        //picker.dismissViewControllerAnimated(true, completion: nil)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            if (picker.sourceType == UIImagePickerControllerSourceType.Camera) {
                //Custom Confirmation screen when using iphone and camera. This is to add custom re-take and "Send to Office buttons"
                var customCameraOverlay=UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
                customCameraOverlay.backgroundColor=UIColor.blackColor()
                customCameraOverlay.layer.cornerRadius=0
                customCameraOverlay.layer.borderWidth=0
                    
                var imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.height * (3/4), self.view.frame.size.height))
                var customImage:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
                imageView.image = customImage
                customCameraOverlay.addSubview(imageView)
                
                var bottomBar=UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height-51.5, UIScreen.mainScreen().bounds.size.width, 51.5))
                bottomBar.backgroundColor=UIColor.blackColor().colorWithAlphaComponent(0.6)
                
                var reTakePhotoButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                reTakePhotoButton.backgroundColor = UIColor.clearColor()
                reTakePhotoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                reTakePhotoButton.setTitle("Re-Take", forState: UIControlState.Normal)
                reTakePhotoButton.titleLabel?.font = RAFonts.CAMERA_RETAKE_PHOTO_TEXT
                reTakePhotoButton.frame = CGRectMake(15.0, 0, 80, 51.5)
                reTakePhotoButton.addTarget(self, action: "takePhonePhoto", forControlEvents: UIControlEvents.TouchUpInside)
                bottomBar.addSubview(reTakePhotoButton)

                
                var sendPhotoButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                sendPhotoButton.backgroundColor = UIColor.clearColor()
                sendPhotoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                sendPhotoButton.setTitle("Send to Office", forState: UIControlState.Normal)
                sendPhotoButton.titleLabel?.font = RAFonts.CAMERA_SEND_PHOTO_TEXT
                sendPhotoButton.frame = CGRectMake(bottomBar.frame.size.width-125, 0, 110, 51.5)
                sendPhotoButton.addTarget(self, action: "completePhonePhoto", forControlEvents: UIControlEvents.TouchUpInside)
                bottomBar.addSubview(sendPhotoButton)
                
                customCameraOverlay.addSubview(bottomBar)
                
                
                picker.cameraOverlayView = customCameraOverlay

            }
            else {
                //PHM added dismiss here since removed above
                picker.dismissViewControllerAnimated(true, completion: nil)
                let image = info[UIImagePickerControllerOriginalImage] as UIImage
                self._showPictureConfirmation(image)
            }

        }else{
            //dismiss camera/photo picker and close popover
            
            //show alert
            //PHM added dismiss here since removed above
            picker.dismissViewControllerAnimated(true, completion: nil)
            self._showPhotoSentConfirmation()
        }
        
    }
    
    
    //show confirmation alert that the phoeo has been uploaded
    func _showPhotoSentConfirmation()
    {
        var title_attrs = [NSFontAttributeName : RAFonts.HELVETICA_NEUE_MEDIUM_16]
        var titleString = NSMutableAttributedString(string:"Picture sent successfully", attributes:title_attrs)
        
        var msg_attrs = [NSFontAttributeName : RAFonts.HELVETICA_NEUE_REGULAR_14]
        var msgString = NSMutableAttributedString(string:"The picture has been sent successfully to your office at office_email@company.com.", attributes:msg_attrs)
       
        var strLen = msgString.length - 57
        
        msgString.addAttribute(NSFontAttributeName, value: RAFonts.HELVETICA_NEUE_MEDIUM_14, range: NSMakeRange(57, strLen))
        
//        msgString.addAttribute(NSFontAttributeName, value: RAFonts.HELVETICA_NEUE_MEDIUM_14, range: NSMakeRange(57,msgString.length-2))
        
        let alertController = UIAlertController(title: "sample", message: "sample", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.setValue(titleString, forKey: "attributedTitle")
        
        alertController.setValue(msgString, forKey: "attributedMessage")
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Remove UIActionSheetDelegate method when UIAlertController fully implemented
    // MARK: - Action Sheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch actionSheet.tag {
        case AlertDetailTableViewController.TAG_ACTION_TAKE_PHOTO:
            //take photo
            if buttonIndex == 2 {
                // check if camera is available
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true {
                    var imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
                    imagePickerController.delegate = self
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(imagePickerController, animated: true, completion: nil)
                    })
                }
                // choose Existing
            } else if buttonIndex == 1 {
                // check if library is available
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == true {
                    var imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                    imagePickerController.delegate = self
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(imagePickerController, animated: true, completion: nil)
                    })
                }
            }
        case AlertDetailTableViewController.TAG_ACTION_SHARE:
            // TODO: share to delegate
            return
        default:
            // nop
            return
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        self.chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage
        
        self.chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage
        
        let library = ALAssetsLibrary()
        
        var imageData : NSData = UIImageJPEGRepresentation(self.chosenImage,1.0)
        
        //check size of the image and prompt user if the size is beyond limit
        var imageSize : Int = imageData.length
        
        println("Image size :  \(imageData.length)")
        
        // println("Image size :  \(imageData.length/(1024*1024))")
        
        if(imageSize > Constants.IMAGE_SIZE_LIMIT){
            var alertView = UIAlertView(title: Constants.ALERT_TITLE, message: "The image size is huge. Consider uploading a lower resolution image", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "OK")
            alertView.tag = TAG_ALERT_OK
            alertView.delegate = self
            alertView.show()
            return
        }
        
        let url = NSURL(string: "http://mcocihs.mfss.sl.edst.ibm.com/ContentManager/FileHandler")
        
        // create the request & response
        var request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        var response: NSURLResponse?
        var error: NSError?
        
        // create some JSON data and configure the request
        //     let jsonString = "json=[{\"str\":\"Hello\",\"num\":1},{\"str\":\"Goodbye\",\"num\":99}]"
        
        var httpHeader = _buildHttpHeader()
        
        for (field, value) in httpHeader {
            request.setValue(value, forHTTPHeaderField: field)
        }
        request.HTTPBody = imageData
        request.HTTPMethod = "POST"
        
        request.setValue("image/jpeg\r\n\r\n", forHTTPHeaderField: "Content-Type")
        
        
        //**Synchronous code*******//
        // send the request
        
        //         NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        //
        //        let httpResponse = response as? NSHTTPURLResponse
        //
        //        // look at the response
        //        if(httpResponse?.statusCode == 200) {
        //            println("HTTP response: \(httpResponse?.statusCode)")
        //            UIAlertView(title: "", message: "Image uploaded successfully", delegate: nil, cancelButtonTitle: "OK").show()
        //        } else {
        //            println("No HTTP response: \(httpResponse?.statusCode)")
        //             UIAlertView(title: "", message: "Image upload failed", delegate: nil, cancelButtonTitle: "OK").show()
        //        }
        //
        
        
        // ************async code*******//
        //  let request:NSURLRequest = NSURLRequest(URL:url)
        
        var queue = NSOperationQueue()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response, data, error) -> Void in
            
            var err: NSError? = error
            var httpResponse = response as NSHTTPURLResponse?
            println("HTTP response: \(httpResponse?.statusCode)")
            
            if httpResponse?.statusCode == 200 {
                UIAlertView(title: "Picture sent sucessfully", message: "The picture has been sent successfully to your office at Client Since 2010 office_email@company.com.", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                // err = NSError(domain: "", code: httpResponse!.statusCode, userInfo: nil)
                
                println(error)
                UIAlertView(title: "", message: "Image upload failed", delegate: nil, cancelButtonTitle: "OK").show()
            }
            
            //  println("data: "+NSString(data: data, encoding: NSUTF8StringEncoding)!)
            
            dispatch_async(dispatch_get_main_queue(), {()->Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if err != nil {
                    
                    println("Error: Server connect Error.\n\(err?.description)")
                    
                }
                
            })
            
        })
        
        // ************end of async code*******//
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.chosenImage = image
    }
    
    func _buildHttpHeader() -> [String: String]
    {
        return [ "MFIOS_INDUSTRY": "Telco", "MFIOS_FOLDER_NAME" : "123456", "MFIOS_FILE_NAME": "123456_ipadDoc.jpeg"]
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: - Bar Button Action
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func finish(sender: UIBarButtonItem) {
        // In iPhone show Action Sheet
        // In iPad show PopOver
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            self.spinner.startAnimatingOnView(self.view)
            
            // get Finish Titles from service
            AlertService.finishTitles(Constants.DEFAULT_AGENT_ID, completionHandler: {(finishTitles: [FinishTitlesModel]?, error: NSError?) -> Void in
                
                self.finishTitlesList = finishTitles!
                // hide loading
                self.spinner.stopAnimatingOnView()
                
                let alertController = UIAlertController(title: nil, message: "Is the alert completed?", preferredStyle: .ActionSheet)
                
                var action : UIAlertAction = UIAlertAction()
                for finishListItem in self.finishTitlesList {
                    let finishTitle = finishListItem as FinishTitlesModel
                    
                    switch finishTitle.level {
                    case 1:
                        action = UIAlertAction(title: finishTitle.title, style: .Default) { (action) in
                            self.markAsComplete(action.title,isDestructive: false)
                        }
                        break
                    case 2:
                        action = UIAlertAction(title: finishTitle.title, style: .Destructive) { (action) in
                            
                            self.markAsComplete(action.title,isDestructive: true)
                        }
                        break
                    case 3:
                        
                        action = UIAlertAction(title: finishTitle.title, style: .Default) { (_) in

                            //This is Other....Finish Action
                            let finishNoteNavController: UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.CONTACT_FINSIH_NOTES_NAV) as UINavigationController
                           
                            let finishNoteVc = finishNoteNavController.topViewController as FinishNotesViewController
                            
                            finishNoteVc.alertDetail = self.alertDetail
                            finishNoteVc.alertId = self.alertId
                            finishNoteVc.delegate = self
                            self.presentViewController(finishNoteNavController, animated: true, completion: nil)
                            
                        }
                        break
                    default:
                        action = UIAlertAction(title: finishTitle.title, style: .Default) { (_) in }
                        break
                        
                    }
                    alertController.addAction(action)
                    
                }
                
                //Add Cancel
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
                
                
            })
            
            
        }
        else {
            let navCntrl = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.CONTACT_FINSIHT_NAVCTRL) as UINavigationController
            var finishTableVc:FinishTableViewController = navCntrl.topViewController as FinishTableViewController
            finishTableVc.alertId = self.alertId
            finishTableVc.alertDetail = alertDetail
            finishTableVc.delegate = self
            
            navCntrl.modalPresentationStyle = .Popover
            navCntrl.preferredContentSize   = CGSizeMake(900, 120)
            
            let aPopover =  UIPopoverController(contentViewController: navCntrl)
            
            aPopover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
            
        }
        
        
    }
    @IBAction func collectPaymentBtnTapped(sender: AnyObject) {
        
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                        
            var paymentVc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.PAYMENT_iPHONE) as PaymentViewController
            paymentVc.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            self.presentViewController(paymentVc, animated: true, completion: nil)

        }
        else {
            var paymentVc = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.PAYMENT_iPAD) as PaymentViewController
            paymentVc.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            self.presentViewController(paymentVc, animated: true, completion: nil)
        }
    }
    
    func markAsComplete(note:String, isDestructive:Bool) {
        let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
        var alert:Alert!
        //alert = alertAdapter.getAlertDetail(self.alertId)
        
        alert = alertAdapter.getAlertDetail(alertDetail?.id, categoryId: alertDetail?.category?.id)
        
        if let alertObj = alert {
            //if alertObj.status == "Completed" {
                //If it comes here, something is wrong, as it should not....as alert is finished already
            //}

        }
        else {
            
            //Create Alert Object in DB via CoreData(Entity - Alert)
            
            alert = alertAdapter.createAlert()
            alert.id = NSNumber(integer: self.alertId)
        }
        
        alert.date = NSDate()
        let dateString : String = StringUtils.convertDateToString(alert.date, format: Constants.FINISH_NOTE_DATE)

        alert.status = isDestructive ? "NotCompleted" : "Completed"
        alert.finishNote = dateString + " " + CommonFunc.capitalizeFirstChar(note)
        alert.isDestructive = isDestructive
        
        var category: AlertCategoryModel = alertDetail!.category!
        
        alert.categoryId = NSNumber(integer:category.id)
        alertAdapter.insertAlert()
        self.dismissViewControllerAnimated(true, completion: nil)
        if self.delegate != nil {
            self.delegate?.onContactFinish(self.alertId)
        }
    }
    
    //MARK: FinishNoteDelegate
    func didFinishNote()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.onContactFinish(self.alertId)

    }
    //MARK: - FinishAlertDelegate
    func didFinishAlert() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.onContactFinish(self.alertId)
    }
    
    /**** add photo options delegate methods ****/
    func closeAddPhotoOptions() {
        self._addPhotoOptionsPopoverController?.dismissPopoverAnimated(true)
    }
    
    func showPhotoLibrary() {
        self._addPhotoOptionsNC?.showPhotosLibrary(self)
        self._addPhotoOptionsPopoverController?.setPopoverContentSize(CGSizeMake(275, 325), animated: false)
    }
    
    func showCamera() {
        
    }
    
    /**** photos lib delegate methods ****/
    func photosLibraryOnCancel() {
        self.closeAddPhotoOptions()
    }
    
    func photosLibraryOnMediaSelected(media: CasePhotoModel) {
        self._addPhotoOptionsNC?.showPhotoConfirmation(media, delegate: self)
    }
    
    /**** AddPhotoOptionsCollectionViewControllerDelegate delegate methods ****/
    func onMediaSelected(media: CasePhotoModel) {
        self.photosLibraryOnMediaSelected(media)
    }
    
    /**** AddPhotosConfirmDelegate delegate methods ****/
    func addPhotosConfirmCancelled() {
        self._addPhotoOptionsNC?.back()
    }
    
    func addPhotosConfirmSelected(photo: CasePhotoModel) {
        self.closeAddPhotoOptions()
        self._showPhotoSentConfirmation()
    }
    
    //MARK: - photoLibraryDelegate :  ** abhi
    
    func didSendPhoto() {
        _showPhotoSentConfirmation()
    }
    
}
