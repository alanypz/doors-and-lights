//
//  ServerCoordinator.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

let ComponentStatusNotification = "ComponentStatus"
let ComponentStatusNotificationComponentKey = "component"
let ComponentStatusNotificationIdKey = "id"
let ComponentStatusNotificationErrorKey = "error"

class ServerCoordinator {
    
    static let sharedCoordinator = ServerCoordinator()
    
    class Routes {
        
        static let host =  "http://localhost:8080"
//      static let host =  "http://10.0.1.5:8080" //  Local IP access
//        static let host =  "http://10.0.0.2:8080"   // NETGEAR09, dynamicjade566
//        static let host =  "http://192.168.43.12:8080"   // Marcus
//        static let host =  "http://192.168.1.100:8080"   // Bryers
//        static let host =  "http://192.168.1.106:8080"   // Justin
//        static let host =  "http://192.168.1.2:8080"   // NETGEAR09, manictomato309

    
        class func authenticate() -> NSURL {
            
            return NSURL(string: "\(host)/authenticate")!
            
        }
        
        class func statusLight() -> NSURL {
            
            return NSURL(string: "\(host)/status/light")!
            
        }
        
        class func statusDoor() -> NSURL {
            
            return NSURL(string: "\(host)/status/door")!
            
        }
        
        class func lightsLower() -> NSURL {
            
            return NSURL(string: "\(host)/lights/lower")!
            
        }
        
        class func lightsRaise() -> NSURL {
            
            return NSURL(string: "\(host)/lights/raise")!
            
        }
        
        class func doorsLower() -> NSURL {
            
            return NSURL(string: "\(host)/doors/lower")!
            
        }
        
        class func doorsRaise() -> NSURL {
            
            return NSURL(string: "\(host)/doors/raise")!
            
        }
        
        class func doorsStop() -> NSURL {
            
            return NSURL(string: "\(host)/doors/stop")!
            
        }
        
        class func calibrate() -> NSURL {
            
            return NSURL(string: "\(host)/calibrate")!
            
        }
        
    }
    
    var token: String? {
        
        didSet {
            
            if let token = token {
                
                sessionConfiguration.HTTPAdditionalHeaders = ["Authorization": token]
                
            }
                
            else {
                
                sessionConfiguration.HTTPAdditionalHeaders = nil
                
            }
            
        }
        
    }
    
    // MARK: - Authentication
    
    func isAuthenticated() -> Bool {
        
        return token != nil
        
    }
    
    // MARK: - Operation Queue
    
    var actionOperation: ActionOperation?
    
    func canAddComponentsOperation() -> Bool {
    
        return operationQueue.operations.indexOf({ $0.isMemberOfClass(ComponentsOperation.self) }) == nil

    }
    
    func canAddActionOperation() -> Bool {
        
        return actionOperation == nil
        
    }
    
    func cancelActionOperation() {
    
        if let operation = actionOperation {
        
            operation.cancel()
        
        }
        
        actionOperation = nil
    
    }

    func cancelAllOperations() {
    
        operationQueue.cancelAllOperations()
      
        actionOperation = nil

    }
    
    lazy var operationQueue: NSOperationQueue = {
        
        var operationQueue = NSOperationQueue()
        
        operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount
        
        operationQueue.name = "Server Coordinator Operation Queue"
        
        return operationQueue
        
    }()
    
    func addOperation(operation: ServerOperation) -> Bool {
        
        switch (operation, actionOperation) {
            
        case (_ as ActionOperation, _?):
            
            return false
            
        case let (operation as ActionOperation, nil):
            
            actionOperation = operation
            
            operation.actionCompletionBlock = { [weak self] (component, error) in
                
                switch (self, component, error) {
                    
                case let (coordinator?, component?, nil):
                    
                    coordinator.actionOperation = nil
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(ComponentStatusNotification, object: coordinator, userInfo: [ComponentStatusNotificationComponentKey: component])
                    
                case let (coordinator?, nil, error?):
                    
                    coordinator.actionOperation = nil
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(ComponentStatusNotification, object: coordinator, userInfo: [ComponentStatusNotificationIdKey: operation.id, ComponentStatusNotificationErrorKey: error])
                    
                default:
                    
                    break
                    
                }
                
            }
            
            operationQueue.addOperation(operation)
            
            return true
            
        default:
            
            operationQueue.addOperation(operation)
            
            return true
            
        }
        
    }
    
    // MARK: - Session Configuration
    
    lazy var sessionConfiguration: NSURLSessionConfiguration = {
        
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        configuration.timeoutIntervalForRequest = 35
        
        return configuration
        
    } ()
    
}

