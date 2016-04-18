//
//  Settings.swift
//  STarBar
//
//  Created by CARL POOLE on 4/17/16.
//  Copyright © 2016 Carl Poole. All rights reserved.
//

import Cocoa

class SettingsController : NSWindowController {
    
    @IBOutlet weak var idField: NSTextField!
    @IBOutlet weak var tokenField: NSTextField!
    
    let userPrefs = NSUserDefaults.standardUserDefaults()
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let id = userPrefs.objectForKey("id") as! String
        let token = userPrefs.objectForKey("token") as! String
        
        if(id != ""){
            idField.stringValue = id
        }
        
        if(token != ""){
            tokenField.stringValue = token
        }
    }
    
    @IBAction func close(sender: NSButton) {
        close()
    }
    
    @IBAction func save(sender: NSButton) {
        userPrefs.setObject(idField.stringValue, forKey: "id")
        userPrefs.setObject(tokenField.stringValue, forKey: "token")
        close()
    }
    
}