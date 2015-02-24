//
//  ConfirmPhotoViewController.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 05/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

//delegate to handle send photo action
import UIKit
protocol photoLibraryDelegate {
    func didSendPhoto()
}
class ConfirmPhotoViewController: UIViewController {
    
    var delegate: photoLibraryDelegate?
    var image:UIImage!
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func sendBtnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if self.delegate != nil {
            self.delegate?.didSendPhoto()
        }

    }
    
    @IBAction func cancelBtnTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if image != nil {
            //PHM added scaleaspectfit to have image fit in screen.
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.image = image
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}
