//
//  LowerOperation.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class LowerOperation: ServerOperation {

    let type: ComponentType
    
    init(type: ComponentType) {
        
        self.type = type
        
    }
    
    var lowerCompletionBlock: ((error: NSError?) -> Void)?

    var statusCompletionBlock: ((component: Component?, error: NSError?) -> Void)?

    func createStatus() {
    
        let operation = StatusOperation(type: type)
        
        operation.statusCompletionBlock = statusCompletionBlock
        
        ServerCoordinator.sharedCoordinator.addOperation(operation)
    
    }
    
}

