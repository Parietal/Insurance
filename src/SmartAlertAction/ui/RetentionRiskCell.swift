//
//  RetentionRiskCell.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 30/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class RetentionRiskCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var retentionRiskScore: UILabel!
    
    var clientDetail : ClientModel!
    
    
    func addContent(clientDetail : ClientModel?)
    {
        var labelRef : UILabel? = self.contentView.viewWithTag(222) as UILabel?
        if labelRef != nil {
            labelRef!.removeFromSuperview()
        }
        
        var label:UILabel = UILabel(frame: CGRectMake(15, 36, 259, 100))
        label.textAlignment = NSTextAlignment.Left
        label.tag = 222
        label.numberOfLines = 0
        label.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        label.textColor = RAColors.GRAY6
        self.contentView.addSubview(label)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            var textht : CGFloat = SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_14,labelSize: CGSize(width: 320, height: 500),labelText: clientDetail?.rationaleModel?.text)
            
            label.text = clientDetail?.rationaleModel?.text
            
            label.frame = CGRectMake(15, 36, 259, textht + 10)
        }else{
            var textht : CGFloat = SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_14,labelSize: CGSize(width: 650, height: 500),labelText: clientDetail?.rationaleModel?.text)
            
            label.text = clientDetail?.rationaleModel?.text
            
            label.frame = CGRectMake(15, 23, 556, textht + 10)
        }
    }
    
}
