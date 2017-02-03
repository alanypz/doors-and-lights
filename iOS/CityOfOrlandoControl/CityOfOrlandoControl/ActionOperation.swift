//
//  ActionOperation.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class ActionOperation: ServerOperation {
    
    let type: ComponentType
    
    let action : Action
    
    let id: String
    
    let number: Int
    
    init(id: String, number: Int, action: Action, type: ComponentType) {
        
        self.id = id
        
        self.number = number
        
        self.action = action
        
        self.type = type
        
    }
    
    init(id: String, number: Int, type: ComponentType) {
        
        self.id = id
        
        self.number = number
        
        self.action = .Status
        
        self.type = type
        
    }
    
    var actionCompletionBlock: ((component: Component?, error: NSError?) -> Void)?
    
    override func main() {
        
        buildAction()
        
    }
    
    // MARK: - Action
    
    private func buildAction() {
        
        switch (action, type) {
            
        case (.Raise, .Door):
            
            let url = ServerCoordinator.Routes.doorsRaise()
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(["door": number], options: [])
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            requestAction(URLRequest: request)
            
        case (.Lower, .Door):
            
            let url = ServerCoordinator.Routes.doorsLower()
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(["door": number], options: [])
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            requestAction(URLRequest: request)
            
        case (.Stop, .Door):
            
            let url = ServerCoordinator.Routes.doorsStop()
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(["door": number], options: [])
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            requestAction(URLRequest: request)
            
        case (.Raise, .Light):
            
            let url = ServerCoordinator.Routes.lightsRaise()
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(["light": number], options: [])
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            requestAction(URLRequest: request)
            
        case (.Lower, .Light):
            
            let url = ServerCoordinator.Routes.lightsLower()
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(["light": number], options: [])
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            requestAction(URLRequest: request)
            
        default:
            
            buildStatus()
            
        }
        
    }
    
    private func requestAction(URLRequest request: NSURLRequest) {
        
        if !cancelled {
            
            session.dataTaskWithRequest(request) { [unowned self] (data, response, error) in
                
                do {
                    
                    let (data, _) = try self.checkResponse(data, response: response, error: error)
                    
                    try self.parseActionData(data)
                    
                }
                    
                catch let jsonError as NSError {
                    
                    self.finishWithError(jsonError)
                    
                }
                
                }.resume()
            
        }
        
    }
    
    func parseActionData(data: NSData) throws {
        
        guard let response = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else { throw NSError(description: "") }
        
        guard let success = response["success"] as? Bool where success else { throw NSError(description: "") }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC)), dispatch_get_main_queue()) { [weak self] in
            
            self?.buildStatus()
            
        }
        
    }
    
    // MARK: - Status
    
    func buildStatus() {
        
        switch (type) {
            
        case .Door:
            
            let url = ServerCoordinator.Routes.statusDoor()
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "GET"
            
            request.addValue(String(number), forHTTPHeaderField: "door")
            
            requestStatus(URLRequest: request)
            
        case .Light:
            
            let url = ServerCoordinator.Routes.statusLight()
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "GET"
            
            request.addValue(String(number), forHTTPHeaderField: "light")
            
            requestStatus(URLRequest: request)
            
        }
        
    }
    
    private func requestStatus(URLRequest request: NSURLRequest) {
        
        if !cancelled {
            
            session.dataTaskWithRequest(request) { [unowned self] (data, response, error) in
                
                do {
                    
                    let (data, _) = try self.checkResponse(data, response: response, error: error)
                    
                    try self.parseStatusData(data)
                    
                }
                    
                catch let jsonError as NSError {
                    
                    self.finishWithError(jsonError)
                    
                }
                
                }.resume()
            
        }
        
    }
    
    func parseStatusData(data: NSData) throws {
        
        guard let response = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else { throw NSError(description: "") }
        
        guard let component = Component(data: response) else { throw NSError(description: "") }
        
        switch (component.state, action, component.position) {
            
        case (.Stopped, .Stop, _):
            
            complete(component)
            
        case (.Stopped, _, .Error):
            
            finishWithError(NSError(description: "Component \(component.id) has stopped at an invalid position."))
            
        case (.Stopped, .Status, _):
            
            complete(component)
            
        case (.Stopped, .Raise, .Raised):
            
            complete(component)
            
        case (.Stopped, .Raise, .Lowered):
            
            finishWithError(NSError(description: "Component \(component.id) has stopped at unexpect position."))
            
        case (.Stopped, .Lower, .Lowered):
            
            complete(component)
            
        case (.Stopped, .Lower, .Raised):
            
            finishWithError(NSError(description: "Component \(component.id) has stopped at unexpect position."))
            
        default:
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { [weak self] in
                
                self?.buildStatus()
                
            }
            
        }
        
    }
    
    private func complete(component: Component) {
        
        if let completion = actionCompletionBlock where !cancelled {
            
            callbackQueue.addOperationWithBlock {
                
                completion(component: component, error: nil)
                
            }
            
        }
        
        finish()
        
    }
    
    override func finishWithError(error: NSError) {
        
        if let completion = actionCompletionBlock where !cancelled {
            
            callbackQueue.addOperationWithBlock {
                
                completion(component: nil, error: error)
                
            }
            
        }
        
        super.finishWithError(error)
        
    }
    
}

// MARK: - Action

extension ActionOperation {
    
    enum Action {
        
        case Raise, Lower, Stop, Status
        
    }
    
}

// MARK: - Type

extension ActionOperation {
    
    enum ComponentType {
        
        case Door, Light
        
    }
    
}

