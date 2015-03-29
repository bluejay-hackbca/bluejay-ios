//
//  AppDelegate.swift
//  Bluejay
//
//  Created by Jack Cook on 3/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        SpeechKit.setupWithID("NMDPPRODUCTION_Jack_Cook_Bluejay_20150329014408", host: "dhm.nmdp.nuancemobility.net", port: 443, useSSL: true, delegate: nil)
        
        return true
    }
}
