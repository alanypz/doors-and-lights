//
//  ComponentCollectionViewCell.swift
//  CityOfOrlandoControl
//
//  Created by Jonathan Cools-Lartigue on 2/8/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class ComponentCollectionViewCell: UICollectionViewCell {
    
    override var selected: Bool {
    
        didSet {
        
            self.backgroundColor = selected ? UIColor.redColor() : UIColor.lightGrayColor()
        
        }
    
    }
    
}
