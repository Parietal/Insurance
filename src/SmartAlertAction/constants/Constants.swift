//
//  Constants.swift
//  SmartAlertAction
//
//  Created by Qiang Ren on 9/4/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

enum Platform: Int {
    case iPhone = 1
    case iPad = 2
}

class Constants:NSObject
{
    
    /**** app constants ****/
    
    /**** login constants ****/
    class var LOGIN_USERNAME:String { return "Mike McLeod" }
    class var LOGIN_PASSWORD:String { return "admin" }
    
    /**** client constants ****/
    class var ALPHABETS:[String] { return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"] }
    class var BIRTHDAY_FORMAT:String { return "MMMM d, yyyy" }
    class var BILL_DATE : String {return "MM/d"}
    class var NOTE_DATE_TIME_FORMAT:String { return "M/d/y hh:mm a" }
    class var NOTE_MONTH_YEAR:String { return "MM/YYYY" }
    class var FINISH_NOTE_DATE:String { return "MM/d"}
    class var YEAR_DATE:String { return "YYYY"}
    class var MONTH_2DIGIT_DATE:String { return "MM"}
    class var POSTPONE_NOTE_DATE:String {return "MM/dd/YYYY"}


    /**** data constants ****/
    enum SMART_LIST_CATEGORY_NAMES:String {
        case ALL = "All"
        case ALL_ALERTS = "All Alerts"
        case RETENTION = "Retention"
        case CLAIMS = "Claims"
        case LEADS = "Leads"
        case OTHER = "Other"
        case DELEGATED = "Delegated"
        case COMPLETED = "Completed"
    }
    
    /**** alert constants ****/
    class var ALERT_TITLE:String { return "Smart Alert" }
    class var ALERT_LOGIN_ERROR_MSG:String { return "Make sure you have entered a user name and password" }
    class var ALERT_LOGIN_SUCCESS_MSG:String { return "Congrats, you are now logged in!" }
    class var ALERT_LOGIN_FUNCTION_NOT_IMPLEMENTED_MSG:String { return "Sorry, this functionality has not been implemented" }
    class var ALERT_LOGOUT_CONFIRM_MSG:String { return "Are you sure you want to log out?" }
    class var ALERT_BUTTON_OK:String { return "OK" }
    class var ALERT_BUTTON_CANCEL:String { return "Cancel" }
    class var ALERT_NETWORK_ERROR_MSG:String { return "Remote service not avaiable now, please try later." }

    class var MAX_CHARACTER_ALERT_CONTENT:Int { return 150 }
    
    class var IMAGE_SIZE_LIMIT : Int {return 4000000}

    /**** data constants ****/
    class var DEFAULT_AGENT_ID: Int { return 3 }
    class var DEFAULT_ALERT_ID: Int { return 0 }

    /**** notification constants ****/
    class var NOTIFICATION_CATEGORY_DEFAULT: String { return "default" }
    class var NOTIFICATION_ACTION_ID_CALL: String { return "callActionId" }
    class var NOTIFICATION_ACTION_ID_EMAIL: String { return "emailActionId" }

    /**** service constants ****/
    class var INSURANCE_SERVER_URL: String { return "http://insuranceapi.mybluemix.net/" }
    class var INSURANCE_SERVER_URL_HOSTNAME: String { return "insuranceapi.mybluemix.net" }
    class var REQUEST_CONTENT_TYPE: String { return "application/json" }
    class var REQUEST_CHARSET: String { return "UTF-8" }

    /**** key constants ****/
    class var KEY_CURRENT_AGENT: String { return "current_agent" }
    
    /**** StoryBoard Id ****/
    class var AGENT_COLLECTIONVC_iPHONE: String { return "agentVc_iPhone" }
    class var AGENT_COLLECTIONVC_iPAD: String { return "agentCollectionVc_iPad" }
    
    class var CONTACT_FINSIHT_NAVCTRL: String { return "popOverNav" }
    class var CONTACT_FINSIHTVC: String { return "finishTVc" }
    class var CONTACT_FINSIH_NOTES_NAV: String { return "finishNotesNav" }
    class var CONTACT_FINSIH_NOTES_VC: String { return "finishNotesVc" }
    class var DELEGATE_VC: String { return "delegateVc" }
    class var COMPLETE_VC_iPHONE: String { return "completeVc" }
    class var PAYMENT_iPHONE: String { return "paymentVc_iPhone" }
    class var PAYMENT_iPAD: String { return "paymentVc_iPad" }
    class var NOCLIENT_NAVVC: String { return "noClientNavVc" }
    class var BILLINGVC: String { return "billingVc" }
    class var PRODUCT_OVERVIEWVc: String { return "productOverViewTVc" }
    class var RECOMMENDATION_TVC: String { return "recommendationTVc" }

    /**** Table View Cell ****/

    class var NOTES_CELL: String { return "notesTVCell" }
    class var STATUS_CELL: String { return "statusTVCell" }

    class var TAG_ACTION_FINISH:Int { return 103 }
    class var MULTICOLUMN_CELL:String { return "multiColumnCell" }
    class var PRODUCTDETAIL_CELL:String { return "prodDetailCell" }
    class var RECOMMENDATION_CELL:String { return "recommendationCell" }
    class var RECOMMENDATION_HEADER_CELL:String { return "recommendationHeaderCell" }

    /***** NSNotificationCenter *******/
    
    class var FORCE_UPDATEBADGE_NOTIFICATION: String { return "forceUpdateBadge" }
    
    class var PLACEHOLDER_NOTE:String { return "Enter new note" }

    //***** Payment Constants  ******/
    
    enum PaymentTypes: String {
        
        case Visa = "Visa", Mastercard = "Mastercard", American_Express = "American Express", Discover = "Discover", Bank_Account = "Bank Account"
        static let allValues = [Visa,Mastercard,American_Express,Discover,Bank_Account]
        
    }
    enum PaymentNumberType {
        case CardNumber,SecurityCode
    }
    enum MonthNames: String {
        
        case January = "January", February = "February", March = "March", April = "April", May = "May", June = "June", July = "July", August = "August", September = "September", October = "October", November = "November", December = "December"
        static let allValues = [January,February,March,April,May,June,July,August,September,October,November,December]
        
        static func numericalValue (aMonth: MonthNames) ->  String { //Find hex value of a Color
            switch aMonth {
            case .January:      return "01"
            case .February:     return "02"
            case .March:        return "03"
            case .April:        return "04"
            case .May:          return "05"
            case .June:         return "06"
            case .July:         return "07"
            case .August:       return "08"
            case .September:    return "09"
            case .October:      return "10"
            case .November:     return "11"
            case .December:     return "12"
            }
        }
    }
    
    class var AMEX_CREDIT_NUMBER_CARD_DIGITS:Int { return 15 }
    class var AMEX_CREDIT_NUMBER_SECURITY_DIGITS:Int { return 4 }
    class var OTHER_CREDIT_NUMBER_CARD_DIGITS:Int { return 16 }
    class var OTHER_CREDIT_NUMBER_SECURITY_DIGITS:Int { return 3 }
    
    enum DELEGATES_MODE:Int {
        case NORMAL
        case EDIT
    }
    
}

class dataFileSet:NSObject
{
    class var jsonFileSet:String {
        var settingsDataFileSet:String = NSUserDefaults.standardUserDefaults().objectForKey("dataSetType") as String
        return settingsDataFileSet
    }
    
    class var alertDetailsFile:String {
        if(self.jsonFileSet == "life"){
            return "LIFE_alert_details"
        }else{
            return "alert_details"
        }
    }
    
    class var clientDetailsFile:String {
        if(self.jsonFileSet == "life"){
            return "LIFE_client_details"
        }else{
            return "client_details"
        }
    }
    
    class var clientsFile:String {
        if(self.jsonFileSet == "life"){
            return "LIFE_clients"
        }else{
            return "clients"
        }
    }
    
    class var policyDetailsFile:String {
        if(self.jsonFileSet == "life"){
            return "LIFE_policy_details"
        }else{
            return "policy_details"
        }
    }
    
    class var smartlistAlertsFile:String {
        if(self.jsonFileSet == "life"){
            return "LIFE_smartlist_alerts"
        }else{
            return "smartlist_alerts"
        }
    }
}