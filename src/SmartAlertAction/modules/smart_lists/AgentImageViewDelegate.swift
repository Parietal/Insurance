//
//  AgentImageViewDelegate.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-11-04.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

protocol AgentImageViewDelegate {
    func agentImageViewDelegateSelected(agent:PersonModel, forAlertId alertId:Int)
}