//
//  UsersTableViewController.swift
//  SLCKRGF
//
//  Created by brett ohland on 2015-03-01.
//  Copyright (c) 2015 ampersandsoftworks. All rights reserved.
//

import UIKit

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
                // Key doesn't exist.
                println("Can't find keys.plist, did you create and add a keys.plist file?")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom methods
    
    func getUsersWithToken(token:String) {
        
        refreshControl?.beginRefreshing()
        
        let slackURL = NSURL(string: "https://slack.com/api/rtm.start?token=\(token)&pretty=1")
        let session = NSURLSession.sharedSession()
        
        if let url = NSURL(string: "https://slack.com/api/rtm.start?token=\(token)&pretty=1") {
            
            session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                let httpResponse = response as! NSHTTPURLResponse
                let responseData = data as NSData
                
                if (error == nil) {
                    
                    if ( httpResponse.statusCode == 200 ){
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
                        println("Returned HTTP code: \(httpResponse.statusCode)")
                        println("Raw response: \(response)")
                        
                    }
                } else {
                    let reason : String? = error.localizedDescription
                    println("Error reading from URL \(url) : \(reason)")
                }
                
                
            }).resume()
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

    @IBAction func refresh(sender: AnyObject) {
        if let token = slackToken {
            getUsersWithToken(token)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
