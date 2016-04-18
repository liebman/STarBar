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
    
    let settings: SettingsController! = SettingsController(windowNibName: "SettingsWindow")
    
    var deviceItems = [NSMenuItem]()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let userPrefs = NSUserDefaults.standardUserDefaults()

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
    
    @IBAction func openSettings(sender: NSMenuItem) {
        settings.showWindow(nil)
    }
    
    @IBAction func connect(sender: NSMenuItem) {
        
        let id = userPrefs.objectForKey("id") as! String
        let token = userPrefs.objectForKey("token") as! String
        
        if (id != "") {
            let reqURL = "https://graph.api.smartthings.com/api/smartapps/installations/\(id)/devices?access_token=\(token)"
            
            Alamofire.request(.GET, reqURL).responseJSON { response in
                let JSON = response.result.value
                print("JSON: \(JSON)")
            }
            
            menuDeviceInit()
            
        }
        else {// Show login
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
        
        statusMenu.insertItem(NSMenuItem.separatorItem(), atIndex: 0)
    
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

