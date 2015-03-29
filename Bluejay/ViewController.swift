//
//  ViewController.swift
//  Bluejay
//
//  Created by Jack Cook on 3/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ATTSpeechServiceDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "prepareSpeech", name: BJATTAuthenticatedNotification, object: nil)
    }
    
    func prepareSpeech() {
        let service = ATTSpeechService.sharedSpeechService()
        service.recognitionURL = NSURL(string: "https://api.att.com/speech/v3/speechToText")!
        service.delegate = self
        service.showUI = true
        service.speechContext = "Generic"
        service.bearerAuthToken = attAccessToken
        service.prepare()
        
        println("Audio service initialized")
    }
    
    @IBAction func beginRecognizing(sender: AnyObject) {
        let service = ATTSpeechService.sharedSpeechService()
        service.xArgs = ["main": "ClientScreen"]
        service.startListening()
    }
    
    func handleRecognition(recognizedText: String) {
        let escapedText = recognizedText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        println(recognizedText)
    }
    
    func speechServiceSucceeded(speechService: ATTSpeechService!) {
        let response = speechService.responseStrings
        var recognizedText = ""
        
        if response != nil && response.count > 0 {
            recognizedText = response[0] as String
        }
        
        if recognizedText != "" {
            self.handleRecognition(recognizedText)
        }
    }
    
    func speechService(speechService: ATTSpeechService!, failedWithError error: NSError!) {
        println("Speech service failed with error: \(error.localizedDescription)")
    }
}
