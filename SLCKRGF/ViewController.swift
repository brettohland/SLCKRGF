//
//  ViewController.swift
//  SLCKRGF
//
//  Created by brett ohland on 2015-02-28.
//  Copyright (c) 2015 ampersandsoftworks. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    private var users: NSArray?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Make a request to https://slack.com/api/rtm.start?token=xxxxxxxx&pretty=1
        // Gets everything we need.
        
        // Get the token from the keys.plist
        let plistPath = NSBundle.mainBundle().pathForResource("keys", ofType: "plist")
        
        if let path = plistPath {
            if let key = NSDictionary(contentsOfFile: path) {
                if let token = key["Slack API token"] as? String {
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


    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Default")
        
        if let currentUser = users?[indexPath.row] as? NSDictionary {
            cell.textLabel?.text = currentUser["name"] as! String
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var finalCount = 0
        
        if let count = users?.count {
            finalCount = count
        }
        
        return finalCount
    }
    
    
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

