//
//  ProductDetailTableViewCell.swift
//  SmartAlertAction
//
//  Created by Saurav on 14/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var proTextLabel: UILabel!
    @IBOutlet weak var proDetailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
