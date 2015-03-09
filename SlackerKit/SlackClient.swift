//
//  SlackClient.swift
//  SLCKRGF
//
//  Created by brett ohland on 2015-03-06.
//  Copyright (c) 2015 ampersandsoftworks. All rights reserved.
//

import UIKit

public class SlackClient: NSObject {
    
    public static let sharedInstance = SlackClient()
    
    public func getUsersWithToken(token:String, success:(users:NSArray)->(), failure:(response:NSURLResponse)->(), failureWithError:(error:NSError)->()) {
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
                                success(users: users)
                            }
                        }
                        if let theJSONError = jsonError {
                            failureWithError(error: theJSONError)
                        }
                        
                    } else {
                        failure(response: httpResponse)
                    }
                } else {
                    failureWithError(error: error)
                }
            }).resume()
        }
    }
    
}
