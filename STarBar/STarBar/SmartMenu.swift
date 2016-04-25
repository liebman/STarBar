//
//  SmartMenu.swift
//  
//
//  Created by CARL POOLE on 4/24/16.
//
//

import Cocoa

class SmartMenu: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    let settings: SettingsController! = SettingsController(windowNibName: "SettingsWindow")
    @IBOutlet weak var settingsIcon: NSButton!
    @IBOutlet weak var smartTable: NSTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsIcon.image?.template = true
        smartTable.headerView = nil
        smartTable.setDelegate(self)
        smartTable.setDataSource(self)
    }
    
    @IBAction func openSettings(sender: NSButton) {
        settings.window?.center()
        settings.showWindow(nil)
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 3
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellIdentifier: String = "ThingID"
        
        if let cell = smartTable.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {

            return cell
        }
        
        return nil
    }
}
