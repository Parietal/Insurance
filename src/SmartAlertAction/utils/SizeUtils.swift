//
//  SizeUtils.swift
//  SmartAlertAction
//
//  Created by SunTeng on 9/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class SizeUtils {
    
    class func sizeWithText(text:String, font:UIFont, inMaxSize:CGSize) -> CGSize {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let attributes = NSMutableDictionary()
        attributes.setValue(font, forKey: NSFontAttributeName)
        attributes.setValue(paragraphStyle, forKey: NSParagraphStyleAttributeName)
        
        var rect = NSString(string: text).boundingRectWithSize(inMaxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return rect.size
    }
    
    class func heightOfCell(font: UIFont?,labelSize: CGSize?,labelText: String?) -> CGFloat {
        //return 140
        
        // top cell padding
        var height: CGFloat = 5 // cell padding
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        // message, need to measure
       if NSString(string: labelText!).length > 0 {
        
        let attributes = NSMutableDictionary()
        attributes.setValue(RAFonts.HELVETICA_NEUE_REGULAR_15, forKey: NSFontAttributeName)

            var cellSize = labelText!.boundingRectWithSize(labelSize!, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
            height += cellSize.size.height
        } else {
            height += 44
        }
        //bottom padding
        height += 5
        
        return height
    }
}