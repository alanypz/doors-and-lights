//
//  Component.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 03/13/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class Component {

    let id: String
    
    let number: Int
    
    var state: State
    
    var position: Position
    
    init(id: String, number: Int, state: State, position: Position) {
        
        self.id = id
        
        self.number = number
        
        self.state = state
        
        self.position = position
        
    }
    
    convenience init?(data: [String: AnyObject]) {
    
        guard let id = data["_id"] as? String else { return nil }

        guard let number = data["number"] as? Int else { return nil }
        
        guard let statusText = data["state"] as? String, state = State(rawValue: statusText) else { return nil }
        
        guard let positionText = data["position"] as? String, position = Position(rawValue: positionText) else { return nil }

        self.init(id: id, number: number, state: state, position: position)
    
    }
    
}

// MARK: - State

extension Component {
    
    enum State: String {
        
        case Executing = "executing"
        
        case Stopped = "stopped"
        
    }
    
}

// MARK: - Position

extension Component {
    
    enum Position: String {
        
        case Raised = "raised"
        
        case Lowered = "lowered"
        
        case Error = "Error"
        
    }
    
}

class Door: Component {}

class Light: Component {}
