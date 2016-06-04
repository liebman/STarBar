//
//  Connection.swift
//  STarBar
//
//  Created by CARL POOLE on 5/29/16.
//  Copyright © 2016 Carl Poole. All rights reserved.
//

import Foundation
import Alamofire

class Connection {
    
    let rootURL = "https://graph.api.smartthings.com/api/smartapps/installations/"
    var id: String?
    var token: String?
    var devices: Array<Dictionary<String, AnyObject>>?
    var refreshOnly: Bool?

    @IBAction func connect(sender: NSMenuItem) {
        
        if (id != "") {
            let reqURL = "\(rootURL)\(id)/devices?access_token=\(token)"
            
            Alamofire.request(.GET, reqURL).responseJSON
                { response in switch response.result {
                case .Success(let JSON):
                    let responseJSON = JSON as! NSDictionary
                    self.devices = responseJSON.objectForKey("deviceList") as? Array<Dictionary<String, AnyObject>>
                    
                    if(!self.refreshOnly!){
                        
                        //Todo: Refactor menu code
                        // self.menuDeviceInit()
                        
                        self.refreshOnly = true
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    }
            }
        }
    }
    
    func switchOn(deviceId: String) -> Bool {
        let reqURL = "\(rootURL)\(id)/\(deviceId)/command/on?access_token=\(token)"
        var status: Bool!
        
        Alamofire.request(.POST, reqURL).responseJSON{
            response in switch response.result {
            case .Success(let JSON):
                print("Success: \(JSON)")
                status = true
            case .Failure(let error):
                print("Request failed with error: \(error)")
                status = false
            }
        }
        
        return status;
    }
    
    func switchOff(deviceId: String) -> Bool {
        let reqURL = "\(rootURL)\(id)/\(deviceId)/command/off?access_token=\(token)"
        var status: Bool!
        
        Alamofire.request(.POST, reqURL).responseJSON{
            response in switch response.result {
            case .Success(let JSON):
                print("Success: \(JSON)")
                self.connect(NSMenuItem())
                status = true
            case .Failure(let error):
                print("Request failed with error: \(error)")
                status = false
            }
        }
        
        return status;
    }
    
    func jsonLoaded(json: String) {
        print("JSON: \(json)")
    }
    
    func jsonFailed(error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
}