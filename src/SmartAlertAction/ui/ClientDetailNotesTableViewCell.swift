//
//  ClientDetailNotesTableViewCell.swift
//  SmartAlertAction
//
//  Created by SunTeng on 9/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ClientDetailNotesTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
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
        
        self.titleLabel.font = RAFonts.CLIENT_CONTACT_CELL_TITLE
        self.titleLabel.textColor = RAColors.MEDIUM_GRAY
        self.contentLabel.font = RAFonts.CLIENT_CONTACT_CELL_BODY
    }

}
