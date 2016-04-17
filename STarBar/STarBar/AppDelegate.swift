//
//  AppDelegate.swift
//  STarBar
//
//  Created by CARL POOLE on 4/17/16.
//  Copyright © 2016 Carl Poole. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    var deviceItems = [NSMenuItem]()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    func jsonLoaded(json: String) {
        print("JSON: \(json)")
    }
    
    func jsonFailed(error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
    @IBAction func connect(sender: NSMenuItem) {
        
        // Put SmartThings login stuff here
        menuDeviceInit()
        
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
    }
    
    @IBAction func disconnect(sender: NSMenuItem) {
        menuDeviceBreakdown()
    }
    
    @IBAction func exit(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func menuDeviceInit(){
        
        deviceItems.append(buildDeviceMenuItem("Test1"))
        deviceItems.append(buildDeviceMenuItem("Test2"))
        deviceItems.append(buildDeviceMenuItem("Test3"))
    
        for item in deviceItems {
            statusMenu.insertItem(item, atIndex: 0)
        }
    }
    
    func menuDeviceBreakdown(){
        for item in deviceItems {
            statusMenu.removeItem(item)
        }
        
        deviceItems.removeAll()
    }
    
    func buildDeviceMenuItem(itemText: String) -> NSMenuItem {
        let newItem = NSMenuItem.init()
        newItem.title = itemText
        return newItem
    }
    
    func testPopup(){
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = "Test"
        myPopup.runModal()
    }

}

