//
//  AppDelegate.swift
//  STarBar
//
//  Created by CARL POOLE on 4/17/16.
//  Copyright © 2016 Carl Poole. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func login(sender: NSMenuItem) {
        
        // Put SmartThings login stuff here
        testPopup()
        
    }
    
    
    @IBAction func exit(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func testPopup(){
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = "Test"
        myPopup.runModal()
    }

}

