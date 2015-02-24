//
//  AlertNotificationSwitchCell
//  SmartAlertAction
//
//  Created by Lad on 14-11-12.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

protocol AlertNotificationSwitchCellDelegate {
    func onSwitchStateChanged(index:Int, newState:Bool)
}

class AlertNotificationSwitchCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var stateSwitch:UISwitch!
    
    var delegate:AlertNotificationSwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stateSwitch.onTintColor = RAColors.BLUE1
        titleLabel.font = RAFonts.HELVETICA_NEUE_BOLD_14
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func switchStateChanged(sender:UISwitch){
        delegate?.onSwitchStateChanged(self.tag, newState: sender.on)
    }

}
