//
//  SettingsViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/19/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var autoRefreshSwitch: UISwitch!
    
    @IBOutlet weak var closeDetailedSwitch: UISwitch!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        autoRefreshSwitch.on = Defaults.autoRefresh
        
        closeDetailedSwitch.on = Defaults.autoClose
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        preferredContentSize = tableView.contentSize
        
    }
    
    // MARK: - Switch
    
    @IBAction func autoRefreshToggle(sender: UISwitch) {
        
        Defaults.autoRefresh = sender.on

    }
    
    @IBAction func closeDetailedToggle(sender: UISwitch) {
        
        Defaults.autoClose = sender.on
        
    }
    
    // MARK: - Action
  
    @IBAction func done(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    
        switch (indexPath.section, indexPath.row) {
        
        case (0,0):
            
            return true
            
        default:
        
            return false
        
        }
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0,0):
            
            let alertController = UIAlertController(title: "Verify Crane Position", message: "Confirm crane is located at its origin position.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            alertController.addAction(UIAlertAction(title: "Calibrate", style: .Default) { (action) in
                
                self.confirmCalibrationAlert()
                
            })
            
            presentViewController(alertController, animated: true, completion: nil)
            
        default:
            
            break
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    func confirmCalibrationAlert() {
        
        let calibrateController = UIAlertController(title: "Success", message: "Crane position has been set to origin.", preferredStyle: UIAlertControllerStyle.Alert)
        
        calibrateController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        
        self.presentViewController(calibrateController, animated: true, completion: nil)
        
    }
    
}
