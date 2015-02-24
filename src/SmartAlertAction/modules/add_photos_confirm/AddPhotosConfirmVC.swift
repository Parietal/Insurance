//
//  AddPhotosConfirmVC.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-10-17.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import MediaPlayer

protocol AddPhotosConfirmDelegate {
    func addPhotosConfirmCancelled()
    func addPhotosConfirmSelected(photo:CasePhotoModel)
}

class AddPhotosConfirmVC:UIViewController
{
    
    @IBOutlet var imageView:UIImageView!
    
    var delegate:AddPhotosConfirmDelegate?
    
    var _photo:CasePhotoModel?
    var _assetsLib:ALAssetsLibrary? //for some reason, need to store reference to avoid crash
    var _videoController:MPMoviePlayerController?
    var _autoPlay:Bool = true //used to make sure
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor.blackColor()
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self._photo != nil
        {
            CasePhotoModel.isVideo(self._photo!.file, completionHandler: {(isVideo:Bool, asset:ALAsset?) -> Void in
                
                isVideo ? self._showVideo(self._photo!) : self._showImage(self._photo!.file)
                
            })
        }
    }
    
    //load image preview from asset library
    func _showImage(file:String)
    {
        //hide video
        if self._videoController != nil {
            self._videoController?.view.hidden = true
        }
        
        if NSString(string: file).rangeOfString("assets-library:").location == NSNotFound {
            self.imageView.image = UIImage(named: file)
        }
        else
        {
            self._assetsLib = ALAssetsLibrary()
            var url:NSURL = NSURL(string: file)!
            self._assetsLib!.assetForURL(url, resultBlock: {(asset:ALAsset!) -> Void in
                
                if asset != nil {
                    var thumbnail:UIImage = UIImage(CGImage: asset.thumbnail().takeUnretainedValue())!
                    self.imageView.image = thumbnail
                }
                
                }, failureBlock: nil)
        }
    }
    
    //start playing a video
    func _showVideo(media:CasePhotoModel)
    {
        //hide image
        self.imageView.hidden = true
        
        if self._videoController == nil
        {
            self._videoController = MPMoviePlayerController()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "_onVideoExitFullscreen", name: MPMoviePlayerWillExitFullscreenNotification, object: self._videoController)
        }
        
        self._videoController?.contentURL = NSURL(string: media.file)
        self._videoController?.prepareToPlay()
        self._videoController?.movieSourceType = CasePhotoModel.isFromAssetLibrary(media.file) ?  MPMovieSourceType.File : MPMovieSourceType.Streaming
        self._videoController?.fullscreen = false
        self._videoController?.shouldAutoplay = false
        self._videoController!.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(self._videoController!.view)
        
        if self._autoPlay {
            self._videoController?.play()
        }
    }
    
    //need to reset video when exiting back from full screen
    func _onVideoExitFullscreen()
    {
        if self._videoController != nil {
            self._autoPlay = false
        }
    }
    
    func setConfirmPhoto(photo:CasePhotoModel) {
        self._photo = photo
    }
    
    @IBAction func cancel() {
        self._unload()
        self.delegate?.addPhotosConfirmCancelled()
    }
    
    @IBAction func usePhoto() {
        self._unload()
        self.delegate?.addPhotosConfirmSelected(self._photo!)
    }
    
    func _unload() {
        self._videoController = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}