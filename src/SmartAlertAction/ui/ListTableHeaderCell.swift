//
//  ListTableHeaderCell.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/3/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class ListTableHeaderCell: UITableViewCell {

    @IBOutlet var titleLabel:UILabel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.contentView.backgroundColor = RAColors.LIGHT_GRAY
        self.backgroundColor = RAColors.LIGHT_GRAY
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.editingAccessoryType = UITableViewCellAccessoryType.None
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // fix no background color issue on iPad
        self.contentView.backgroundColor = RAColors.LIGHT_GRAY
        self.backgroundColor = RAColors.LIGHT_GRAY

        self.titleLabel?.textColor = RAColors.DARK_GRAY
        self.titleLabel?.font = RAFonts.TABLE_HEADER_TITLE
    }

    override func setEditing(editing: Bool, animated: Bool) {
        //fix issue: a circle for checkmark will appear in editing mode
        //super.setEditing(false, animated: false)
    }
    
    func update(title:String) {
        self.titleLabel?.text = title
    }

}
