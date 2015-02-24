//
//  AddPhotoOptionsNavController.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-10-17.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class AddPhotoOptionsNavController:UINavigationController
{
    
    func showPhotosLibrary(delegate:PhotosLibraryDelegate?)
    {
        var storyboard:UIStoryboard = UIStoryboard(name: "PhotosLibrary", bundle: nil)
        var controller:PhotosLibraryCollectionViewController = storyboard.instantiateInitialViewController() as PhotosLibraryCollectionViewController
        controller.delegate = delegate
        self.pushViewController(controller, animated: false)
    }
    
    func showPhotoConfirmation(photo:CasePhotoModel, delegate:AddPhotosConfirmDelegate)
    {
        var storyboard:UIStoryboard = UIStoryboard(name: "AddPhotosConfirm", bundle: nil)
        var controller:AddPhotosConfirmVC = storyboard.instantiateInitialViewController() as AddPhotosConfirmVC
        controller.delegate = delegate
        controller.setConfirmPhoto(photo)
        self.pushViewController(controller, animated: true)
    }
    
    func back() {
        self.popViewControllerAnimated(true)
    }
    
}