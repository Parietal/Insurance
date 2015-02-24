//
//  AccountNoteModel.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-02.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class AccountNoteModel
{
    
    var id:Int = -1
    var date:NSDate?
    var text:String = ""
    var author:AgentModel?
    
    init(id:Int, dateString:String, timeString:String, text:String, author:AgentModel) {
        self.id = id
        self.date = StringUtils.convertStringToDate(dateString, timeString: timeString)
        self.text = text
        self.author = author
    }
    
    func getNoteTitle() -> String {
        if self.date == nil {
            self.date = NSDate()
        }
        var noteDate: String = StringUtils.convertDateToString(self.date!, format: Constants.NOTE_DATE_TIME_FORMAT)
        var noteAuth: String = ""
        if let auth = self.author {
            noteAuth = auth.getFullName()
        }
        return noteDate + " by " + noteAuth
    }
    
}