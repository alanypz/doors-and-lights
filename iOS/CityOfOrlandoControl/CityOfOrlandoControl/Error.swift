//
//  Error.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

extension NSError {
    
    convenience init(description: String, code: Int = 9999, reason: String? = nil) {
        
        var info = [String: AnyObject]()
        
        info[NSLocalizedDescriptionKey] = description
        
        info[NSLocalizedFailureReasonErrorKey] = reason ?? ""
        
        self.init(domain: "Greenback", code: code, userInfo: info)
        
    }
    
}

    