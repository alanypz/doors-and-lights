//
//  SettingsViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/19/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

struct SettingsState {
    
    var notifications = true
    
}

protocol SettingsTableViewControllerDelegate {
    
    var setting: SettingsState { get }
    
    func notificationsSetting(value value: Bool)
    
}

class SettingsTableViewController: UITableViewController {
    
    var delegate: SettingsTableViewControllerDelegate?
    
    @IBOutlet weak var notificationsSwitch: UISwitch!

    override func viewDidLoad() {

        notificationsSwitch.on = delegate?.setting.notifications ?? true
        
        super.viewDidLoad()

    }
    
    @IBOutlet weak var notificationSwitch: UISwitch!        
    
    @IBAction func notificationsToggle(sender: UISwitch) {
        delegate?.notificationsSetting(value: sender.on)
    }
    
    @IBAction func cancelSettingsPopup(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneSettingsPopup(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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

