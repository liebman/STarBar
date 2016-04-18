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
    var responseJSON = NSDictionary()
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
        settings.window?.center()
        settings.showWindow(nil)
    }
    
    func menuDeviceInit(JSON : NSDictionary){
        
        let devices = JSON.objectForKey("deviceList") as! Array<Dictionary<String, AnyObject>>
        
        for device in devices {
            deviceItems.append(buildDeviceMenuItem(device["name"] as! String))
        }
        
        print(devices)
        
        statusMenu.insertItem(NSMenuItem.separatorItem(), atIndex: 0)
        
        for item in deviceItems {
            statusMenu.insertItem(item, atIndex: 0)
        }
    }
    
    @IBAction func connect(sender: NSMenuItem) {
        
        let id = userPrefs.objectForKey("id") as! String
        let token = userPrefs.objectForKey("token") as! String
        
        if (id != "") {
            let reqURL = "https://graph.api.smartthings.com/api/smartapps/installations/\(id)/devices?access_token=\(token)"
            
            Alamofire.request(.GET, reqURL).responseJSON
                { response in switch response.result {
                case .Success(let JSON):
                    let responseJSON = JSON as! NSDictionary
                    self.menuDeviceInit(responseJSON)
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
    
    @IBAction func disconnect(sender: NSMenuItem) {
        menuDeviceBreakdown()
    }
    
    @IBAction func exit(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
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

