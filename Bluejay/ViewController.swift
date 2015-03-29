//
//  ViewController.swift
//  Bluejay
//
//  Created by Jack Cook on 3/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import MMMarkdown
import UIKit

class ViewController: UIViewController, ATTSpeechServiceDelegate {
    
    @IBOutlet var webView: UIWebView!

    @IBOutlet var speechButton: SpeechButton!
    @IBOutlet var sbWidthConstraint: NSLayoutConstraint!
    @IBOutlet var sbRightConstraint: NSLayoutConstraint!
    @IBOutlet var sbBottomConstraint: NSLayoutConstraint!
    
    var fullText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://raw.githubusercontent.com/jackcook/GCHelper/master/README.md")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            let content = NSString(data: data, encoding: NSUTF8StringEncoding) as String
            let source = MMMarkdown.HTMLStringWithMarkdown(content, extensions: .GitHubFlavored, error: nil)
            
            let path = NSBundle.mainBundle().pathForResource("github-markdown", ofType: "css")!
            let style = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
            let htmlStyle = "<style type=\"text/css\">\n" + style + "\n</style>"
            self.webView.loadHTMLString("<html><head>" + htmlStyle + "</head><body>" + source + "</body></html>", baseURL: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "prepareSpeech", name: BJATTAuthenticatedNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        let device = UIScreen.mainScreen().bounds.size
        sbWidthConstraint.constant = device.width / 6.44
        sbRightConstraint.constant = device.width / 22
        sbBottomConstraint.constant = device.width / 22
    }
    
    func prepareSpeech() {
        let service = ATTSpeechService.sharedSpeechService()
        service.recognitionURL = NSURL(string: "https://api.att.com/speech/v3/speechToText")!
        service.delegate = self
        service.showUI = false
        service.speechContext = "Generic"
        service.bearerAuthToken = attAccessToken
        service.prepare()
        
        println("Audio service initialized")
    }
    
    @IBAction func beginRecognizing(sender: AnyObject) {
        self.beginSpeechRecognition()
    }
    
    func beginSpeechRecognition() {
        let service = ATTSpeechService.sharedSpeechService()
        service.startListening()
    }
    
    func handleRecognition(recognizedText: String) {
        self.webView.loadHTMLString(recognizedText, baseURL: nil)
        
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
