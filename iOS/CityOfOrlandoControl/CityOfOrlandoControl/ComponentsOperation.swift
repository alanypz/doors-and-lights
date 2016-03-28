//
//  ComponentsOperation.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class ComponentsOperation: ServerOperation {
    
    var components: [Component] = []
    
    var componentsCompletionBlock: ((components: [Component]?, error: NSError?) -> Void)?
    
    override func main() {
        
        build()
        
    }
    
    private func build() {
        
        requestLight()
        
    }
    
    private func requestLight() {
        
        if !cancelled {
            
            let url = ServerCoordinator.Routes.statusLight()

            session.dataTaskWithURL(url) { [unowned self] (data, response, error) in
                
                do {
                    
                    let (data, _) = try self.checkResponse(data, response: response, error: error)
                    
                    try self.parseLightData(data)
                    
                }
                    
                catch let jsonError as NSError {
                    
                    self.finishWithError(jsonError)
                    
                }
                
                }.resume()
            
        }
        
    }
    
    private func requestDoor() {
        
        if !cancelled {
            
            let url = ServerCoordinator.Routes.statusDoor()

            session.dataTaskWithURL(url) { [unowned self] (data, response, error) in
                
                do {
                    
                    let (data, _) = try self.checkResponse(data, response: response, error: error)
                    
                    try self.parseDoorData(data)
                    
                }
                    
                catch let jsonError as NSError {
                    
                    self.finishWithError(jsonError)
                    
                }
                
                }.resume()
            
        }
        
    }
    
    func parseLightData(data: NSData) throws {
        
        guard let response = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]] else { throw NSError(description: "") }
        
        components.appendContentsOf(response.flatMap { Light(data: $0) })
        
        requestDoor()
        
    }
    
    func parseDoorData(data: NSData) throws {
        
        guard let response = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]] else { throw NSError(description: "") }
        
        components.appendContentsOf(response.flatMap { Door(data: $0) })
        
        complete(components)
        
    }
    
    private func complete(components: [Component]) {
        
        if let completion = componentsCompletionBlock where !cancelled {
            
            callbackQueue.addOperationWithBlock {
                
                completion(components: components, error: nil)
                
            }
            
        }
        
        finish()
        
    }
    
    override func finishWithError(error: NSError) {
        
        if let completion = componentsCompletionBlock where !cancelled {
            
            callbackQueue.addOperationWithBlock {
                
                completion(components: nil, error: error)
                
            }
            
        }
        
        super.finishWithError(error)
        
    }
    
}
