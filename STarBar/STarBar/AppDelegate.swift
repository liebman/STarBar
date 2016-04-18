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
    
    let settings: SettingsController! = SettingsController(windowNibName: "SettingsWindow")
    
    var deviceItems = [NSMenuItem]()
    var devices = Array<Dictionary<String, AnyObject>>()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let userPrefs = NSUserDefaults.standardUserDefaults()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        id = userPrefs.objectForKey("id") as! String
        token = userPrefs.objectForKey("token") as! String
        connect(NSMenuItem())
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
    
    func menuDeviceInit(){
    
        for device in devices {
            deviceItems.append(buildDeviceMenuItem(device))
        }
        
        statusMenu.insertItem(NSMenuItem.separatorItem(), atIndex: 0)
        
        for item in deviceItems {
            statusMenu.insertItem(item, atIndex: 0)
        }
    }

    func menuItemSelector(sender : NSMenuItem!){
        for device in devices {
            if(device["name"] as! String == sender.title){
                print(device["attributes"] as! NSDictionary)
                print(device["commands"] as! NSDictionary)
                print(device["deviceid"] as! String)
                
                let deviceId = device["deviceid"] as! String
                
                let reqURL = "\(rootURL)\(id)/\(deviceId)/command/on?access_token=\(token)"
                Alamofire.request(.POST, reqURL).responseJSON{
                    response in switch response.result {
                    case .Success(let JSON):
                        print("Success: \(JSON)")
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                    }
                }
            }
        }
    }
    
    @IBAction func connect(sender: NSMenuItem) {
        
        
        
        if (id != "") {
            let reqURL = "\(rootURL)\(id)/devices?access_token=\(token)"
            
            Alamofire.request(.GET, reqURL).responseJSON
                { response in switch response.result {
                case .Success(let JSON):
                    let responseJSON = JSON as! NSDictionary
                    self.devices = responseJSON.objectForKey("deviceList") as! Array<Dictionary<String, AnyObject>>
                    self.menuDeviceInit()
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
    
    func buildDeviceMenuItem(device: Dictionary<String, AnyObject>) -> NSMenuItem {
        let newItem = NSMenuItem.init()
        newItem.title = device["name"] as! String
        newItem.target = self
        newItem.action = #selector(AppDelegate.menuItemSelector)
        newItem.enabled = true
        return newItem
    }
    
    func testPopup(){
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = "Test"
        myPopup.runModal()
    }

}

