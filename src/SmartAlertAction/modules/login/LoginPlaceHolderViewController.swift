//
//  LoginPlaceHolderViewController.swift
//  SmartAlertAction
//
//  A placeholder for the Login UI (which is implemented in the Login framework)
//  Created by Abhilasha on 04/02/15.
//  Copyright (c) 2015 IBM Corporation. All rights reserved.
//


import UIKit
import Login

class LoginPlaceHolderViewController: UIViewController, LoginDelegate {
    
    var loginViewController: LoginViewController? = nil
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // create the UI using the Login framework
        self.loginViewController = Login.createLoginViewControllerWithDelegate(self)
        
        // add the Login UI to this view controller
        self.addChildViewController(self.loginViewController!)
        view.addSubview(self.loginViewController!.view)
        self.loginViewController!.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("LoginPlaceHolderViewController: didReceiveMemoryWarning()")
    }
    
    // MARK: LoginDelegate protocol
    
    // The UI has been loaded by the Login framework. The UI is now ready to be customised.
    func loginViewControllerLoaded() {
        // default values and whether a password is required (for demo apps only)
        Login.specifyDefaultUserID(self.loginViewController, defaultUserID: "testuser")
        Login.specifyDefaultPassword(self.loginViewController, defaultPassword: "testuser")
        Login.specifyPasswordRequired(self.loginViewController, passwordRqd: false)
        
        let fwkBndle = NSBundle(identifier: "com.ibm.mobilefirst.LoginDemo")
//        let appTitle = NSLocalizedString("AppTitle", bundle: fwkBndle!, value: "Retention", comment: "This is the title of the app as displayed in the login screen")
            let appTitle = "Retention"
        // appearance (colors)
        Login.specifyScreenBackgroundColor(self.loginViewController, rqdColor: RAColors.LOGIN_BACKGROUND_COLOR)
        Login.specifyScreenButtonsColor(self.loginViewController, rqdColor: UIColor.whiteColor())
        Login.specifyVersionLabelColor(self.loginViewController, rqdColor: UIColor.whiteColor())
        Login.specifyHeadingLabelText(self.loginViewController, ttl:appTitle)
        Login.specifyFormBackgroundColor(self.loginViewController, rqdColor: UIColor.whiteColor())
        Login.specifyRememberNameLabelColor(self.loginViewController, rqdColor: UIColor.blackColor())
        Login.specifyRememberSwitchColor(self.loginViewController, rqdColor: RAColors.LOGIN_BACKGROUND_COLOR)
        Login.specifySignInButtonTextColor(self.loginViewController, rqdColor: UIColor.whiteColor())
        Login.specifySignInButtonBackgroundColor(self.loginViewController, rqdColor: RAColors.LOGIN_BACKGROUND_COLOR)
        Login.specifySpinnerColor(self.loginViewController, rqdColor: UIColor.orangeColor())
        
        // always set this to true, we want to use Touch ID if it is available. The device Touch ID capabilility is checked
        // by the Login framework
        Login.specifyTouchIDEnabled(self.loginViewController, enabled: true)
    }
    
    // the user id and password have been captured by the Login framework
    func capturedLoginCredentials(userName: String, password: String) {
        Login.saveCredentialsInKeychain(self.loginViewController)
        
        // In a client's application we would do some environment specific authentication here. There are a variety of authentication
        // mechanisms in use and this is likely to be client specific.
        
        // For the purpose of this demonstration we are assuming that the authentication with the client's enterprise back end
        // system has been completed.
        self.authenticationController?.loginAuthenticated() // start the app
    }
    
    // the user id and password were retrieved from the iOS keychain (by the Login framework) as a result of the user using Touch ID
    func retrievedLoginCredentialsFromKeychain(userName: String, password: String) {
        // In a client's application we would do some environment specific authentication here. There are a variety of authentication
        // mechanisms in use and this is likely to be client specific.
        
        // For the purpose of this demonstration we are assuming that the authentication with the client's enterprise back end
        // system has been completed.
        self.authenticationController?.loginAuthenticated()
    }
    
}


