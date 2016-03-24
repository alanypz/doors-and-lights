//
//  ServerCoordinator.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class ServerCoordinator {
    
    static let sharedCoordinator = ServerCoordinator()
    
    class Routes {
    
        static let host = "http://localhost:8080"
        
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
    
    lazy var operationQueue: NSOperationQueue = {
        
        var operationQueue = NSOperationQueue()
        
        operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount
        
        operationQueue.name = "Server Coordinator Operation Queue"
        
        return operationQueue
        
        }()
    
    func addOperation(operation: ServerOperation) {
        
        operationQueue.addOperation(operation)
        
    }
    
    // MARK: - Session Configuration
    
    lazy var sessionConfiguration: NSURLSessionConfiguration = {
        
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        configuration.timeoutIntervalForRequest = 10
        
        return configuration
        
        }()
    
}

