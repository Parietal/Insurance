//
//  SwipeableTableViewCell.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/23/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

enum SwipeableTableViewCellState {
    case Center
    case Left
    case Right
}

protocol SwipeableTableViewCellDelegate: NSObjectProtocol {
    
    func swipeableTableViewCell(cell: SwipeableTableViewCell, didTapLeftButtonWithIndex index: Int)
    func swipeableTableViewCell(cell: SwipeableTableViewCell, didTapRightButtonWithIndex index: Int)
    func swipeableTableViewCell(cell: SwipeableTableViewCell, canSwipeToState state: SwipeableTableViewCellState) -> Bool
    
}

var lastScrollCell: SwipeableTableViewCell?

class SwipeableTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    private let MAX_BUTTON_WIDTH: CGFloat = 100
    
    private var cellState: SwipeableTableViewCellState = SwipeableTableViewCellState.Center
    var leftButtons: [UIButton]?
    var rightButtons: [UIButton]?
    var tableView: UITableView!
    
    private var buttonPading: CGFloat = 0
    private var swipeScrollView: UIScrollView!
    
    private var leftBtnBaseView: UIView?
    private var rightBtnBaseView: UIView?
    private var newContentView: UIView!
    
    private var leftBtnWidth: CGFloat = 0.0
    private var rightBtnWidth: CGFloat = 0.0
    
    weak var delegate: SwipeableTableViewCellDelegate?
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.leftButtons = []
        self.rightButtons = []
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.autoresizesSubviews = true
        self.initBaseViews()
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String? ,leftButtons: [UIButton]?, rightButtons: [UIButton]?, delegate: SwipeableTableViewCellDelegate?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.delegate = delegate
        self.leftButtons = leftButtons
        self.rightButtons = rightButtons
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.autoresizesSubviews = true
        self.initBaseViews()
    }
    
    func clickCell(sender: UITapGestureRecognizer) {

        if tableView == nil {
            println("You need to set \"tableView\" to enable tap action.")
        }
        
        if cellState == .Center && tableView != nil {
            // Selection hack
            var indexPath: NSIndexPath! = tableView.indexPathForCell(self)

            if self.selected
            {
                //deselect cell
                _deselect(&indexPath)
            }
            else
            {
                //select cell
                _select(&indexPath)
            }
        } else {
            // Scroll back to center
            changeStateTo(.Center)
        }
        
    }

    private func _select(inout indexPath: NSIndexPath!)
    {
        tableView?.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        if tableView.delegate?.respondsToSelector(Selector("tableView:willSelectRowAtIndexPath:")) == true
        {
            indexPath = tableView.delegate?.tableView?(tableView, willSelectRowAtIndexPath: indexPath)
        }
        
        if indexPath != nil
        {
            if tableView.delegate?.respondsToSelector(Selector("tableView:didSelectRowAtIndexPath:")) == true
            {
                tableView.delegate?.tableView?(tableView, didSelectRowAtIndexPath: indexPath)
            }
            
            // Highlight hack
            if (!self.highlighted)
            {
                self.setHighlighted(true, animated: false)
                
                dispatch_after(100, dispatch_get_main_queue(), { () -> Void in
                    self.setHighlighted(false, animated: true)
                })
                
            }
        }
    }
    
    private func _deselect(inout indexPath: NSIndexPath!)
    {
        tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView.delegate?.respondsToSelector(Selector("tableView:willDeselectRowAtIndexPath:")) == true
        {
            indexPath = tableView.delegate?.tableView?(tableView, willDeselectRowAtIndexPath: indexPath)
        }
        
        if indexPath != nil
        {
            if tableView.delegate?.respondsToSelector(Selector("tableView:didDeselectRowAtIndexPath:")) == true
            {
                tableView.delegate?.tableView?(tableView, didDeselectRowAtIndexPath: indexPath)
            }
            
            // Highlight hack
            if (!self.highlighted)
            {
                self.setHighlighted(true, animated: false)
                
                dispatch_after(100, dispatch_get_main_queue(), { () -> Void in
                    self.setHighlighted(false, animated: true)
                })
                
            }
        }
    }
    
    override  func setEditing(editing: Bool, animated: Bool)
    {
        super.setEditing(editing, animated: animated)
        if editing {
            // reset State of last scrolled cell to Ceter
            lastScrollCell?.changeStateTo(.Center)
            // disable scroll
            self.swipeScrollView.scrollEnabled = false;
        } else {
            // enable scroll
            self.swipeScrollView.scrollEnabled = true;
        }
        
    }
    
    func changeStateTo(state: SwipeableTableViewCellState) {
        var canSwipe:Bool? = true
        if delegate?.respondsToSelector(Selector("swipeableTableViewCell:canSwipeToState:")) == true {
            canSwipe = delegate?.swipeableTableViewCell(self, canSwipeToState: state)
        }
        if canSwipe == true {
            switch state {
            case .Center:
                println("changeStateToCenter")
                swipeScrollView.setContentOffset(CGPointMake(leftBtnWidth, 0), animated: true)
                leftBtnBaseView?.hidden = true
                rightBtnBaseView?.hidden = true
            case .Left:
                println("changeStateToLeft")
                swipeScrollView.setContentOffset(CGPointZero, animated: true)
            case .Right:
                println("changeStateToRight")
                swipeScrollView.setContentOffset(CGPointMake(leftBtnWidth + rightBtnWidth, 0), animated: true)
            }
            cellState = state
            
            if state == .Left || state == .Right {
                lastScrollCell = self
            }
        } else {
            changeStateTo(SwipeableTableViewCellState.Center)
        }
        
    }
    
    
    func initBaseViews(){
        
        var cheight = CGRectGetHeight(self.bounds)
        var btnWidth = MAX_BUTTON_WIDTH //(self.bounds.height>MAX_BUTTON_WIDTH ? MAX_BUTTON_WIDTH : self.bounds.height)
        self.leftBtnWidth = btnWidth * CGFloat(leftButtons!.count)
        self.rightBtnWidth = btnWidth * CGFloat(rightButtons!.count)
        
        buttonPading = leftBtnWidth + rightBtnWidth
        
        var cellScrollView = self.swipeScrollView
        if cellScrollView == nil {
            cellScrollView = UIScrollView(frame: CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
            var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("clickCell:"))
            cellScrollView.addGestureRecognizer(tapGestureRecognizer)
        }
        cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        var count = leftButtons!.count + rightButtons!.count
        var cwidth = CGFloat(count) * btnWidth
        cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + CGFloat(cwidth), CGRectGetHeight(self.bounds))
        cellScrollView.contentOffset = CGPointMake(leftBtnWidth, 0)
        cellScrollView.delegate = self
        cellScrollView.showsHorizontalScrollIndicator = false
        
        self.swipeScrollView = cellScrollView
        
        var scrollViewButtonViewLeft = leftBtnBaseView
        if scrollViewButtonViewLeft == nil {
            scrollViewButtonViewLeft = UIView(frame: CGRectMake(leftBtnWidth, 0, leftBtnWidth, cheight))
            self.leftBtnBaseView = scrollViewButtonViewLeft
            self.swipeScrollView.addSubview(scrollViewButtonViewLeft!)
        }
        scrollViewButtonViewLeft?.frame = CGRectMake(leftBtnWidth, 0, leftBtnWidth, cheight)
        
        
        var scrollViewButtonViewRight = rightBtnBaseView
        if scrollViewButtonViewRight == nil {
            scrollViewButtonViewRight = UIView(frame: CGRectMake(CGRectGetWidth(self.bounds) - rightBtnWidth, 0, rightBtnWidth, cheight))
            self.rightBtnBaseView = scrollViewButtonViewRight
            self.swipeScrollView.addSubview(scrollViewButtonViewRight!)
        }
        scrollViewButtonViewRight?.frame = CGRectMake(CGRectGetWidth(self.bounds) - rightBtnWidth, 0, rightBtnWidth, cheight)
        
        self.showBtns(true)
        self.showBtns(false)
        
        // Create the content view that will live in our scroll view
        var scrollViewContentView = newContentView
        if scrollViewContentView == nil {
            scrollViewContentView = UIView(frame: CGRectMake(self.leftBtnWidth, 0, CGRectGetWidth(self.bounds), cheight))
            scrollViewContentView.backgroundColor = UIColor.whiteColor()
            self.swipeScrollView.addSubview(scrollViewContentView)
            self.newContentView = scrollViewContentView
            
            // Add the cell scroll view to the cell
            var contentViewParent = self
            var zv = self.subviews[0] as NSObject
            
            if NSStringFromClass(zv.classForCoder) == "kTableViewCellContentView" {
                contentViewParent = self.subviews[0] as SwipeableTableViewCell
            }
            var cellSubviews = contentViewParent.subviews
            self.insertSubview(swipeScrollView, atIndex: 0)
            
            for subview in cellSubviews {
                self.newContentView.addSubview(subview as UIView)
            }
            
            swipeScrollView.pagingEnabled = false
            
            swipeScrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            swipeScrollView.autoresizesSubviews = true
            newContentView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        }
        scrollViewContentView.frame = CGRectMake(self.leftBtnWidth, 0, CGRectGetWidth(self.bounds), cheight)
        leftBtnBaseView?.hidden = true
        rightBtnBaseView?.hidden = true
        swipeScrollView.bounces = false
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        //        self.changeStateTo(cellState)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.changeStateTo(cellState)
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var targetContentOffsetx = (targetContentOffset.memory as CGPoint).x
        var targetContentOffsety = (targetContentOffset.memory as CGPoint).y
        println("targetContentOffsetx:\(targetContentOffsetx)")
        println("velocity.x:\(velocity.x)")
        var rightThreshold = buttonPading - (rightBtnWidth * 1 / 3)
        var leftThreshold = leftBtnWidth * 2 / 3
        println("rightThreshold:\(rightThreshold)")
        println("leftThreshold:\(leftThreshold)")
        switch self.cellState {
        case .Center:
            if velocity.x > 0.5 {
                self.changeStateTo(.Right)
            } else if velocity.x < -0.5 {
                self.changeStateTo(.Left)
            } else {
                if targetContentOffsetx > rightThreshold {
                    self.changeStateTo(.Right)
                } else if targetContentOffsetx < leftThreshold {
                    self.changeStateTo(.Left)
                } else {
                    self.changeStateTo(.Center)
                }
            }
        case .Left:
            if velocity.x > 0.5 {
                self.changeStateTo(.Center)
            } else if velocity.x < -0.5 {
                // Nop
            } else {
                if targetContentOffsetx > rightThreshold {
                    self.changeStateTo(.Right)
                } else if targetContentOffsetx < leftThreshold {
                    self.changeStateTo(.Left)
                } else {
                    self.changeStateTo(.Center)
                }
            }
        case .Right:
            if velocity.x > 0.5 {
                // Nop
            } else if velocity.x < -0.5 {
                self.changeStateTo(.Center)
            } else {
                if targetContentOffsetx > leftThreshold {
                    self.changeStateTo(.Right)
                } else if targetContentOffsetx < rightThreshold {
                    self.changeStateTo(.Left)
                } else {
                    self.changeStateTo(.Center)
                }
            }
        default:
            // Nop
            break
        }
        
        targetContentOffset.memory = scrollView.contentOffset
    }
    
    func btnClick(sender:UIButton) {
        
        if sender.superview == leftBtnBaseView {
            if delegate?.respondsToSelector(Selector("swipeableTableViewCell:didTapLeftButtonWithIndex:")) == true {
                self.delegate?.swipeableTableViewCell(self, didTapLeftButtonWithIndex: sender.tag)
            }
        } else {
            if delegate?.respondsToSelector(Selector("swipeableTableViewCell:didTapRightButtonWithIndex:")) == true {
                self.delegate?.swipeableTableViewCell(self, didTapRightButtonWithIndex: sender.tag)
            }
        }
        
    }
    
    func showBtns(left: Bool) {
        
        var buttons: [UIButton]!
        
        var baseView: UIView!
        if left == true {
            buttons = self.leftButtons
            baseView = self.leftBtnBaseView
        } else {
            buttons = self.rightButtons
            baseView = self.rightBtnBaseView
        }
        
        var offset:CGFloat = 0
        var count = 0
        for button in buttons {
            button.frame = CGRectMake(offset, 0, (self.bounds.height>MAX_BUTTON_WIDTH ? MAX_BUTTON_WIDTH : self.bounds.height), self.bounds.height)
            button.tag = count
            count++
            button.addTarget(self, action: "btnClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            offset = CGRectGetMaxX(button.frame)
            baseView.addSubview(button)
        }
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if lastScrollCell != self {
            
            lastScrollCell?.changeStateTo(SwipeableTableViewCellState.Center)
            
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.x > self.leftBtnWidth) {
            // Expose the right button view
            self.rightBtnBaseView?.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - self.rightBtnWidth), 0.0, self.rightBtnWidth, CGRectGetHeight(self.bounds))
            self.rightBtnBaseView?.hidden = false
            self.leftBtnBaseView?.hidden = true
        } else {
            // Expose the left button view
            self.leftBtnBaseView?.frame = CGRectMake(scrollView.contentOffset.x, 0.0, self.leftBtnWidth, CGRectGetHeight(self.bounds))
            self.rightBtnBaseView?.hidden = true
            self.leftBtnBaseView?.hidden = false
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var cwidth = CGRectGetWidth(self.bounds)
        var cheight = CGRectGetHeight(self.bounds)
        self.swipeScrollView.frame = CGRectMake(0, 0, cwidth,cheight )
        self.swipeScrollView.contentSize = CGSizeMake(cwidth + self.buttonPading, cheight)
        self.swipeScrollView.contentOffset = CGPointMake(self.leftBtnWidth, 0)
        self.leftBtnBaseView?.frame = CGRectMake(self.leftBtnWidth, 0, self.leftBtnWidth, cheight)
        self.rightBtnBaseView?.frame = CGRectMake(cwidth, 0, self.rightBtnWidth, cheight)
        self.newContentView.frame = CGRectMake(self.leftBtnWidth, 0,cwidth, cheight)
        
        initBaseViews()
    }
}