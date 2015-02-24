//
//  AllAgentsCell.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-11-26.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import Foundation
import UIKit

class AllAgentsCell:UITableViewCell
{
    
    @IBOutlet var fNameLabel:UILabel?
    @IBOutlet var lNameLabel:UILabel?
    
    var agent:AgentModel? {
        didSet {
            self.fNameLabel?.text = agent?.fName
            self.fNameLabel?.sizeToFit()
            self.lNameLabel?.text = agent?.lName
            self.lNameLabel?.sizeToFit()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.fNameLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_16
        self.lNameLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_16
    }
    
}