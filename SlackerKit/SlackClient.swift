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
    
    public func getUserListWith(token:String, success:(response:NSHTTPURLResponse, data:NSData)->(), failure:(error:NSError, url:NSURL)->()) {
        
        let slackURL = NSURL(string: "https://slack.com/api/rtm.start?token=\(token)&pretty=1")
        let session = NSURLSession.sharedSession()
        
        if let url = NSURL(string: "https://slack.com/api/rtm.start?token=\(token)&pretty=1") {
            
            session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                let httpResponse = response as! NSHTTPURLResponse
                let responseData = data as NSData
                
                if (error == nil) {
                    if ( httpResponse.statusCode == 200 ){
                        success(response: httpResponse, data: responseData)
                    } else {
                        success(response: httpResponse, data: responseData)
                    }
                } else {
                    failure(error: error, url: url)
                }
            }).resume()
        }
    }
    
}
