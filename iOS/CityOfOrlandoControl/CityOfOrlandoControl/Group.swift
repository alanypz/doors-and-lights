//
//  Group.swift
//  CityOfOrlandoControl
//
//  Created by Jonathan Cools-Lartigue on 2/8/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class Group {
    
    var title: String
    
    var components: [Component] = []
    
    init(title: String, components: [Component]) {
        
        self.title = title
        
        self.components = components

    }

    func numberOfComponents() -> Int {
    
        return components.count
    
    }
    
}

class Component {
    
    enum Status {
        
        case Raised, Lowered, Raising, Lowering, Unknown, Error
        
    }
    
    let name: String
    
    let garage: Int
    
    let bay: Int
    
    let side: String
    
    var status: Status

    init(name: String, garage: Int, bay: Int, side: String, status: Status) {
    
        self.name = name
        
        self.garage = garage
        
        self.bay = bay
        
        self.side = side
        
        self.status = status
        
    }
    
}