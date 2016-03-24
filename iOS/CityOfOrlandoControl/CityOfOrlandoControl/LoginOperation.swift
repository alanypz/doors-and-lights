//
//  LoginOperation.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class LoginOperation: ServerOperation {
    
    let email: String
    
    let password: String
    
    var loginCompletionBlock: ((error: NSError?) -> Void)?
    
    init(email: String, password: String) {
        
        self.email = email
        
        self.password = password
        
        super.init()
        
    }
    
    override func main() {
        
        build()
        
    }
    
    private func build() {
        
        let url = ServerCoordinator.Routes.authenticate()
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let body = ["email": email, "password": password]
        
        let data = try! NSJSONSerialization.dataWithJSONObject(body, options: [])
        
        self.request(request, data: data)
        
    }
    
    private func request(request: NSURLRequest, data: NSData) {
        
        if !cancelled {
            
            session.uploadTaskWithRequest(request, fromData: data) { [unowned self] (data, response, error) in
                
                do {
                    
                    let (data, _) = try self.checkResponse(data, response: response, error: error)
                    
                    try self.parse(data)
                    
                }
                    
                catch let jsonError as NSError {
                    
                    self.finishWithError(jsonError)
                    
                }
                
                }.resume()
            
        }
        
    }
    
    private func parse(data: NSData) throws {
        
        guard let response = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else { throw NSError(description: "") }
        
        guard let token = response["token"] as? String else { throw NSError(description: "") }
        
        ServerCoordinator.sharedCoordinator.token = token
        
        complete()
        
    }
    
    private func complete() {
        
        if let completion = loginCompletionBlock where !cancelled {
            
            callbackQueue.addOperationWithBlock {
                
                completion(error: nil)
                
            }
            
        }
        
        finish()
        
    }
    
    override func finishWithError(error: NSError) {
        
        if let completion = loginCompletionBlock where !cancelled {
            
            callbackQueue.addOperationWithBlock {
                
                completion(error: error)
                
            }
            
        }
        
        super.finishWithError(error)
        
    }
    
}
