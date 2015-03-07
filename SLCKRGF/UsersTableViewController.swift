//
//  UsersTableViewController.swift
//  SLCKRGF
//
//  Created by brett ohland on 2015-03-01.
//  Copyright (c) 2015 ampersandsoftworks. All rights reserved.
//

import UIKit
import SlackerKit

class UsersTableViewController: UITableViewController {

    private var users: NSArray?
    private var slackToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make a request to https://slack.com/api/rtm.start?token=xxxxxxxx&pretty=1
        // Gets everything we need.
        
        // Get the token from the keys.plist
        let plistPath = NSBundle.mainBundle().pathForResource("keys", ofType: "plist")
        
        if let path = plistPath {
            if let key = NSDictionary(contentsOfFile: path) {
                if let token = key["Slack API token"] as? String {
                    slackToken = token
                    getUsersWithToken(token)
                } else {
                    println("No 'Slack API Token' key in the keys.plist file, did you add it?")
                }
            } else {
                println("Can't find keys.plist, did you create and add a keys.plist file?")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom methods
    
    func getUsersWithToken(token:String) {
        
        refreshControl?.beginRefreshing()
        
        SlackClient.sharedInstance.getUserListWith(token, success: { (response, data) -> () in
            
                if ( response.statusCode == 200 ){
                    var jsonError: NSError?
                    
                    if let responseObject:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
                        if let users = responseObject.objectForKey("users") as? NSArray {
                            self.refreshControl?.endRefreshing()
                            self.users = users
                            self.tableView.reloadData()
                        }
                    }
                    if let theJSONError = jsonError {
                        let reason : String? = theJSONError.localizedDescription
                        println("Error decoing JSON: \(reason)")
                    }
                    
                } else {
                    println("Returned HTTP code: \(response.statusCode)")
                    println("Raw response: \(response)")
                    
                }
            
        }) { (error, url) -> () in
            let reason : String? = error.localizedDescription
            println("Error reading from URL \(url) : \(reason)")
        }
    
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UITableViewCell
        
        if let currentUser = users?[indexPath.row] as? NSDictionary{
            cell.textLabel?.text = currentUser["name"] as? String ?? ""
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK! - Outlet Actions

    @IBAction func refresh(sender: AnyObject) {
        if let token = slackToken {
            getUsersWithToken(token)
        }
    }

}
