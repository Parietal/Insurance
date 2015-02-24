//
//  AddPhotoOptionsTableViewController.swift
//  CaseWorker
//
//  Created by Paul Yuan on 2014-09-18.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

protocol AddPhotoOptionsPopoverDelegate {
    func closeAddPhotoOptions()
    func showPhotoLibrary()
    func showCamera()
}

class AddPhotoOptionsTableViewController:UITableViewController
{
    
    var delegate:AddPhotoOptionsPopoverDelegate?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row
        {
        case 1:
            self.delegate?.showCamera()
        default:
            self.delegate?.showPhotoLibrary()
        }
    }
    
    //for tableview top border
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    //for tableview top border
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let leftMargin:CGFloat = 0 //16
        var header:UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 1))
        var line:UIView = UIView(frame: CGRectMake(leftMargin, 0, header.frame.width, header.frame.height))
        line.backgroundColor = RAColors.GRAY4
        header.addSubview(line)
        return header
    }
    
}