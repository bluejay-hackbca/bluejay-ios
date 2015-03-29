//
//  MainViewController.swift
//  Bluejay
//
//  Created by Jack Cook on 3/29/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 32, 0, 0)
        
        let device = UIScreen.mainScreen().bounds
        let statusBarView = UIView(frame: CGRectMake(0, 0, device.width, 20))
        statusBarView.backgroundColor = UIColor(red: 0.11, green: 0.47, blue: 0.62, alpha: 1)
        self.view.addSubview(statusBarView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as UITableViewCell
        
        let nameLabel = cell.viewWithTag(10) as UILabel
        nameLabel.text = "History Class"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("noteSegue", sender: self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
