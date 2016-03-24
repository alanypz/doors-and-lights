//
//  StatusOperation.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class StatusOperation: ServerOperation {

    let type: ComponentType
    
    init(type: ComponentType) {
        
        self.type = type
        
    }
    
    var statusCompletionBlock: ((component: Component?, error: NSError?) -> Void)?

}

