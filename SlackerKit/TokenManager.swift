//
//  TokenManager.swift
//  SLCKRGF
//
//  Created by brett ohland on 2015-03-08.
//  Copyright (c) 2015 ampersandsoftworks. All rights reserved.
//

import UIKit

public class TokenManager: NSObject {
   
    public static let sharedInstance = TokenManager()
    
    public var slackToken:String? {
        get {
            let plistPath = NSBundle(forClass: object_getClass(self)).pathForResource("keys", ofType: "plist")
            var slackTokenFromBundle:String?
            if let path = plistPath {
                if let key = NSDictionary(contentsOfFile: path) {
                    if let token = key["Slack API token"] as? String {
                        slackTokenFromBundle = token
                    } else {
                        println("No 'Slack API Token' key in the keys.plist file, did you add it?")
                    }
                } else {
                    println("Can't find keys.plist, did you create and add a keys.plist file?")
                }
            }
            return slackTokenFromBundle ?? nil
        }
        
        set {
            
        }
    }
    
}
