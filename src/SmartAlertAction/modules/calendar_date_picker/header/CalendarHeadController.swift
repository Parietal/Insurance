//
//  CalendarHeadController.swift
//  CalendarDatePicker
//
//  Created by Paul Yuan on 2014-11-17.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class CalendarHeadController:UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    
    private class var CELL_REUSE_ID : String { return "headerCell" }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //register cell nib
        var nib:UINib = UINib(nibName: "CalendarHeaderCell", bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: CalendarHeadController.CELL_REUSE_ID)
        
        self.collectionView?.backgroundColor = CalendarConstants.COLOR_WEEK_HEADER
        self.collectionView?.bounces = false
        self.collectionView?.scrollEnabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //draw bottom border
        let bottomBorder:CALayer = CALayer()
        bottomBorder.backgroundColor = CalendarConstants.COLOR_GREY.CGColor
        bottomBorder.frame = CGRectMake(0, self.view.frame.height, self.collectionView!.frame.width, 0.5)
        self.view.layer.addSublayer(bottomBorder)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CalendarConstants.DAYS_OF_WEEK.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let w:CGFloat = self.view.frame.width / CGFloat(CalendarConstants.DAYS_OF_WEEK.count)
        let h:CGFloat = self.view.frame.height
        return CGSizeMake(w, h)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell:CalendarHeaderCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(CalendarHeadController.CELL_REUSE_ID, forIndexPath: indexPath) as CalendarHeaderCell
        cell.update(indexPath.row)
        return cell
    }
    
}