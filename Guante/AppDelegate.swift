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

    let statusItem : NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(64.0)
    let dateFormatter : NSDateFormatter = NSDateFormatter()
    let workspace : NSWorkspace = NSWorkspace.sharedWorkspace()
    
    let wImage : NSImage = NSImage(named: "mitten-w")!
    let bImage : NSImage = NSImage(named: "mitten-b")!

    var timer : NSTimer? = nil
    var startedAt : NSDate? = nil
    var currentImage : NSImage? = nil
    var currentApp : NSRunningApplication? = nil
    
    var seconds : NSTimeInterval = 60*55
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
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
        
        workspace.notificationCenter.addObserver(
                self,
                selector: "onSwitchApp",
                name: NSWorkspaceDidActivateApplicationNotification,
                object: nil
        )
    
    }

    func onSwitchApp() {
        if(startedAt != nil) {
            currentApp = workspace.frontmostApplication
            if(currentApp != nil) {
                NSLog("--> current app: %@", currentApp!.bundleIdentifier!)
            }
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)
    }
    
    @IBAction func toggleTimer(sender: AnyObject) {
        if (startedAt != nil) {
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
            // timer is running.
            interval = NSDate().timeIntervalSinceDate(started)
            
            if interval > seconds {
                NSLog("--> time is up!!!")
                sendNotification()
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
    
    func sendNotification() {
        let userNotification:NSUserNotification = NSUserNotification()
        userNotification.title = "TIME IS UP"
        userNotification.subtitle = "Do something else"
        userNotification.contentImage = NSImage(named: "guante");
        userNotification.soundName = NSUserNotificationDefaultSoundName;
        
        NSUserNotificationCenter.defaultUserNotificationCenter().scheduleNotification(userNotification)
    }
    
}
