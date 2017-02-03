//
//  FilterViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/19/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    @IBOutlet weak var doorSwitch: UISwitch!
    
    @IBOutlet weak var lightSwitch: UISwitch!
    
    @IBOutlet weak var raisedSwitch: UISwitch!
    
    @IBOutlet weak var loweredSwitch: UISwitch!
    
    @IBOutlet weak var errorSwitch: UISwitch!
    
    var filter: Filter!
    
    var completionBlock: ((filter: Filter) -> Void)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        doorSwitch.on = filter.doors
        
        lightSwitch.on = filter.lights
        
        raisedSwitch.on = filter.raised
        
        loweredSwitch.on = filter.lowered
        
        errorSwitch.on = filter.errors
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        preferredContentSize = tableView.contentSize

    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        
        completionBlock?(filter: filter)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}

// MARK: - Switch

extension FilterTableViewController {
    
    
    @IBAction func doorsToggle(sender: UISwitch) {
        
        filter.doors = sender.on
        
    }
    
    @IBAction func lightsToggle(sender: UISwitch) {
        
        filter.lights = sender.on
    
    }
    
    @IBAction func raisedToggle(sender: UISwitch) {
        
        filter.raised = sender.on
        
    }
    
    @IBAction func loweredToggle(sender: UISwitch) {
        
        filter.lowered = sender.on
        
    }
    
    @IBAction func errorsToggle(sender: UISwitch) {
        
        filter.errors = sender.on
        
    }

}

// MARK: - Filter

extension FilterTableViewController {
    
    struct Filter {
        
        var doors = true
        
        var lights = true
        
        var raised = true
        
        var lowered = true
        
        var errors = true
        
    }
    
}
