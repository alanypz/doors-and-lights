//
//  ServerOperation.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import Foundation

class ServerOperation: AsynchronousOperation, NSURLSessionDelegate {
    
    var callbackQueue = NSOperationQueue.mainQueue()
    
    lazy var session: NSURLSession = {
        
        let configuration = ServerCoordinator.sharedCoordinator.sessionConfiguration
        
        var session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.currentQueue())
        
        return session
        
        }()
    
    override func finish() {
        
        session.invalidateAndCancel()
        
        super.finish()
        
    }

    override func cancel() {
        
        session.invalidateAndCancel()
        
        super.cancel()
        
    }

    var requiresAuthentication: Bool {
    
        return false
    
    }
    
    func finishWithError(error: NSError) {
        
        print("\(self.dynamicType) \(error)")
        
        finish()
    
    }
    
    final func checkResponse(data: NSData?, response: NSURLResponse?, error: NSError?) throws -> (NSData, NSHTTPURLResponse) {
        
        if let error = error {
            
            throw error
            
        }
        
        guard let data = data, response = response as? NSHTTPURLResponse else {
            
            throw NSError(description: "")
            
        }
        
        switch response.statusCode {
            
        case 200..<300:
            
            return (data, response)
            
        default:
            
            throw try parseError(data, code: response.statusCode)
            
        }
        
    }
    
    func parseError(data: NSData, code: Int) throws -> ErrorType {
        
        let response = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
                
        guard let error = response?["error"] as? [String: AnyObject], message = error["message"] as? String else { return NSError(description: "") }
        
        return NSError(description: message, code: error["status"] as? Int ?? code, reason: nil)
        
    }
    
    // MARK: - Date Parser
    
    private static var dateFormatter: NSDateFormatter = {
        
        let formatter =  NSDateFormatter()
        
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        return formatter
        
        } ()
    
    func parseDate(string: String?) -> NSDate? {
        
        guard let string = string else { return nil }
        
        return self.dynamicType.dateFormatter.dateFromString(string)
        
    }
    
    // MARK: - URLSession Delegate
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        let credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
        
        completionHandler(.UseCredential, credential)
        
    }
    
}