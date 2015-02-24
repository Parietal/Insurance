//
//  PhotosCollectionViewThumb.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-09-20.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class PhotosCollectionViewThumb:UICollectionViewCell
{
    
    @IBOutlet var thumbImage:UIImageView?
    @IBOutlet var thumbIcon:UIImageView?
    @IBOutlet var thumbLabel:UILabel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //update the view with the model
    func update(model:CasePhotoModel?)
    {
        CasePhotoModel.isVideo(model!.file, completionHandler: {(isVideo:Bool, asset:ALAsset?) -> Void in
            
            self.thumbIcon?.hidden = !isVideo
            self.thumbLabel?.hidden = !isVideo
            self._updateThumbnail(model!.thumb)
            self.onDeselected()
            
            if isVideo
            {
                var time:String = "2:34" //static text for videos from project
                if asset != nil {
                    var value:Double = asset!.valueForProperty(ALAssetPropertyDuration).doubleValue
                    var interval:NSTimeInterval = value
                    var date:NSDate = NSDate(timeIntervalSince1970: interval)
                    var formatter:NSDateFormatter = NSDateFormatter()
                    formatter.dateFormat = "mm:ss"
                    time = formatter.stringFromDate(date)
                }
                
                self.thumbLabel?.text = time
            }
            
        })
    }
    
    //update thumbnail image
    //check to see if image is from ios project or saved onto device
    func _updateThumbnail(file:String)
    {
        if NSString(string: file).rangeOfString("assets-library:").location == NSNotFound {
            self.thumbImage?.image = UIImage(named: file)
        }
        else
        {
            var assetsLib:ALAssetsLibrary = ALAssetsLibrary()
            var url:NSURL = NSURL(string: file)!
            assetsLib.assetForURL(url, resultBlock: {(asset:ALAsset!) -> Void in
                
                if asset != nil {
                    var thumbnail:UIImage = UIImage(CGImage: asset.thumbnail().takeUnretainedValue())!
                    self.thumbImage?.image = thumbnail
                }
                
                }, failureBlock: nil)
        }
    }
    
    func animate()
    {
        self.alpha = 0
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in self.alpha = 1.0}, completion: {(finished:Bool) -> Void in })
    }
    
    //set styles for the subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clearColor()
        
        self.thumbImage?.contentMode = UIViewContentMode.ScaleAspectFit
        self.thumbLabel?.font = UIFont.systemFontOfSize(10)
        self.thumbLabel?.textAlignment = NSTextAlignment.Right
        self.thumbIcon?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.thumbIcon?.image = UIImage(named: "icon_video_white")
        self.thumbLabel?.textColor = UIColor.whiteColor()
    }
    
    //handler for when cell is selected
    func onSelected() {
        //self.thumbIcon?.image = UIImage(named: "icon_video_black")
        //self.thumbLabel?.textColor = UIColor.blackColor()
        self.thumbImage?.alpha = 0.5
    }
    
    //handler for when cell is deselected
    func onDeselected() {
        //self.thumbIcon?.image = UIImage(named: "icon_video_white")
        //self.thumbLabel?.textColor = UIColor.whiteColor()
        self.thumbImage?.alpha = 1
    }
    
}