//
//  FinishNotesViewController.swift
//  SmartAlertAction
//
//  Created by Saurav on 28/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

protocol FinishNoteDelegate {
    func didFinishNote()
}
class FinishNotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var finishTableView: UITableView!
    
    var alertId: Int = Constants.DEFAULT_ALERT_ID
    var alertDetail: AlertModel?
    var delegate: FinishNoteDelegate?

    private var selectedRow = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelBtnTapped(sender: AnyObject) {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    @IBAction func doneBtnTapped(sender: AnyObject) {
        
        let cell = finishTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as NotesTableViewCell
        if cell.notesTextField.text == "" {
            UIAlertView(title: "", message: "Please enter some note", delegate: nil, cancelButtonTitle: "OK").show()
            return

        }
        
        //Find which cell is selected or find status
        let cellCompleted = finishTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
        let cellNotCompleted = finishTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
        
        if(cellCompleted?.accessoryType == UITableViewCellAccessoryType.Checkmark) {
            markAsComplete(cell.notesTextField.text, isDestructive: false)
        }
        else if(cellNotCompleted?.accessoryType == UITableViewCellAccessoryType.Checkmark) {
            markAsComplete(cell.notesTextField.text, isDestructive: true)
 
        }
        else {
            UIAlertView(title: "", message: "Please select status", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }

    }
    
    // MARK: - UITableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "NOTES"
        case 1:
            return "STATUS"
        default:
            return ""
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        
        var titleLabel = UILabel(frame: CGRect(x: 17, y: 15, width: 100, height: view.frame.size.height))
        titleLabel.font = RAFonts.HELVETICA_NEUE_REGULAR_14
        titleLabel.textColor = RAColors.GRAY8
        
        switch section {
        case 0:
            titleLabel.text = "NOTES"
        case 1:
            titleLabel.text = "STATUS"
        default:
            titleLabel.text = ""
        }
        view.addSubview(titleLabel)

        view.backgroundColor = UIColor.clearColor()
        return view
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 2
            default:
                return 1
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var cell: UITableViewCell?
        //NOTES_CELL
        switch indexPath.section {
            case 0:
            
                let noteCell = tableView.dequeueReusableCellWithIdentifier(Constants.NOTES_CELL, forIndexPath: indexPath) as NotesTableViewCell
                noteCell.notesTextField.delegate = self
                //UITextAutocapitalizationType.Words
                noteCell.notesTextField.autocapitalizationType = UITextAutocapitalizationType.Sentences

                if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    noteCell.notesTextField.placeholder = "Type here"
                }
                else {
                    noteCell.notesTextField.placeholder = "Type here (40 characters max)"
                }
                // Configure the cell...
                return noteCell
            
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier(Constants.STATUS_CELL, forIndexPath: indexPath) as? UITableViewCell

                if  indexPath.row == 0 {
                    if selectedRow == indexPath.row {
                        cell?.textLabel?.textColor = RAColors.BLUE1
                        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                    else {
                        cell?.textLabel?.textColor = UIColor.blackColor()
                        cell?.accessoryType = UITableViewCellAccessoryType.None
                    }
                }
                else {
                    if selectedRow == indexPath.row {
                        cell?.textLabel?.textColor = RAColors.RED1
                        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                    else {
                        cell?.textLabel?.textColor = UIColor.blackColor()
                        cell?.accessoryType = UITableViewCellAccessoryType.None
                    }
                }
                cell?.textLabel?.font = RAFonts.HELVETICA_NEUE_REGULAR_16
                cell?.textLabel?.text = indexPath.row == 0 ? "Complete" : "Not Complete"
                return cell!
            default:
                return cell!
        }
    }
    
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        switch indexPath.section
        {
        case 1:
            
            selectedRow = indexPath.row
            let range = NSMakeRange(1, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            tableView.reloadSections(sectionToReload, withRowAnimation: UITableViewRowAnimation.Automatic)
          
            /*
            switch indexPath.row {
            case 0:
                if(cell?.accessoryType == UITableViewCellAccessoryType.None)
                {
                    let otherIndexPath = NSIndexPath(forRow: 1, inSection: indexPath.section)
                    let otherCell = tableView.cellForRowAtIndexPath(otherIndexPath)
                    otherCell?.accessoryType = UITableViewCellAccessoryType.None
                    tableView.reloadRowsAtIndexPaths(NSArray(object: otherIndexPath), withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                    cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                    break
                }
            case 1:
                if(cell?.accessoryType == UITableViewCellAccessoryType.None)
                {
                    let otherIndexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
                    let otherCell = tableView.cellForRowAtIndexPath(otherIndexPath)
                    otherCell?.accessoryType = UITableViewCellAccessoryType.None
                    tableView.reloadRowsAtIndexPaths(NSArray(object: otherIndexPath), withRowAnimation: UITableViewRowAnimation.Automatic)
                    cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                    break
                }
                break
            default:
                break
            }
            */

        default:
            break
        }
    }
    
    //MARK: -
    func markAsComplete(note:String, isDestructive:Bool) {
        let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
        var alert:Alert!
        
        alert = alertAdapter.getAlertDetail(alertDetail?.id, categoryId: alertDetail?.category?.id)
        
        if let alertObj = alert {
            
            if alertObj.status == "Completed" {
                //If it comes here, something is wrong, as it should not....as alert is finished already
                return
            }
        }
        else {
            
            //Create Alert Object in DB via CoreData(Entity - Alert)
            
            alert = alertAdapter.createAlert()
            alert.id = NSNumber(integer: self.alertId)
            
        }
        
        alert.date = NSDate()
        let dateString : String = StringUtils.convertDateToString(alert.date, format: Constants.FINISH_NOTE_DATE)
        
        alert.status = isDestructive ? "NotCompleted" : "Completed"
        //alert.finishNote = dateString + " " + CommonFunc.capitalizeFirstChar(note)

        alert.finishNote = dateString + " " + note

        var category: AlertCategoryModel = alertDetail!.category!
        
        alert.categoryId = NSNumber(integer:category.id)
        alert.isDestructive = isDestructive
        
        alertAdapter.insertAlert()
        
        if self.delegate != nil {
            self.delegate?.didFinishNote()
        }
    }
    
    //MARK: UITextField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        let noteCell = finishTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as NotesTableViewCell
        let textLength = countElements(noteCell.notesTextField.text) + countElements(string) - range.length
        
        return textLength > 40 ? false : true
    }
}
