//
//  CalendarHeaderCell.swift
//  CalendarDatePicker
//
//  Created by Paul Yuan on 2014-11-17.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class CalendarHeaderCell:UICollectionViewCell
{
    
    @IBOutlet var label:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label?.font = UIFont.systemFontOfSize(10)
        self.backgroundColor = UIColor.clearColor()
    }
    
    //update the label and color
    func update(dayIndex:Int)
    {
        let color:UIColor = dayIndex == 6 || dayIndex == 0 ? CalendarConstants.COLOR_GREY : CalendarConstants.COLOR_BLACK
        self.label?.textColor = color
        self.label?.text = CalendarConstants.DAYS_OF_WEEK[dayIndex]
    }
    
}