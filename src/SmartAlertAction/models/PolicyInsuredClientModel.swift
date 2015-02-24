//
//  PolicyInsuredClientModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class PolicyInsuredClientModel
{
    
    var client:ClientModel?
    var insuredTypes:[PolicyInsuredTypeModel] = [PolicyInsuredTypeModel]()
    
    init(client:ClientModel, insuredTypes:[PolicyInsuredTypeModel]) {
        self.client = client
        self.insuredTypes = insuredTypes
    }
    
}