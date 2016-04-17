//
//  TableViewController.swift
//  ON THE MAP
//
//  Created by liang on 4/16/16.
//  Copyright © 2016 liang. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableViewController{
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let first = appDelegate.locations[indexPath.row].firstName
        let last = appDelegate.locations[indexPath.row].lastName
        cell?.textLabel?.text = "\(first) \(last)"
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let link = appDelegate.locations[indexPath.row].mediaURL as? String{
            UIApplication.sharedApplication().openURL(NSURL(string: link)!)
        }
        
    }

}
