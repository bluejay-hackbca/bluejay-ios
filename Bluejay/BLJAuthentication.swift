//
//  BLJAuthentication.swift
//  Bluejay
//
//  Created by Jack Cook on 3/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation
import SSKeychain
import SwiftyJSON

let attClientId = "44oooscoert4xj3hbpztz0013minknuo"
let attClientSecret = "frqcjfuqnjr4yznxyeo3ybwn5tuxkjfk"
let attAuthURL = "https://api.att.com/oauth/token"
let attScope = "SPEECH"
var attAuthenticated = false

var attAccessToken: String!

func authenticateAtt() {
    let url = NSURL(string: "https://api.att.com/oauth/token")!
    let request = NSMutableURLRequest(URL: url)
    let postString = "grant_type=client_credentials&scope=\(attScope)&client_id=\(attClientId)&client_secret=\(attClientSecret)"
    
    request.HTTPMethod = "POST"
    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    request.timeoutInterval = 30
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
        let json = JSON(data: data)
        if let refreshToken = json["refresh_token"].string {
            if let accessToken = json["access_token"].string {
                SSKeychain.setPassword(refreshToken, forService: "Bluejay", account: "ATT")
                attAccessToken = accessToken
            }
        }
    }
}
