//
//  AlertTableViewCell.swift
//  DelegateAlerts
//
//  Created by Saurav on 13/10/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    var premiumStatus: UILabel!
    var ratingView: DiamondRatingView!
    var clientLabel: UILabel!
    var delegatedToLabel: UILabel!
    var delegateButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        premiumStatus = UILabel(frame: CGRect(x: 20, y: 0, width: 210, height: 25))
        premiumStatus.font = RAFonts.HELVETICA_NEUE_BOLD_16
        premiumStatus.textColor = RAColors.GRAY7

        ratingView = DiamondRatingView(frame: CGRect(x: 240, y: 7, width: 60, height: 25))
        ratingView.backgroundColor = UIColor.clearColor()
        
        
        clientLabel = UILabel(frame: CGRect(x: 20, y: 28, width: 280, height: 25))
        clientLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_17
        
        delegatedToLabel = UILabel(frame: CGRect(x: 20, y: 56, width: 90, height: 25))
        delegatedToLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_16
        delegatedToLabel.textColor = UIColor.grayColor()
        delegatedToLabel.textColor = RAColors.GRAY4

        delegateButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        delegateButton.frame = CGRect(x: 115, y: 56, width: 130, height: 25)
        delegateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
        delegateButton.titleLabel?.font = RAFonts.DELEGATE_CELL_AGENTNAMEBUTTON
        delegateButton.setTitleColor(RAColors.BLUE1, forState: UIControlState.Normal)

        self.addSubview(premiumStatus)
        self.addSubview(ratingView)
        self.addSubview(clientLabel)
        self.addSubview(delegatedToLabel)
        self.addSubview(delegateButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
