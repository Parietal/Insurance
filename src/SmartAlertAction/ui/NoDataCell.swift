//
//  NoDataCell.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/14/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class NoDataCell: UICollectionViewCell {

    @IBOutlet var tipLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tipLabel.font = RAFonts.HELVETICA_NEUE_BOLD_30
        self.tipLabel.textColor = RAColors.GRAY5
        self.tipLabel.text = nil
    }

}
