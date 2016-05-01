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
    
    let rootURL = "https://graph.api.smartthings.com/api/smartapps/installations/"
    var id = String()
    var token = String()
    var refreshOnly = Bool()
    let popover = NSPopover()
    var devices = Array<Dictionary<String, AnyObject>>()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let userPrefs = NSUserDefaults.standardUserDefaults()
    
    //Todo: Refactor menu code
    var deviceItems = [NSMenuItem]()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        if let button = statusItem.button {
            button.image = icon
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        
        id = userPrefs.objectForKey("id") as! String
        token = userPrefs.objectForKey("token") as! String
        
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
    
    func jsonLoaded(json: String) {
        print("JSON: \(json)")
    }
    
    func jsonFailed(error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
    @IBAction func connect(sender: NSMenuItem) {
        
        if (id != "") {
            let reqURL = "\(rootURL)\(id)/devices?access_token=\(token)"
            
            Alamofire.request(.GET, reqURL).responseJSON
                { response in switch response.result {
                case .Success(let JSON):
                    let responseJSON = JSON as! NSDictionary
                    self.devices = responseJSON.objectForKey("deviceList") as! Array<Dictionary<String, AnyObject>>
                    
                    if(!self.refreshOnly){
                        
                        //Todo: Refactor menu code
                        self.menuDeviceInit()
                        
                        self.refreshOnly = true
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    }
            }
        }
    }
    
    //Todo: Refactor menu code
    func menuDeviceInit(){
    
        for device in devices {
            deviceItems.append(buildDeviceMenuItem(device))
        }
        
        statusMenu.insertItem(NSMenuItem.separatorItem(), atIndex: 0)
        
        for item in deviceItems {
            statusMenu.insertItem(item, atIndex: 0)
        }
    }

    //Todo: Refactor menu code
    func menuItemSelector(sender : NSMenuItem!){
        for device in devices {
            if(device["name"] as! String == sender.title){
                print(device["attributes"] as! NSDictionary)
                print(device["commands"] as! NSDictionary)
                print(device["deviceid"] as! String)
                
                let attributes = device["attributes"] as! NSDictionary
                let deviceId = device["deviceid"] as! String
                
                var reqURL = String()
                
                if(attributes["switch"] != nil){
                    if(attributes["switch"] as! String == "off"){
                        reqURL = "\(rootURL)\(id)/\(deviceId)/command/on?access_token=\(token)"
                    }else{
                        reqURL = "\(rootURL)\(id)/\(deviceId)/command/off?access_token=\(token)"
                    }
                    
                    Alamofire.request(.POST, reqURL).responseJSON{
                        response in switch response.result {
                        case .Success(let JSON):
                            print("Success: \(JSON)")
                            self.connect(NSMenuItem())
                        case .Failure(let error):
                            print("Request failed with error: \(error)")
                        }
                    }
                }
                
            }
        }
    }
    
    //Todo: Refactor menu code
    @IBAction func disconnect(sender: NSMenuItem) {
        menuDeviceBreakdown()
    }
    
    //Todo: Refactor menu code
    func menuDeviceBreakdown(){
        
        for item in deviceItems {
            statusMenu.removeItem(item)
        }
        
        deviceItems.removeAll()
    }
    
    //Todo: Refactor menu code
    func buildDeviceMenuItem(device: Dictionary<String, AnyObject>) -> NSMenuItem {
        let newItem = NSMenuItem.init()
        newItem.title = device["name"] as! String
        newItem.target = self
        newItem.action = #selector(AppDelegate.menuItemSelector)
        newItem.enabled = true
        return newItem
    }

}

