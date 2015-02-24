//
//  AddPhotoOptionsCollectionViewController.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-10-15.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

protocol AddPhotoOptionsCollectionViewControllerDelegate {
    func onMediaSelected(media:CasePhotoModel)
}

class AddPhotoOptionsCollectionViewController:UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    
    let MAX_NUM_RECENT_ASSETS:Int = 5
    let REUSE_IDENTIFIER_CELL = "Cell"
    
    var _recentAssets:[CasePhotoModel] = [CasePhotoModel]()
    var _assetsLib:ALAssetsLibrary? //for some reason, need to store reference to avoid crash
    var delegate:AddPhotoOptionsCollectionViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.clearColor()
        
        self._getRecentAssets({(assets:[ALAsset]) -> Void in
            self._recentAssets = self._sortAssets(assets)
            self.collectionView?.reloadData()
        })
    }
    
    //sort the assets by descending date and pick just the most recent ones
    //and convert to CasePhotoModel objects
    func _sortAssets(assets:[ALAsset]) -> [CasePhotoModel]
    {
        var recentAssets:[ALAsset] = [ALAsset](assets)
        
        recentAssets.sort({
            var d0:NSDate = ($0 as ALAsset).valueForProperty(ALAssetPropertyDate) as NSDate
            var d1:NSDate = ($1 as ALAsset).valueForProperty(ALAssetPropertyDate) as NSDate
            return d0.compare(d1) == NSComparisonResult.OrderedDescending
        })
        
        if recentAssets.count > MAX_NUM_RECENT_ASSETS
        {
            for var i:Int=recentAssets.count-1; i>MAX_NUM_RECENT_ASSETS-1; i-- {
                recentAssets.removeAtIndex(i)
            }
        }
        
        //convert to CasePhotoModel objects because reference to ALAssetLibrary will expire
        var photos:[CasePhotoModel] = [CasePhotoModel]()
        for var i:Int=0; i<recentAssets.count; i++ {
            var asset:ALAsset = recentAssets[i]
            
            //same url for file and thumb, because thumb can be retrieved from file
            var file:String = asset.defaultRepresentation().url()!.absoluteString!
            var thumb:String = asset.defaultRepresentation().url()!.absoluteString!
            var dimension:CGSize = asset.defaultRepresentation().dimensions()
            var orientation:Int = dimension.height > dimension.width ? CasePhotoModel.ORIENTATION.Portrait.rawValue : CasePhotoModel.ORIENTATION.LANDSCAPE.rawValue
            var dict:NSDictionary = NSDictionary(objects: [file, thumb, orientation], forKeys: ["file", "thumb", "orientation"])
            
            var photo:CasePhotoModel = CasePhotoModel(dictionary: dict)
            photos.append(photo)
        }
        return photos
    }
    
    //retrieve the recent assets
    func _getRecentAssets(completionHandler: (assets:[ALAsset]) -> Void)
    {
        var assets:[ALAsset] = [ALAsset]()
        self._assetsLib = ALAssetsLibrary()
        self._assetsLib!.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: {(group:ALAssetsGroup?, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            
            
                if group != nil
                {
                    group?.enumerateAssetsUsingBlock({(result:ALAsset?, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                        
                        if result != nil {
                            assets.append(result!)
                            result?.valueForProperty(ALAssetPropertyDate).compare(NSDate()) == NSComparisonResult.OrderedDescending
                        }
                        
                    })
                }
            
                completionHandler(assets: assets)
            
            }, failureBlock: {(error:NSError?) -> Void in
                println(error)
        })
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self._recentAssets.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var reuseIdentifier = REUSE_IDENTIFIER_CELL
        var cell:PhotosCollectionViewThumb = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewThumb
        
        var photo:CasePhotoModel = self._recentAssets[indexPath.row]
        cell.update(photo)
        
        return cell;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self._selectCell(indexPath)
        
        var media:CasePhotoModel = self._recentAssets[indexPath.row]
        self.delegate?.onMediaSelected(media)
    }
    
    //deselect all cells and select a cell
    func _selectCell(indexPath:NSIndexPath?)
    {
        //deselect all cells
        var cells:[PhotosCollectionViewThumb] = self.collectionView?.visibleCells() as [PhotosCollectionViewThumb]
        for i in 0..<cells.count {
            var cell:PhotosCollectionViewThumb = cells[i]
            cell.onDeselected()
        }
        
        //change the state of the selected cell
        if indexPath != nil {
            var cell:PhotosCollectionViewThumb = self.collectionView?.cellForItemAtIndexPath(indexPath!) as PhotosCollectionViewThumb
            cell.onSelected()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
}