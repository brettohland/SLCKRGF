//
//  InterfaceController.swift
//  SLCKRGF WatchKit Extension
//
//  Created by brett ohland on 2015-03-06.
//  Copyright (c) 2015 ampersandsoftworks. All rights reserved.
//

import WatchKit
import SlackerKit


class InterfaceController: WKInterfaceController {
    @IBOutlet var tableView: WKInterfaceTable!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()
        
        getUsers()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func getUsers(){
        if let slackToken = TokenManager.sharedInstance.slackToken {
            SlackClient.sharedInstance.getUsersWith(slackToken, success: { (users) -> () in
                self.populateTableWithUsers(users)
                }, failure: { (response) -> () in
                    println("Failure from server \(response.description)")
                }, failureWithError: { (error) -> () in
                    println("ERROR \(error.localizedDescription)")
            })
        }
    }
    
    func populateTableWithUsers(users:NSArray){
        tableView.setNumberOfRows(users.count, withRowType: "UsersTableRow")
        for (index, user) in enumerate(users) {
            let row = tableView.rowControllerAtIndex(index) as! UsersRowController
            if let userName = user["name"] as? String{
                row.userLabel.setText(userName)
            }
        }
    }



}
