//
//  BLJAuthentication.swift
//  Bluejay
//
//  Created by Jack Cook on 3/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation

let attAppKey = "44oooscoert4xj3hbpztz0013minknuo"
let attAppSecret = "frqcjfuqnjr4yznxyeo3ybwn5tuxkjfk"
let attAuthURL = "https://api.att.com/oauth/token"
let attScope = "SPEECH"
var attAuthenticated = false

func authenticateAtt() {
    let authURL = NSURL(string: attAuthURL)!
    
    let request = NSMutableURLRequest(URL: authURL)
    let postString = "grant_type=client_credentials&scope=%@&client_id=%@&client_secret=%@"
    request.HTTPMethod = "POST"
    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
        let stuff = NSString(data: data, encoding: NSUTF8StringEncoding)!
        println(stuff)
    }
}
