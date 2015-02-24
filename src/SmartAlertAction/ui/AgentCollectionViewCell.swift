//
//  AgentCollectionViewCell.swift
//  AgentImage
//
//  Created by Saurav on 15/10/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit

protocol AgentCollectionViewCellDelegate {
    func agentCollectionViewCellOnRemove(agent:PersonModel?)
}

class AgentCollectionViewCell: UICollectionViewCell
{
    
    //@IBOutlet weak var imageView: UIImageView!
    var agentImageView: UIImageView!
    var agentName: UILabel!
    var removeBtn:UIButton!
    var delegate:AgentCollectionViewCellDelegate?
    
    var agent:PersonModel? {
        didSet
        {
            if self.agent != nil {
                self.agentImageView.image = UIImage(named: self.agent!.imageName)
                self.agentName.text = self.agent!.getFullName()
                self.setNeedsDisplay()
            }
        }
    }
    
    var mode:Int = Constants.DELEGATES_MODE.NORMAL.rawValue {
        didSet {
            self.onMode(self.mode)
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        agentImageView = UIImageView()
        agentImageView.clipsToBounds = true
        self.contentView.addSubview(agentImageView)
        
        agentName = UILabel()
        agentName.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        agentName.backgroundColor = UIColor.clearColor()
        agentName.textAlignment = NSTextAlignment.Center
        agentName.textColor = UIColor.blackColor()
        self.contentView.addSubview(agentName)
        
        self.removeBtn = UIButton()
        self.removeBtn.setImage(UIImage(named: "icon_remove"), forState: UIControlState.Normal)
        self.removeBtn.addTarget(self, action: "onRemove:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(self.removeBtn)
        
        self.reset() //reset all frames
        self.onMode(self.mode) //set defalt mode
        self.removeBtn.hidden = true //don't show animation on init
    }
    
    convenience override init() {
        self.init(frame: CGRectZero)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //reset all frames
    private func reset()
    {
        agentImageView.image = nil
        agentImageView.frame = CGRect(x: 0, y: 10, width: 100, height: 104)
        agentImageView.layer.cornerRadius = agentImageView.frame.size.width / 2
        
        agentName.text = ""
        agentName.frame = CGRect(x: 0, y: 116, width: 100, height: 20)
        
        self.removeBtn.transform = CGAffineTransformIdentity //must reset transform before setting the frame
        self.removeBtn.frame = CGRectMake(0, 15, 20, 20)
        
        self.transform = CGAffineTransformIdentity
        self.hidden = false
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        self.reset()
    }
    
    //handler for when cell is selected
    func onSelected() {
        if self.mode != Constants.DELEGATES_MODE.EDIT.rawValue {
            self.contentView.alpha = 0.25
        }
    }
    
    //handler for when cell is deselected
    func onDeselected() {
        self.contentView.alpha = 1
    }
    
    //handle rendering the view based on the mode
    private func onMode(mode:Int)
    {
        self.onDeselected()
        
        let duration:NSTimeInterval = mode == Constants.DELEGATES_MODE.NORMAL.rawValue ? 0.1 : 0.5
        self.removeBtn.hidden = false
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
            
                let toTransform:CGAffineTransform = mode == Constants.DELEGATES_MODE.NORMAL.rawValue ? CGAffineTransformMakeScale(0.01, 0.01) : CGAffineTransformIdentity
                self.removeBtn.transform = toTransform
            
            }, completion: {(finished:Bool) -> Void in
        
                self.removeBtn.hidden = mode == Constants.DELEGATES_MODE.NORMAL.rawValue
            
            })
        
        //add/remove wiggle animation
        mode == Constants.DELEGATES_MODE.EDIT.rawValue ? self.wiggle() : self.layer.removeAllAnimations()
    }
    
    //handle when the remove button is tapped
    func onRemove(sender:AnyObject) {
        self.delegate?.agentCollectionViewCellOnRemove(self.agent)
    }
    
    //show wiggle animation for edit mode
    private func wiggle()
    {
        let animation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        let wobbleAngle:CGFloat = 0.03
        let valLeft:NSValue = NSValue(CATransform3D: CATransform3DMakeRotation(wobbleAngle, 0, 0, 1))
        let valRight:NSValue = NSValue(CATransform3D: CATransform3DMakeRotation(-wobbleAngle, 0, 0, 1))
        animation.values = [valLeft, valRight]
        animation.autoreverses = true
        animation.duration = 0.1
        animation.repeatCount = Float.infinity
        self.layer.addAnimation(animation, forKey: "transform")
    }
    
    //show shrink annimation
    func shrink(completionHandler: ((agent:PersonModel?) -> Void)?)
    {
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
            
            let toTransform:CGAffineTransform = CGAffineTransformMakeScale(0, 0)
            self.transform = toTransform
            
            }, completion: {(finished:Bool) -> Void in
                
                self.hidden = true
                completionHandler?(agent: self.agent)
                
            })
    }
    
}
