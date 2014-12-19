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
    
    var seconds : NSTimeInterval = 59*60
    
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
        
        dateFormatter.dateFormat = "mm:ss"
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)
    }
    
    @IBAction func toggleTimer(sender: AnyObject) {
        if let started = startedAt {
            startedAt = nil
        } else {
            startedAt = NSDate()
        }
    }
    
    @IBAction func openPreferences(sender: AnyObject) {
        NSLog("--> open preferences")
    }
    
    func fireTimer() {
        var interval : NSTimeInterval = 0
        
        if let started = startedAt {
            interval = NSDate().timeIntervalSinceDate(started);
            if interval > seconds {
                NSLog("Time is up!!!")
                startedAt = nil
                interval = 0
                currentImage = wImage
            }
        } else {
            if currentImage == wImage {
                currentImage = bImage
            } else {
                currentImage = wImage
            }
        }
        let text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: seconds - interval))
        statusItem.button?.title = text
        
        statusItem.button?.image = currentImage

    }
}
