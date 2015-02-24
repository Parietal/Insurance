//
//  BadgeBar.swift
//  SmartAlertAction
//
//  Created by QiangRen on 10/13/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

protocol BadgeBarDelegate{
    func badgebar(badgebar: BadgeBar, onTap: BadgeButton)
    func badgebar(badgebar: BadgeBar, willTap: BadgeButton) -> (Bool)
}

class BadgeBar: UIView {
    
    var countOfRightButtons: Int = 2 // after added Delegated -> 2
    var delegate: BadgeBarDelegate?
    //var contentView:UIView!
    var leftButtons: [BadgeButton]? {
        didSet {
            updateLayout()
        }
    }
    
    var rightButtons: [BadgeButton]? {
        didSet {
            updateLayout()
        }
    }
    
    @IBInspectable var badgeButtonWidth: CGFloat = 138.0
    @IBInspectable var badgeButtonHeight: CGFloat = 44
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience init(width:CGFloat,height:CGFloat)
    {
        self.init(frame: CGRect(x: 0.0,y: 0.0,width: width,height: height))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /* this function is used to configure the badgeBar
    parameters:
    noOfBadges  : Int
    this is the number of badge buttons to be displayed ont he BadgeBar
    badgeLabels : [String]
    String array containing the labels for the BadgeButtons
    */
    func configureBadges(noOfBadges: Int, badgeLabels: [String], noOfItemsInBadge: [Int], selectedTitle: String) {
        
        if noOfBadges == 0 {
            return
        }
        
        var badgeButtonArray: [BadgeButton] = []
        
        for i in 0..<noOfBadges {
            var badgeBarButton = BadgeButton(width: badgeButtonWidth, height: badgeButtonHeight)
            
            var items = noOfItemsInBadge[i]
            
            badgeBarButton.badge = String(items)
            
            badgeBarButton.setTitle(badgeLabels[i], forState: UIControlState.Normal)
            
            if selectedTitle.isEmpty {
                if( i == 0){
                    badgeBarButton.selected = true
                }
            }
            else {
                if badgeLabels[i] == selectedTitle {
                    badgeBarButton.selected = true
                }
            }
            
            badgeButtonArray.append(badgeBarButton)
        }

        var right: [BadgeButton] = []
        for _ in 0..<countOfRightButtons
        {
            right.append(badgeButtonArray.removeLast())
        }
        self.leftButtons = badgeButtonArray
        self.rightButtons = right
    }

    private func updateLayout() {

        // Clean all BadgeButton
        for view in self.subviews
        {
            if view.isKindOfClass(BadgeButton.classForKeyedArchiver()!)
            {
                view .removeFromSuperview()
            }
        }
        
        //var totalWidth:CGFloat = 0.0
        // left buttons
        var startX:CGFloat = 10.0
        if leftButtons != nil
        {
            for button in leftButtons!
            {
                button.frame = CGRectMake(startX, 0.5*(self.frame.height - button.frame.height), button.frame.size.width, button.frame.size.height)
                button.addTarget(self, action:"buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(button)
                //totalWidth += button.frame.width
                startX += button.frame.width
            }
        }
        
        // right buttons
        startX = self.frame.width
        if rightButtons != nil
        {
            for button in rightButtons!
            {
                startX -= button.frame.width
                button.frame = CGRectMake(startX, 0.5*(self.frame.height - button.frame.height), button.frame.size.width, button.frame.size.height)
                button.addTarget(self, action:"buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(button)
                //totalWidth += button.frame.width
            }
        }
    }
    
    override func layoutSubviews() {
        if self.rightButtons?.count > 0 {
            var x = self.frame.width
            for right in rightButtons!
            {
                x -= right.frame.width
                right.frame.origin.x = x
            }
        }
    }
    
    func buttonAction(sender: BadgeButton) {
        if sender.selected && sender.titleLabel?.text != Constants.SMART_LIST_CATEGORY_NAMES.OTHER.rawValue
        {
            return
        }
        let blockTap = delegate?.badgebar(self, willTap: sender)
        if(blockTap == true){
            return;
        }
        for view in self.subviews
        {
            if view.isKindOfClass(BadgeButton.classForKeyedArchiver()!)
            {
                (view as BadgeButton).selected = false
            }
        }
        sender.selected = true
        delegate?.badgebar(self, onTap: sender)
    }
    
    func setButtonSelected(title:String){
        for view in self.subviews
        {
            if view.isKindOfClass(BadgeButton.classForKeyedArchiver()!)
            {
                (view as BadgeButton).selected = false
                if (view as BadgeButton).titleLabel?.text! == title {
                    (view as BadgeButton).selected = true
                }
            }
        }
    }

}
