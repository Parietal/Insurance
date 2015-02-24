//
//  ClientProfileIpadTableVC.swift
//  SmartAlertAction
//
//  Created by Abhilasha on 10/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class ClientProfileIpadTableVC: UIViewController , UITableViewDataSource, UITableViewDelegate, UITextViewDelegate{
    
    
    @IBOutlet weak var profileInfoTableView: UITableView!
    
    @IBOutlet weak var notesTableView: UITableView!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    
    var titleOfSections: [String] = ["PROFILE", "Add a New Note"]
    // class variables
    var titleOfContactInfo: [String] = ["Gender", "Marital Status", "Annualized Premium", "Retention Risk Score","Add a New Note"]
    
    var numOfNotes = 0
    var clientDetail: ClientModel?
    var clientId: Int = 0
    var alertId: Int = 1
    // activity indicator
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    
    let noteAdapter = CommonFunc.sharedInstanceNote
    let authorAdapter = CommonFunc.sharedInstanceAuthor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notesTableView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 85)
        
        // load client data
        self.loadData()
    }
    
    func loadData() {
        
        // show loading
        self.spinner.startAnimatingOnView(self.view)
        
        ClientService.getDetailsForClient(self.clientId, completionHandler: {(client:ClientModel?, error: NSError?) -> Void in
            
            // assign to client detail
            self.clientDetail = client
            
            if(self.clientDetail == nil){
                println("CLIENT NIL")
            }else{
                //Add here note from DB
                let notes_IN_DB = self.noteAdapter.getAllNoteDetail(self.clientId)
                if notes_IN_DB != nil {
                    for note in notes_IN_DB {
                        
                        let agentModel = AgentModel(id: Int(note.author.id), fName: note.author.fName, lName: note.author.lName, displayName: note.author.displayName, imageName:note.author.imageName,delegates: [], alertSettings: nil, book: nil, alerts: [])
                        
                        let accountNote = AccountNoteModel(id: Int(note.id), dateString: note.date, timeString: note.time, text: note.text, author: agentModel)
                        
                        self.clientDetail?.notes.append(accountNote)
                    }
                }
                
                
                
            }
            // set navigation title & color
            self.navigationItem.title = "Client Profile"
            self.navigationController?.navigationBar.tintColor = RAColors.DARK_BLUE
            
            // reset rows number
            self.numOfNotes = client!.notes.count
            
            // reload client data
            self.profileInfoTableView.reloadData()
            self.notesTableView.reloadData()
            self.setNotesViewScrollState()
            
            // hide loading
            self.spinner.stopAnimatingOnView()
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func settingsButtonTapped(sender: AnyObject) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateViewControllerWithIdentifier("AlertNotification") as UIViewController
            
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
        else{
            var controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as UISplitViewController
            
            controller.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            
            
            
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == self.profileInfoTableView){
            return 1
        }else{
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.clientDetail == nil){
            return 0
        }
        else {
            if(tableView == self.notesTableView){
                return self.numOfNotes
            }else if(tableView == self.profileInfoTableView){
                return 4
                // return self.clientDetail!.notes.count
            }else{
                return 0
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(tableView == profileInfoTableView){
            profileInfoTableView.separatorColor = RAColors.GRAY3
        }else if(tableView == notesTableView){
            notesTableView.separatorColor = RAColors.GRAY3
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cell: UITableViewCell?
        
        if(tableView == self.profileInfoTableView){
            if(indexPath.row == 3){
                var cellHeight : CGFloat = 0
                var notesStr = self.clientDetail!.rationaleModel?.text
                
                cellHeight = SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_15,labelSize: tableView.frame.size,labelText: "Retention Risk Score")
                
                var textht = SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_14,labelSize: tableView.frame.size,labelText: notesStr)
                cellHeight += textht + 10
                
                return cellHeight
            }else{
                return RASizes.DEFAULT_CELL_HEIGHT
            }
        }else if(tableView == self.notesTableView){
            var cellHeight : CGFloat = 90
            
            cellHeight = SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_15,labelSize: tableView.frame.size,labelText: self.clientDetail?.notes[indexPath.row].text)
            
            var textHt = SizeUtils.heightOfCell(RAFonts.HELVETICA_NEUE_REGULAR_15,labelSize: tableView.frame.size,labelText: self.clientDetail?.notes[indexPath.row].getNoteTitle())
            
            
            
            cellHeight += textHt
            
            return cellHeight
        }
        else{
            return RASizes.DEFAULT_CELL_HEIGHT
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if(tableView == self.profileInfoTableView){
            cell = self.initBasicInfoSection(cellForRowAtIndexPath: indexPath)
            profileInfoTableView.frame.size.height = 315
        }
        else if(tableView == notesTableView){
            cell = self.initAccountNotesSection(cellForRowAtIndexPath: indexPath)
        }
        else{
            cell = UITableViewCell()
        }
        
        return cell!
    }
    
    
    // basic info section
    func initBasicInfoSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = profileInfoTableView.dequeueReusableCellWithIdentifier("profileInfoCell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "profileInfoCell")
        }
        
        var row = indexPath.row
        // cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
        cell?.textLabel?.textColor = RAColors.GRAY8
        cell?.textLabel?.text = self.titleOfContactInfo[row]
        cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell?.detailTextLabel?.textColor = UIColor.blackColor()
        cell?.detailTextLabel?.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
        switch row {
        case 0:
            cell?.detailTextLabel?.text = self.clientDetail?.gender?.title
            if self.clientDetail?.gender?.title == nil {
                cell?.detailTextLabel?.text = "Gender"
            }
        case 1:
            var maritalStatus = self.clientDetail?.maritalStatus?.title
            cell?.detailTextLabel?.text = maritalStatus
            if self.clientDetail?.maritalStatus?.title == nil {
                cell?.detailTextLabel?.text = "Status"
            }
        case 2:
            var annualPremium = self.clientDetail?.annualizedPremium?.value
            cell?.detailTextLabel?.text = annualPremium
            if self.clientDetail?.annualizedPremium?.value == nil {
                cell?.detailTextLabel?.text = "Premium"
            }
        case 3:
            var retentionCell = profileInfoTableView.dequeueReusableCellWithIdentifier("retentionRiskCell") as? RetentionRiskCell
            retentionCell?.titleLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
            retentionCell?.titleLabel?.textColor = RAColors.GRAY8
            retentionCell?.titleLabel?.text = "Retention Risk Score"
            //retentionCell?.subtitleLabel?.text = self.clientDetail?.rationaleModel?.text
            retentionCell?.retentionRiskScore?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
           // retentionCell?.subtitleLabel?.numberOfLines = 0
           // retentionCell?.subtitleLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_14
           // retentionCell?.subtitleLabel?.textColor = RAColors.GRAY6
            retentionCell?.retentionRiskScore.font = RAFonts.HELVETICA_NEUE_MEDIUM_15
            let retentionRiskScore : Int! = self.clientDetail?.retentionRiskScore
            
            var str_retentionScore : String?
           
            if let retentionRiskScore = retentionRiskScore {
                str_retentionScore = String(retentionRiskScore)
            }
            retentionCell?.retentionRiskScore.text = str_retentionScore
            
            retentionCell?.addContent(self.clientDetail)
            
            return retentionCell!
            
            //        case 4:
            //            var actionCell = setActionCell(indexPath.row)
            //            return actionCell
        default:
            return cell!
        }
        
        return cell!
    }
    
    // account notes section
    func initAccountNotesSection(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        var row = indexPath.row
        
        var notes: AccountNoteModel? = self.clientDetail?.notes[row]
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "accountNotesCell")
        }
        
        //cell?.backgroundColor = RAColors.GRAY2
        cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_15
        cell?.detailTextLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        cell?.textLabel?.text = notes?.text
        cell?.detailTextLabel?.text = notes?.getNoteTitle()
        cell?.textLabel?.numberOfLines = 0
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.textColor = RAColors.GRAY7
        
        return cell!
    }
    
    //    func setActionCell(index: Int) -> UITableViewCell {
    //        var cell = profileInfoTableView.dequeueReusableCellWithIdentifier("addNoteCell") as? ActionButtonCell
    //        cell?.addNoteButton.titleLabel?.text = "Add a New note"
    //        return cell!
    //    }
    
    //MARK: View
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNoteButtons()
        
        addKeyBoardNotification()
        
        noteTextView.text = Constants.PLACEHOLDER_NOTE
        noteTextView.textColor = RAColors.GRAY4
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyBoardNotification()
    }
    //MARK: UITextView Delegate
    func textViewDidBeginEditing(textView: UITextView) {
        
        textView.text = ""
        textView.textColor = UIColor.blackColor()
        showNoteButtons()
    }
    func textViewDidEndEditing(textView: UITextView) {
        hideNoteButtons()
        noteTextView.text = Constants.PLACEHOLDER_NOTE
        noteTextView.textColor = RAColors.GRAY4
    }
    func textViewDidChange(textView: UITextView) {
    }
    //MARK: Note Button Action
    @IBAction func acceptButtonTapped(sender: AnyObject) {
        
        if noteTextView.text == Constants.PLACEHOLDER_NOTE || noteTextView.text == ""{
            
            CommonFunc.showAlert("", message: "Please enter some note")
            return
        }
        hideNoteButtons()
        
        
        let author = createAuthorObj()
        let note = createNoteObj(author)
        
        noteAdapter.insertNote()
        
        let agentModel = AgentModel(id: Int(note.author.id), fName: note.author.fName, lName: note.author.lName, displayName: note.author.displayName, imageName:note.author.imageName,delegates: [], alertSettings: nil, book: nil, alerts: [])
        
        let accountNote = AccountNoteModel(id: Int(note.id), dateString: note.date, timeString: note.time, text: note.text, author: agentModel)
        
        
        insertNote(accountNote)
        noteTextView.text = Constants.PLACEHOLDER_NOTE
        noteTextView.textColor = RAColors.GRAY4
        noteTextView.resignFirstResponder()

    }
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        hideNoteButtons()
        noteTextView.text = Constants.PLACEHOLDER_NOTE
        noteTextView.textColor = RAColors.GRAY4
        
        noteTextView.resignFirstResponder()
        
    }
    
    //MARK:- Notification
    private func addKeyBoardNotification() {
        
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    private func removeKeyBoardNotification() {
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardWillShow(notification:NSNotification) {
        
        
        resizeView(CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 100, self.view.frame.size.width, self.view.frame.size.height), animated: true)
    }
    func keyboardWillHide(notification:NSNotification) {
        
        
        resizeView(CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 100, self.view.frame.size.width, self.view.frame.size.height), animated: true)
        
    }
    //MARK - View
    func resizeView(viewFrame:CGRect,animated:Bool) {
        //(policy:PolicyModel?, error:NSError?)
        let duration:NSTimeInterval = animated ? 0.3 : 0
        
        UIView.animateWithDuration(duration, delay: duration, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {() -> Void in
            self.view.frame = viewFrame
            }, completion: {(finished:Bool) -> Void in
                if finished {
                }
        })
        
    }
    
    private func hideNoteButtons() {
        acceptButton.hidden = true
        cancelButton.hidden = true
    }
    private func showNoteButtons() {
        acceptButton.hidden = false
        cancelButton.hidden = false
    }
    
    private func createAuthorObj() -> Author {
        
        let loggedAgent = AgentModel.load(Constants.KEY_CURRENT_AGENT)!

        var author = authorAdapter.getAuthorDetail(loggedAgent.id)

        if author == nil {
            author = authorAdapter.createAuthor()
            
            author.id = loggedAgent.id
            author.fName = loggedAgent.fName
            author.lName = loggedAgent.lName
            author.imageName = loggedAgent.imageName
            author.displayName = loggedAgent.displayName
        }
        return author
    }
    
    private func createNoteObj(author:Author) -> Note {
        
        var note = noteAdapter.createNote()
        
        //Currently note Id is static, but in future change it to dynamic
        note.id = 9
        note.date = StringUtils.convertDateToString(NSDate(), isOnlyTime: false)
        note.time = StringUtils.convertDateToString(NSDate(), isOnlyTime: true)
        note.text = noteTextView.text
        note.clientId = self.clientId
        note.author = author
        
        return note
    }
    
    private func insertNote(accountNote:AccountNoteModel) {
        
        
        let notesCount = self.clientDetail?.notes.count
        
        notesTableView.beginUpdates()
        self.clientDetail?.notes.insert(accountNote, atIndex: 0)
        self.numOfNotes = self.clientDetail!.notes.count
        notesTableView.insertRowsAtIndexPaths(NSArray(object: NSIndexPath(forRow: 0, inSection: 0)), withRowAnimation: UITableViewRowAnimation.None)
        
        notesTableView.endUpdates()
        
        self.scrollTableViewToStart(true)
        self.setNotesViewScrollState()
    }
    
    private func scrollTableViewToStart(animated:Bool) {
        
        //let notesCount = self.clientDetail?.notes.count
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        notesTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
        
    }
    
    func setNotesViewScrollState() {

        //Check to see if data is onscreen.
        if (self.notesTableView.contentSize.height >= (self.notesTableView.frame.height-50) ){
           self.notesTableView.scrollEnabled = true
        }else{
            self.notesTableView.scrollEnabled = false
        }

        
    }
}

