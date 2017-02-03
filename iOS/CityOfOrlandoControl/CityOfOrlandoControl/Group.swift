//
//  Group.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 02/18/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class Group {
    
    var title: String
    
    var components: [Component] = []
    
    init(title: String, components: [Component] = []) {
        
        self.title = title
        
        self.components = components

    }

    func numberOfComponents() -> Int {
    
        return components.count
    
    }
    
}

