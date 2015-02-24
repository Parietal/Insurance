//
//  PersonModel.swift
//  SmartAlertAction
//
//  Created by QiangRen on 9/18/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class PersonModel {

    var fName:String = ""
    var lName:String = ""
    var displayName:String = ""
    var imageName:String = ""
    
    func getFullName() -> String {
        return self.fName + " " + self.lName
    }

    func getNameAlphabet() -> String {
        var index = self.lName.substringToIndex(advance(self.lName.startIndex, 1)).uppercaseString
        return index
    }
    
}
