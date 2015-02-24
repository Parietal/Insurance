//
//  AuthenticationViewController.swift
//  LoginDemo
//
//  This view controller flips between
//  1) authorizationRootViewController - the Login UI
//  2) securedRootViewController - the first scene of the app (once authentication is complete)
//
//  Created by Ian Craigmile on 6 November 2014, based on work by Jeremy Koch
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit

extension UIViewController {
    // loop through the view controller hierarchy looking for the authentication controller
    var authenticationController: AuthenticationController? {
        get {
            var parentViewController = self.parentViewController
            while parentViewController != nil {
                if parentViewController is AuthenticationController {
                    return (parentViewController as AuthenticationController) // found it
                } else {
                    parentViewController = parentViewController?.parentViewController
                }
            }
            return nil
        }
    }
}

class AuthenticationController: UIViewController {
    var authorizationRootViewController: UIViewController!
    var securedRootViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authorizationRootViewController = UIStoryboard(name: "LoginPlaceHolder", bundle: nil).instantiateInitialViewController() as UIViewController
        
        self.addChildViewController(authorizationRootViewController)
        view.addSubview(authorizationRootViewController.view)
        authorizationRootViewController.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("AuthenticationController: didReceiveMemoryWarning()")
    }
    
    // user credentials have been authenticated on a client's enterprise system
    func loginAuthenticated() {
        var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var mainVC: UIViewController = mainStoryboard.instantiateInitialViewController() as UIViewController
        self.securedRootViewController = mainVC
        
        self.flipFromViewController(
            self.authorizationRootViewController,
            toController: self.securedRootViewController,
            options: UIViewAnimationOptions.TransitionFlipFromLeft)
    }
    
    func signOut() {
        flipFromViewController(
            securedRootViewController,
            toController: authorizationRootViewController,
            options: UIViewAnimationOptions.TransitionFlipFromRight)
        
        self.securedRootViewController = nil
    }
    
    private func flipFromViewController(fromController: UIViewController, toController: UIViewController, options: UIViewAnimationOptions) {
        toController.view.frame = fromController.view.bounds
        self.addChildViewController(toController)
        fromController.willMoveToParentViewController(nil)
        
        self.transitionFromViewController(
            fromController,
            toViewController: toController,
            duration: 0.75,
            options: options,
            animations: {}) { (finished) -> Void in
                fromController.removeFromParentViewController()
                toController.didMoveToParentViewController(self)
        }
    }
}
