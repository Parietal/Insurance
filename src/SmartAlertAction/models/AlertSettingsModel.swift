//
//  AlertSettingsModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class AlertSettingsModel
{
    
    var allowNotification:Bool = false
    var showInNotificationCenter:Bool = false
    var notificationSoundId:Int = -1
    var badgeAppIcon:Bool = false
    var showOnLockScreen:Bool = false
    var showActNowAlerts:Bool = false
    var showFollowUpAlerts:Bool = false
    var repeatAlerts:Bool = false
    
    init(allowNotification:Bool, showInNotificationCenter:Bool, notificationSoundId:Int, badgeAppIcon:Bool, showOnLockScreen:Bool, showActNowAlerts:Bool, showFollowUpAlerts:Bool, repeatAlerts:Bool)
    {
        self.allowNotification = allowNotification
        self.showInNotificationCenter = showInNotificationCenter
        self.notificationSoundId = notificationSoundId
        self.badgeAppIcon = badgeAppIcon
        self.showOnLockScreen = showOnLockScreen
        self.showActNowAlerts = showActNowAlerts
        self.showFollowUpAlerts = showFollowUpAlerts
        self.repeatAlerts = repeatAlerts
    }
    
}