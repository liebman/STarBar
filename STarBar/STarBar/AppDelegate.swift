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

    let popover = NSPopover()
    var devices = Array<Dictionary<String, AnyObject>>()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let userPrefs = NSUserDefaults.standardUserDefaults()
    let connection = Connection()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        if let button = statusItem.button {
            button.image = icon
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        
        connection.id = userPrefs.objectForKey("id") as? String
        connection.token = userPrefs.objectForKey("token") as? String
        
        popover.contentViewController = SmartMenu(nibName: "SmartMenu", bundle: nil)
        popover.animates = false
        popover.behavior = NSPopoverBehavior.Transient
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            NSApp.activateIgnoringOtherApps(true)
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
    }
    
    func getConnection() -> Connection {
        return connection
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func menuItemSelector(sender : NSMenuItem!){
        for device in devices {
            if(device["name"] as! String == sender.title){
                print(device["attributes"] as! NSDictionary)
                print(device["commands"] as! NSDictionary)
                print(device["deviceid"] as! String)
                
                let attributes = device["attributes"] as! NSDictionary
                let deviceId = device["deviceid"] as! String
                
                if(attributes["switch"] != nil){
                    if(attributes["switch"] as! String == "off"){
                        connection.switchOn(deviceId)
                    }else{
                        connection.switchOff(deviceId)
                    }
                    
                    
                }
                
            }
        }
    }
    
    func menuDeviceInit(){
    
//        for device in devices {
//            deviceItems.append(buildDeviceMenuItem(device))
//        }
//        
//        statusMenu.insertItem(NSMenuItem.separatorItem(), atIndex: 0)
//        
//        for item in deviceItems {
//            statusMenu.insertItem(item, atIndex: 0)
//        }
    }
    
    //Todo: Refactor menu code
    @IBAction func disconnect(sender: NSMenuItem) {
        menuDeviceBreakdown()
    }
    
    //Todo: Refactor menu code
    func menuDeviceBreakdown(){
        
//        for item in deviceItems {
//            statusMenu.removeItem(item)
//        }
//        
//        deviceItems.removeAll()
    }
    
    func buildDeviceMenuItem(device: Dictionary<String, AnyObject>) -> NSMenuItem {
        let newItem = NSMenuItem.init()
        newItem.title = device["name"] as! String
        newItem.target = self
        newItem.action = #selector(AppDelegate.menuItemSelector)
        newItem.enabled = true
        return newItem
    }

}

