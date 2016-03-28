//
//  Regex.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/17/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import Foundation

let kRegexEmail: Regex = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"

let kRegexPassword: Regex = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,50})"

let kRegexZip: Regex = "^([0-9]{5}(-[0-9]{4})?|[a-z][0-9][a-z][- ][0-9][a-z][0-9])$"

struct Regex {
    
    let pattern: String
    
    let options: NSRegularExpressionOptions
    
    private var matcher: NSRegularExpression {
        
        return try! NSRegularExpression(pattern: pattern, options: options)
        
    }
    
    init(pattern: String, options: NSRegularExpressionOptions = []) {
        
        self.pattern = pattern
        
        self.options = options
        
    }
    
    func match(string: String, options: NSMatchingOptions = []) -> Bool {
        
        return matcher.numberOfMatchesInString(string, options: options, range: NSMakeRange(0, string.characters.count)) != 0
        
    }
    
}

extension Regex: StringLiteralConvertible {
    
    typealias ExtendedGraphemeClusterLiteralType = UnicodeScalarLiteralType
    
    typealias UnicodeScalarLiteralType = StringLiteralType
    
    init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        
        self.pattern = value
        
        self.options = []
        
    }
    
    init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        
        self.pattern = value
        
        self.options = []
        
    }
    
    init(stringLiteral value: StringLiteralType) {
        
        self.pattern = value
        
        self.options = []
        
    }
    
}

