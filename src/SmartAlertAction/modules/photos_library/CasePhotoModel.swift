
//
//  CasePhotoModel.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-09-17.
//  Copyright (c) IBM Corporation. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class CasePhotoModel
{
    
    enum ORIENTATION:Int {
        case LANDSCAPE
        case Portrait
    }
    
    var file:String = ""
    var thumb:String = ""
    var orientation:Int = CasePhotoModel.ORIENTATION.LANDSCAPE.rawValue
    
    required init(dictionary:NSDictionary) {
        self.file = dictionary["file"] as String
        self.thumb = dictionary["thumb"] as String
        
        if dictionary["orientation"] != nil {
            self.orientation = dictionary["orientation"] as Int
        }
    }
    
    init(file:String) {
        self.file = file
        self.thumb = file
    }
    
    func serialize() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary["file"] = self.file
        dictionary["thumb"] = self.thumb
        dictionary["orientation"] = self.orientation
        return dictionary
    }
    
    //check to see if media file is a supported video
    class func isVideo(file:String, completionHandler: (isVideo:Bool, asset:ALAsset?) -> Void)
    {
        var video:Bool = false
        
        //if file is from test json data
        if !self.isFromAssetLibrary(file)
        {
            let videoExt:[String] = ["mp4", "m4v", "mov"]
            var arr:[String] = file.componentsSeparatedByString(".")
            if arr.count > 0 {
                var fileExt:String = arr[arr.count - 1]
                for i in 0..<videoExt.count {
                    var ext:String = videoExt[i]
                    if fileExt.caseInsensitiveCompare(ext) == NSComparisonResult.OrderedSame {
                        video = true
                        break
                    }
                }
            }
            
            completionHandler(isVideo: video, asset: nil)
        }
        else
        {
            var assetsLib:ALAssetsLibrary = ALAssetsLibrary()
            var url:NSURL = NSURL(string: file)!
            assetsLib.assetForURL(url, resultBlock: {(asset:ALAsset!) -> Void in
                
                if asset != nil {
                    video = asset.valueForProperty(ALAssetPropertyType).isEqualToString(ALAssetTypeVideo)
                    completionHandler(isVideo: video, asset: asset)
                }
                
                }, failureBlock: nil)
        }
    }
    
    //check to see if media file is from the asset library
    class func isFromAssetLibrary(file:String) -> Bool {
        return NSString(string: file).rangeOfString("assets-library:").location != NSNotFound
    }
    
}