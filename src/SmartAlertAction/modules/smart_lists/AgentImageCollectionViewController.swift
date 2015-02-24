//
//  AgentImageCollectionViewController.swift
//  AgentImage
//
//  Created by Saurav on 15/10/14.
//  Copyright (c) 2014 IBM Corporation. All rights reserved.
//

import UIKit


class AgentImageCollectionViewController: UICollectionViewController {
    
    let reuseIdentifier = "Cell"

    var numberOfItemInSection = 0
    var numberOfSection = 0
    var navigatoinBar:UINavigationBar!
    
    var spinner: RAActivityIndicatorView = RAActivityIndicatorView()
    var agentList:[PersonModel] = []
    var delegate:AgentImageViewDelegate?
    var alertId:Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        self.collectionView?.backgroundColor = RAColors.GRAY1
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            navigatoinBar = UINavigationBar(frame: CGRectMake(0, 10, self.view.frame.size.width, 44.0))
            
            var navigationItem = UINavigationItem(title: "Delegate")
            
            var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonTapped")
            navigationItem.rightBarButtonItem = cancelButton
            navigatoinBar.pushNavigationItem(navigationItem, animated: true)
            navigatoinBar.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            
            self.navigatoinBar.pushNavigationItem(navigationItem, animated: true)
            //self.view.addSubview(navigatoinBar)
            
            self.collectionView?.contentInset = UIEdgeInsetsMake(50, 10, 0, 0)
            
        }
        // Register cell classes

        self.collectionView?.registerClass(AgentCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.spinner.startAnimatingOnView(self.view)

        // get candidates from service
        DelegateService.getAllCandiates({ (agents, error) -> Void in
            
            if let agents = agents {
                self.agentList = agents
                self.refreshCollectionView()
            }

            // hide loading
            self.spinner.stopAnimatingOnView()
        })


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    func cancelButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.numberOfSection
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if self.numberOfSection == 1 {
            return self.agentList.count
        }
        if self.numberOfSection - 1 > section {
            return self.numberOfItemInSection
        }
        else {
            return self.agentList.count % self.numberOfItemInSection
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Configure the cell

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as AgentCollectionViewCell
        
        let index = indexPath.row + (self.numberOfItemInSection * indexPath.section)
        let agentModel = self.agentList[index]
        
        cell.agentImageView.image = UIImage(named: agentModel.imageName)
        cell.agentName.text = agentModel.getFullName()
        
        
        return cell
    }
    override func shouldAutorotate() -> Bool {
        refreshCollectionView()
        
        return true
    }
    override func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
            
            self._selectCell(indexPath)
            
            TimeUtils.PerformAfterDelay(0.1, completionHandler: {() -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                
                let index:Int = indexPath.row + (self.numberOfItemInSection * indexPath.section)
                let agentModel:PersonModel = self.agentList[index]
                self.delegate?.agentImageViewDelegateSelected(agentModel, forAlertId: self.alertId)
            })

    }

    //deselect all cells and select a cell
    func _selectCell(indexPath:NSIndexPath?)
    {
        //deselect all cells
        var cells:[AgentCollectionViewCell] = self.collectionView?.visibleCells() as [AgentCollectionViewCell]
        for i in 0..<cells.count {
            var cell:AgentCollectionViewCell = cells[i]
            cell.onDeselected()
        }
        
        //change the state of the selected cell
        if indexPath != nil {
            var cell:AgentCollectionViewCell = self.collectionView?.cellForItemAtIndexPath(indexPath!) as AgentCollectionViewCell
            cell.onSelected()
        }
    }
    
    //MARK: Orientation Work Around
    func refreshCollectionView() {

        if(UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait || UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.PortraitUpsideDown) {
            self.numberOfItemInSection = 5
            self.preferredContentSize.width = 748
        }
        else {
            self.numberOfItemInSection = 6
            self.preferredContentSize.width = 900
        }
        self.preferredContentSize.height = 330
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.numberOfItemInSection = self.agentList.count
            self.numberOfSection = 1
        }
        else {
            let remainder = self.agentList.count % numberOfItemInSection
            if remainder > 0 {
                self.numberOfSection = self.agentList.count / numberOfItemInSection + 1

            }
        }
        self.collectionView?.reloadData()

        self.preferredContentSize = preferredContentSize

    }
}
