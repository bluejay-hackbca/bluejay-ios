//
//  SpeechButton.swift
//  Bluejay
//
//  Created by Jack Cook on 3/29/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class SpeechButton: UIButton {
    
    override func drawRect(rect: CGRect) {
        let bgColor = UIColor(red: 0.11, green: 0.46, blue: 0.74, alpha: 1)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(context, rect)
        CGContextSetFillColor(context, CGColorGetComponents(bgColor.CGColor))
        CGContextFillPath(context)
        
        let microphoneImage = UIImage(named: "Microphone")
        let microphone = UIImageView(image: microphoneImage)
        
        let height = rect.height - 28
        let width = height * (73/128)
        microphone.frame = CGRectMake((rect.width - width) / 2, 14, height * (73/128), height)
        
        self.addSubview(microphone)
        
        self.clipsToBounds = false
        
        let shadowPath = UIBezierPath(ovalInRect: rect)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0, 2)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowPath = shadowPath.CGPath
    }
}
