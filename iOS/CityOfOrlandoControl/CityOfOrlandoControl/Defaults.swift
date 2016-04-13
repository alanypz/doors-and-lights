//
//  Defaults.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 4/12/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

let DefaultsAutoCloseNotification = "Defaults.AutoClose"
let DefaultsAutoRefreshNotification = "Defaults.AutoRefresh"

class Defaults: NSObject {

    class func register() {
    
        NSUserDefaults.standardUserDefaults().registerDefaults(["Defaults.AutoClose": false, "Defaults.AutoRefresh": false])
        
    }
    
    class var autoClose: Bool {
    
        get {

            return NSUserDefaults.standardUserDefaults().boolForKey("Defaults.AutoClose")
        
        }
        
        set {
        
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "Defaults.AutoClose")
            
            NSNotificationCenter.defaultCenter().postNotificationName(DefaultsAutoCloseNotification, object: nil, userInfo: ["newValue": newValue])
            
        }
    
    }
    
    class var autoRefresh: Bool {
        
        get {
            
            return NSUserDefaults.standardUserDefaults().boolForKey("Defaults.AutoRefresh")
            
        }
        
        set {
            
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "Defaults.AutoRefresh")
            
            NSNotificationCenter.defaultCenter().postNotificationName(DefaultsAutoRefreshNotification, object: nil, userInfo: ["newValue": newValue])
            
        }
        
    }
    
}
