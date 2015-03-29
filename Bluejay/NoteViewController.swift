//
//  ViewController.swift
//  Bluejay
//
//  Created by Jack Cook on 3/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import MMMarkdown
import UIKit

class NoteViewController: UIViewController, ATTSpeechServiceDelegate {
    
    @IBOutlet var noticeLabel: UILabel!
    @IBOutlet var webView: UIWebView!

    @IBOutlet var speechButton: UIButton!
    @IBOutlet var sbWidthConstraint: NSLayoutConstraint!
    @IBOutlet var sbRightConstraint: NSLayoutConstraint!
    @IBOutlet var sbBottomConstraint: NSLayoutConstraint!
    
    var fullText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = UIScreen.mainScreen().bounds
        let statusBarView = UIView(frame: CGRectMake(0, 0, device.width, 20))
        statusBarView.backgroundColor = UIColor(red: 0.11, green: 0.47, blue: 0.62, alpha: 1)
        self.view.addSubview(statusBarView)
        
        self.speechButton.enabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "prepareSpeech", name: BJATTAuthenticatedNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        let device = UIScreen.mainScreen().bounds.size
        sbWidthConstraint.constant = device.width / 6.44
        sbRightConstraint.constant = device.width / 22
        sbBottomConstraint.constant = device.width / 22
        
        let shadowPath = UIBezierPath(ovalInRect: self.speechButton.bounds)
        self.speechButton.layer.masksToBounds = false
        self.speechButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.speechButton.layer.shadowOffset = CGSizeMake(0, 2)
        self.speechButton.layer.shadowOpacity = 0.6
        self.speechButton.layer.shadowPath = shadowPath.CGPath
    }
    
    func renderMarkdown(markdown: String) {
        let source = MMMarkdown.HTMLStringWithMarkdown(markdown, extensions: .GitHubFlavored, error: nil)
        let path = NSBundle.mainBundle().pathForResource("github-markdown", ofType: "css")!
        let style = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
        let htmlStyle = "<style type=\"text/css\">\n" + style + "\n</style>"
        self.webView.loadHTMLString("<html><head>" + htmlStyle + "</head><body>" + source + "</body></html>", baseURL: nil)
    }
    
    func prepareSpeech() {
        let service = ATTSpeechService.sharedSpeechService()
        service.recognitionURL = NSURL(string: "https://api.att.com/speech/v3/speechToText")!
        service.delegate = self
        service.showUI = false
        service.speechContext = "Generic"
        service.bearerAuthToken = attAccessToken
        service.prepare()
        
        self.speechButton.enabled = true
    }
    
    @IBAction func beginRecognizing(sender: AnyObject) {
        self.beginSpeechRecognition()
    }
    
    func beginSpeechRecognition() {
        let service = ATTSpeechService.sharedSpeechService()
        service.startListening()
    }
    
    func handleRecognition(recognizedText: String) {
        self.renderMarkdown(recognizedText)
        
        let escapedText = recognizedText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
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
        
        self.noticeLabel.alpha = 0
    }
    
    func speechService(speechService: ATTSpeechService!, failedWithError error: NSError!) {
        println("Speech service failed with error: \(error.localizedDescription)")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
