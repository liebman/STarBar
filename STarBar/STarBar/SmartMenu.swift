//
//  SmartMenu.swift
//  
//
//  Created by CARL POOLE on 4/24/16.
//
//

import Cocoa

class SmartMenu: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var settingsIcon: NSImageView!
    @IBOutlet weak var smartTable: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsIcon.image?.template = true
        smartTable.headerView = nil
        smartTable.setDelegate(self)
        smartTable.setDataSource(self)
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
