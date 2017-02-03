//
//  InformationViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 4/12/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBAction func close(sender: UIButton) {
    
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
