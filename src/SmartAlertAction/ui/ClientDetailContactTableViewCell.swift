//
//  ClientDetailContactTableViewCell.swift
//  SmartAlertAction
//
//  Created by SunTeng on 9/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ClientDetailContactTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var rightButton1: UIButton!
    @IBOutlet var rightButton2: UIButton!
    
    var cellTag : Int = 0

    enum State {
        case OneButton
        case TwoButton
        case NoButton
    }

    var state: State = .TwoButton
    var constraints: [NSLayoutConstraint] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.titleLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        self.titleLabel.textColor = RAColors.BLUE1  // Bruce ** Color Change
        self.contentLabel.font = RAFonts.HELVETICA_NEUE_MEDIUM_15

        // update Constraints if needs
        self.updateConstraintsWithState(self.checkState())
    }

    func checkState() -> State {
        if rightButton2.hidden == true && rightButton1.hidden == true {
            // no button at all
            return .NoButton
        } else {
            if rightButton2.hidden == true {
                // only one button
                return .OneButton
            } else {
                // two button, even if Button1 is hidden
                return .TwoButton
            }
        }
    }

    func updateConstraintsWithState(state: State) {
        if self.state != state {
            var width = self.frame.width
            
            switch state {
            case .TwoButton:
                width -= 15 * 2 // left right padding = 15
                width -= 48 * 2 // button width = 36, padding to button = 12
            case .OneButton:
                width -= 15 * 2 // left right padding = 15
                width -= 48 * 1 // button width = 36, padding to button = 12
            case .NoButton:
                width -= 15 * 2 // left right padding = 15
            }
            self.titleLabel?.frame.size = CGSizeMake(width, self.frame.height)
            self.detailTextLabel?.frame.size = CGSizeMake(width, self.frame.height)
            
            self.needsUpdateConstraints()
            self.updateConstraintsIfNeeded()
            
            self.state = state
        }
    }
}
