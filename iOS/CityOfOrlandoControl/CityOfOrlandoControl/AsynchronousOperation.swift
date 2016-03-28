//
//  AsynchronousOperation.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import Foundation

class AsynchronousOperation: NSOperation {
   
    private var _executing = false
    
    private var _finished = false
    
    override var executing: Bool {
        
        get {
            
            return _executing
            
        }
        
        set {
            
            if _executing != newValue {
                
                willChangeValueForKey("isExecuting")
                
                _executing = newValue
                
                didChangeValueForKey("isExecuting")
                
            }
            
        }
        
    }
    
    override var finished: Bool {
        
        get {
            
            return _finished
            
        }
        
        set {
            
            if _finished != newValue {
                
                willChangeValueForKey("isFinished")
                
                _finished = newValue
                
                didChangeValueForKey("isFinished")
                
            }
            
        }
        
    }
    
    override func start() {
        
        if finished  {
        
            return
        
        }
        
        if cancelled {
            
            finished = false
            
            return
            
        }
        
        executing = true
        
        main()
        
    }
    
    func finish() {
        
        executing = false
        
        finished = true
        
    }
    
    override var asynchronous: Bool {
        
        return true;
        
    }

}
