//
//  CommonFunc.swift
//  SmartAlertAction
//
//  Created by Saurav on 29/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class CommonFunc: NSObject {
 
    //AlertAdapter Class Instance
    class var sharedInstanceAlert : AlertAdapter {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : AlertAdapter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AlertAdapter()
        }
        return Static.instance!
    }

    // CategoryAdapter Class Instance
    class var sharedInstanceCategory : CategoryAdapter {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CategoryAdapter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CategoryAdapter()
        }
        return Static.instance!
    }
    
    //SettingsAdapter Class Instance
    class var sharedInstanceSettings : SettingsAdapter {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : SettingsAdapter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SettingsAdapter()
        }
        return Static.instance!
    }

    // AuthorAdapter Class Instance
    class var sharedInstanceAuthor : AuthorAdapter {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : AuthorAdapter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AuthorAdapter()
        }
        return Static.instance!
    }
    
    // NoteAdapter Class Instance
    class var sharedInstanceNote : NoteAdapter {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : NoteAdapter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NoteAdapter()
        }
        return Static.instance!
    }
    
    // DelegateAdapter Class Instance
    class var sharedInstanceDelegate : DelegateAdapter {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : DelegateAdapter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DelegateAdapter()
        }
        return Static.instance!
    }
    
    //DefaultValues Class Instance
    class var sharedInstanceDefaultValues : DefaultValues {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : DefaultValues? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DefaultValues()
        }
        return Static.instance!
    }
    
    class func getKeyBoardType(string:String) -> UIKeyboardType {
        if string == "Cardholder Name" {
            return UIKeyboardType.Default
        }
        else if string == "Card Number" || string == "Security Code" || string == "Account Number" || string == "Routing Number" {
            return UIKeyboardType.NumberPad
        }
        else {
            return UIKeyboardType.NumbersAndPunctuation
        }
    }
    class func getKeyboardAutocapitalizationType(string:String) -> UITextAutocapitalizationType {
        if string == "Cardholder Name" {
            return UITextAutocapitalizationType.Words
        }
        else {
            return UITextAutocapitalizationType.None
        }
    }
    class func getKeyBoardReturnKeyType(string:String) -> UIReturnKeyType {
        
        if string == "Cardholder Name" || string == "Card Number" || string == "Security Code" || string == "Account Number" || string == "Routing Number" {
            return UIReturnKeyType.Done
        }
        else  {
            return UIReturnKeyType.Default
        }
    }
    class func isDigit(string:String) -> Bool {
        
        let numbersOnly = NSCharacterSet(charactersInString: "0123456789")
        let characterSetFromString = NSCharacterSet(charactersInString: string)
        
        return numbersOnly.isSupersetOfSet(characterSetFromString)
    }
    
    class func isAlphabet(string:String) -> Bool {
    
        let alphabetOnly = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")//Allow Space too
        let characterSetFromString = NSCharacterSet(charactersInString: string)
        
        return alphabetOnly.isSupersetOfSet(characterSetFromString)
    }
    class func isAlphabetExtra(string:String) -> Bool {
        
        let alphabetOnly = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ -_.")//Allow Space too
        let characterSetFromString = NSCharacterSet(charactersInString: string)
        
        return alphabetOnly.isSupersetOfSet(characterSetFromString)
    }
    class func isAlphabetOnly(string:String) -> Bool {
        
        let alphabetOnly = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let characterSetFromString = NSCharacterSet(charactersInString: string)
        
        return alphabetOnly.isSupersetOfSet(characterSetFromString)
    }
    class func daysBetweenDate(fromDateTime: NSDate, toDateTime: NSDate) -> NSInteger {

        
        let cal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .DayCalendarUnit
        
        let components = cal.components(unit, fromDate: fromDateTime, toDate: toDateTime, options: nil)
        //println(components)
        
        return components.day
        
    }
    
    class func capitalizeFirstChar(string:String) -> String {
    
        if isAlphabet(string) {
            let str = string as NSString
            let firstChar = str.substringToIndex(1).capitalizedString
            let cappedString = str.stringByReplacingCharactersInRange(NSMakeRange(0, 1), withString: firstChar)
            
            return cappedString
        }
        return string
    }
    
    class func showAlert(title:String,message:String) {
    
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()

    }
}
