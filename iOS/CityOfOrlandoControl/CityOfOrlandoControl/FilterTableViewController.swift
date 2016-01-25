//
//  FilterViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/19/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit


struct FilterState {
    
    var doors = true
    var lights = true
    var raised = true
    var lowered = true
    var errors = true
    
}

protocol FilterTableViewControllerDelegate {
    
    var filter: FilterState { get }
    
    func doorsFilter(value value: Bool)
    func lightsFilter(value value: Bool)
    func raisedFilter(value value: Bool)
    func loweredFilter(value value: Bool)
    func errorsFilter(value value: Bool)

}


class FilterTableViewController: UITableViewController {

    var delegate: FilterTableViewControllerDelegate?
    
    @IBOutlet var doorSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //doorSwitch.on = delegate?.filter.doors ?? true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelFilterPopup(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneFilterPopup(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Switch Handler
    
    @IBAction func doorsToggle(sender: UISwitch) {
                
        delegate?.doorsFilter(value: sender.on)
        
    }
    
    @IBAction func lightsToggle(sender: UISwitch) {
        
        delegate?.lightsFilter(value: sender.on)
        
    }
    
    @IBAction func raisedToggle(sender: UISwitch) {
        
        delegate?.raisedFilter(value: sender.on)
        
    }
    
    @IBAction func loweredToggle(sender: UISwitch) {
        
        delegate?.loweredFilter(value: sender.on)
        
    }
    
    @IBAction func errorsToggle(sender: UISwitch) {
        
        delegate?.errorsFilter(value: sender.on)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
