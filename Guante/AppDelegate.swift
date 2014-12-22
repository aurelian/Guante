//
//  AppDelegate.swift
//  Guante
//
//  Created by Aurelian Oancea on 18/12/14.
//  Copyright (c) 2014 Aurelian Oancea. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem : NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let dateFormatter : NSDateFormatter = NSDateFormatter()
    
    let wImage : NSImage = NSImage(named: "mitten-w")!
    let bImage : NSImage = NSImage(named: "mitten-b")!

    var timer : NSTimer? = nil
    var startedAt : NSDate? = nil
    var currentImage : NSImage? = nil
    
    var seconds : NSTimeInterval = 60*60
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        wImage.setTemplate(true)
        bImage.setTemplate(true)
        
        currentImage = wImage
        
        statusItem.button?.imagePosition = NSCellImagePosition.ImageLeft
        
        statusItem.menu = statusMenu
        
        statusItem.highlightMode = true
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
            target: self,
            selector: Selector("fireTimer"),
            userInfo: nil,
            repeats: true)
        
        dateFormat()
        
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)
    }
    
    @IBAction func toggleTimer(sender: AnyObject) {
        if let started = startedAt {
            // stops the watch
            startedAt = nil
        } else {
            startedAt = NSDate()
            dateFormat()
        }
    }
    
    @IBAction func openPreferences(sender: AnyObject) {
        NSLog("--> open preferences")
    }
    
    func fireTimer() {
        var interval : NSTimeInterval = 0
        
        if let started = startedAt {
            interval = NSDate().timeIntervalSinceDate(started)
            if interval > seconds {
                NSLog("--> time is up!!!")
                startedAt = nil
                interval = 0
            }
        } else {
            blinkImage()
        }
        
        let date:NSDate = NSDate(timeIntervalSince1970: seconds - interval)
        
        let text = dateFormatter.stringFromDate(date)
        statusItem.button?.title = text
    }
    
    func blinkImage() {
        if currentImage == wImage {
            currentImage = bImage
        } else {
            currentImage = wImage
        }
        statusItem.button?.image = currentImage
    }
    
    func dateFormat() {
        if seconds >= 60*60 {
            dateFormatter.dateFormat = "HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "mm:ss"
        }
    }
}
