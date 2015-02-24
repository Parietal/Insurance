//
//  EditDelegatesViewController.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-11-24.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class EditDelegatesViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, AgentCollectionViewCellDelegate, AllAgentsViewControllerDelegate
{
    
    class private var CELL_REUSE_ID : String { return "Cell" }
    class private var ALL_AGENTS_POPOVER_SIZE : CGSize { return CGSizeMake(300, 700) }
    
    @IBOutlet var collectionView:UICollectionView?
    @IBOutlet var instructionLabel:UILabel?
    
    private var mode:Int = Constants.DELEGATES_MODE.NORMAL.rawValue {
        didSet {
            self.onModeSet(self.mode)
        }
    }
    
    private var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    private var agentList:[AgentModel] = [AgentModel]()
    private var popoverController:UIPopoverController? //keep reference for the popover controller for this view

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.instructionLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        self.instructionLabel?.textColor = RAColors.GRAY5
        self.instructionLabel?.textAlignment = NSTextAlignment.Center
        
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.automaticallyAdjustsScrollViewInsets = false //to remove extra space at the top of collectionview scroller
        
        //add long press gesture recognizer
        let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "onCellLongPress:")
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        longPress.cancelsTouchesInView = false
        self.collectionView?.addGestureRecognizer(longPress)
        
        //add touch up/down gesture recognizer
        let tap:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "onCellTap:")
        tap.minimumPressDuration = 0
        tap.delaysTouchesBegan = true
        tap.delegate = self
        tap.cancelsTouchesInView = false
        self.collectionView?.addGestureRecognizer(tap)
        
        //register delegate cell
        self.collectionView?.registerClass(AgentCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: EditDelegatesViewController.CELL_REUSE_ID)
        
        //update view for default mode
        self.onModeSet(self.mode)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)

        // temporary solution to modify list of agents in memory for iPhone
        // get candidates from service only when list hasnt been loaded
        if self.agentList.count == 0
        {
            self.spinner.startAnimatingOnView(self.view)
            DelegateService.getAllCandiates({ (agents:[AgentModel]?, error:NSError?) -> Void in
                
                if let agents = agents {
                    self.agentList = agents
                    self.collectionView?.reloadData()
                }

                // hide loading
                self.spinner.stopAnimatingOnView()
            })
        }

        let nc:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "onPause", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        nc.addObserver(self, selector: "keyboardDismissed", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let nc:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }
    
    //reset to normal mode if put into background
    func onPause() {
        self.mode = Constants.DELEGATES_MODE.NORMAL.rawValue
    }
    
    func keyboardDismissed() {
        self.popoverController?.popoverContentSize = EditDelegatesViewController.ALL_AGENTS_POPOVER_SIZE
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.agentList.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            return 5
        }
        else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            return UIEdgeInsetsMake(0, 50, 30, 50)
        }
        else {
            return UIEdgeInsetsMake(0, 40, 30, 25)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(120, 120)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Configure the cell
        
        var cell:AgentCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(EditDelegatesViewController.CELL_REUSE_ID, forIndexPath: indexPath) as AgentCollectionViewCell
        
        let index:Int = indexPath.row
        let agentModel:PersonModel = self.agentList[index]
        cell.agent = agentModel
        cell.mode = self.mode
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let index:Int = indexPath.row
        let agentModel:PersonModel = self.agentList[index]
        println(agentModel)
    }
    
    //deselect all cells and select a cell
    private func highlightCell(indexPath:NSIndexPath?)
    {
        //deselect all cells
        let cells:[AgentCollectionViewCell] = self.collectionView!.visibleCells() as [AgentCollectionViewCell]
        for i in 0..<cells.count {
            var cell:AgentCollectionViewCell = cells[i]
            cell.onDeselected()
        }
        
        //change the state of the selected cell
        if indexPath != nil {
            let cell:AgentCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath!) as AgentCollectionViewCell
            cell.onSelected()
        }
    }
    
    //handle when the mode has been changed
    private func onModeSet(mode:Int)
    {
        let buttonType:UIBarButtonSystemItem = mode == Constants.DELEGATES_MODE.NORMAL.rawValue ? UIBarButtonSystemItem.Add : UIBarButtonSystemItem.Done
        let buttonAction:Selector = mode == Constants.DELEGATES_MODE.NORMAL.rawValue ? "showAgentsList:" : "onEditDone:"
        let rightBarBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: buttonType, target: self, action: buttonAction)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        //update mode for all the cells
        let cells:[AgentCollectionViewCell] = self.collectionView!.visibleCells() as [AgentCollectionViewCell]
        for cell in cells {
            cell.mode = mode
        }
    }
    
    //show the add delegate popover
    func showAgentsList(sender:AnyObject)
    {
        let storyboard:UIStoryboard = UIStoryboard(name: "AllAgents", bundle: nil)
        let nc:UINavigationController = storyboard.instantiateInitialViewController() as UINavigationController
        let vc:AllAgentsViewController = nc.viewControllers[0] as AllAgentsViewController
        vc.delegate = self
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        {
            let view:UIView = sender.valueForKey("view") as UIView
            let frame:CGRect = view.frame
            let rect:CGRect = CGRectMake(frame.origin.x - 7, frame.origin.y + 20, frame.width, frame.height)

            self.popoverController = UIPopoverController(contentViewController: nc)
            self.popoverController!.setPopoverContentSize(EditDelegatesViewController.ALL_AGENTS_POPOVER_SIZE, animated: true)
            self.popoverController!.presentPopoverFromRect(rect, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        else
        {
            self.presentViewController(nc, animated: true, completion: nil)
        }
    }
    
    //handle when done is tapped, reset back to normal mode
    func onEditDone(sender:AnyObject) {
        self.mode = Constants.DELEGATES_MODE.NORMAL.rawValue
    }
    
    //handle the long press gesture, only when it's on top of a cell
    func onCellLongPress(gesture:UILongPressGestureRecognizer)
    {
        if gesture.state != UIGestureRecognizerState.Began {
            return
        }
        
        let point:CGPoint = gesture.locationInView(self.collectionView)
        let indexPath:NSIndexPath? = self.collectionView!.indexPathForItemAtPoint(point)
        if indexPath != nil {
            self.mode = Constants.DELEGATES_MODE.EDIT.rawValue
        }
    }
    
    //handle the tap gesture so we can capture the tap down event
    func onCellTap(gesture:UILongPressGestureRecognizer)
    {
        let point:CGPoint = gesture.locationInView(self.collectionView)
        let indexPath:NSIndexPath? = self.collectionView!.indexPathForItemAtPoint(point)
        if indexPath != nil
        {
            gesture.state != UIGestureRecognizerState.Ended ? self.highlightCell(indexPath) : self.highlightCell(nil)
            return
        }
        
        self.highlightCell(nil)
    }
    
    //confirm if user wants to remove delegate
    private func confirmRemove(agent:PersonModel)
    {
        let msg:String = "Are you sure you want to remove " + agent.displayName + " from your delegates?"
        let alert:UIAlertController = UIAlertController(title: nil, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let yes:UIAlertAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.Destructive, handler: {(action:UIAlertAction!) -> Void in
            
            self.removeAgent(agent)
            
        })
        
        let no:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(action:UIAlertAction!) -> Void in })
        alert.addAction(yes)
        alert.addAction(no)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //shrink agent cell and remove from data
    private func removeAgent(agent:PersonModel)
    {
        var cells:[AgentCollectionViewCell] = self.collectionView?.visibleCells() as [AgentCollectionViewCell]
        for cell in cells
        {
            if cell.agent === agent
            {
                let completionHandler:(agent:PersonModel?) -> Void = {(agent:PersonModel?) -> Void in
                    let indexPath:NSIndexPath = self.collectionView!.indexPathForCell(cell)!
                    let collectionView:UICollectionView = self.collectionView!
                    self.collectionView?.performBatchUpdates({() -> Void in
                        
                            self.agentList.removeAtIndex(indexPath.row)
                            collectionView.deleteItemsAtIndexPaths([indexPath])
                        
                        }, completion: {(finished:Bool) -> Void in

                            //restart animation or reset mode based on the number of delegates remaining
                            TimeUtils.PerformAfterDelay(0, completionHandler: {() -> Void in
                                self.mode = self.agentList.count == 0 ? Constants.DELEGATES_MODE.NORMAL.rawValue : Constants.DELEGATES_MODE.EDIT.rawValue
                            })
                            
                        })
                }
                
                cell.shrink(completionHandler)
                break
            }
        }
    }
    
    /**** delegate methods ****/
    func agentCollectionViewCellOnRemove(agent: PersonModel?) {
        self.confirmRemove(agent!)
    }
    
    //evaluate if the agent being added is a duplicate
    func allAgentsOnAgentSelected(agent: AgentModel) -> Bool
    {
        var isDuplicate:Bool = false
        for a in self.agentList {
            if a.id == agent.id {
                isDuplicate = true
                break
            }
        }
        
        //if it's a not a duplicate, add to collection, re-sort, figure out the NSIndexPaths and show insert animation
        if !isDuplicate
        {
            self.popoverController?.dismissPopoverAnimated(true)
            
            //delay so animation can be seen after the popover has been dismissed
            TimeUtils.PerformAfterDelay(0.5, completionHandler: {() -> Void in
            
                self.agentList.append(agent)
                self.agentList = DataModelUtils.sortAgents(self.agentList)
                var indexPath:NSIndexPath?
                for i in 0..<self.agentList.count {
                    let a:AgentModel = self.agentList[i]
                    if a.id == agent.id {
                        indexPath = NSIndexPath(forRow: i, inSection: 0)
                        break
                    }
                }
                
                self.collectionView?.insertItemsAtIndexPaths([indexPath!])
                self.collectionView?.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
                
            })
        }
        
        return isDuplicate
    }
    
}