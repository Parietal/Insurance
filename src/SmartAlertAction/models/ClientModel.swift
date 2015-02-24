//
//  ClientModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class ClientModel: PersonModel
{
    
    var id:Int = -1
    var birthDate:NSDate?
    var phone:String = ""
    var email:String = ""
    var address:String = ""
    var mobile:String = ""
    var clientSince:String?
    var gender:GenderModel?
    var maritalStatus:ClientAttributeModel?
    var annualizedPremium:AnnualizedPremiumModel?
    var account:AccountModel?
    var products:[PolicyModel] = [PolicyModel]()
    var settings:ClientSettingsModel?
    var notes:[AccountNoteModel] = [AccountNoteModel]()
    var retentionRiskScore:Int = -1
    
    // added by abhi for new data
    var rationaleModel: RationaleModel?
    
    init(id:Int, fName:String, lName:String, displayName:String, birthDateString:String, phone:String, email:String, address:String, mobile:String, gender:GenderModel?, account:AccountModel?,products:[PolicyModel], settings:ClientSettingsModel?, notes:[AccountNoteModel], retentionRiskScore:Int, rationaleModel: RationaleModel?)
    {
        super.init()
        
        self.id = id
        self.fName = fName
        self.lName = lName
        self.displayName = displayName
        self.birthDate = StringUtils.convertStringToDate(birthDateString, timeString: "")
        self.phone = phone
        self.email = email
        self.address = address
        self.mobile = mobile
        self.gender = gender
        self.account = account
        self.products = products
        self.settings = settings
        self.notes = notes
        self.retentionRiskScore = retentionRiskScore
        self.rationaleModel = rationaleModel
    }
    
    func getAge() -> Int? {
        var currDate: NSDate = NSDate()
        if let birth = self.birthDate {
            var interval = currDate.timeIntervalSinceDate(birth)
            var age: Int = (Int) (interval / (60 * 60 * 24 * 365))
            if age == 0 {
                return nil
            }
            return age
        } else {
            return nil
        }
    }
    
}