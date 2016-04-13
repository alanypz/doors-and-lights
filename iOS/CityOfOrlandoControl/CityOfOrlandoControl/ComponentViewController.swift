//
//  ComponentViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 02/16/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class ComponentViewController: UITableViewController {
    
    var component: Component!
    
    @IBOutlet var raiseButtonItem: UIBarButtonItem!
    
    @IBOutlet var lowerButtonItem: UIBarButtonItem!
    
    var actionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        raiseButtonItem.enabled = ServerCoordinator.sharedCoordinator.canAddActionOperation()
        
        lowerButtonItem.enabled = ServerCoordinator.sharedCoordinator.canAddActionOperation()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComponentViewController.statusChanged(_:)), name: ComponentStatusNotification, object: ServerCoordinator.sharedCoordinator)
        
        switch component {
            
        case let door as Door:
            
            navigationItem.title = "Door #\(door.number)"
            
        case let light as Light:
            
            navigationItem.title = "Light #\(light.number)"
            
        default:
            
            navigationItem.title = "Component #\(component.number)"
            
        }
        
    }
    
    //MARK: - Tabel View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Section.count
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section(rawValue: section)! {
            
        case .State:
            
            return 2
            
        case .History:
            
            return 1
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (Section(rawValue: indexPath.section)!, indexPath.row) {
            
        case (.State, 0):
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Subtitle", forIndexPath: indexPath)
            
            cell.textLabel?.text = "Position"
            
            cell.detailTextLabel?.text = component.position.rawValue.uppercaseString
            
            return cell
            
        case (.State, _):
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Subtitle", forIndexPath: indexPath)
            
            cell.textLabel?.text = "State"
            
            cell.detailTextLabel?.text = component.state.rawValue.uppercaseString
            
            return cell
            
        case (.History, _):
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Title", forIndexPath: indexPath)
            
            cell.textLabel?.text = "None"
            
            cell.textLabel?.enabled = false
            
            return cell
            
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch Section(rawValue: section)! {
            
        case .History:
            
            return ""
            
        default:
            
            return "Component Information"
            
        }
        
    }
    
    // MARK: - Table View Delegate
    
    func performAction(operation: ActionOperation) {
        
        raiseButtonItem.enabled = false
        
        lowerButtonItem.enabled = false
        
        component.state = .Executing
        
        ServerCoordinator.sharedCoordinator.addOperation(operation)
        
        actionHandler?()
    
        if Defaults.autoClose {
        
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        }
        
        else {
            
            let indexSet = NSIndexSet(index: Section.State.rawValue)
            
            tableView.beginUpdates()
            
            tableView.reloadSections(indexSet, withRowAnimation: .Fade)
            
            tableView.endUpdates()
            
        }
        
    }
    
}

extension ComponentViewController {
    
    private enum Section: Int {
        
        case State, History
        
        static let count = 1
        
    }
    
}

// MARK: - Actions

extension ComponentViewController {
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func raise(sender: UIBarButtonItem) {
        
        if ServerCoordinator.sharedCoordinator.canAddActionOperation() {
            
            switch component {
                
            case let door as Door:
                
                let operation = ActionOperation(id: door.id, number: door.number, action: .Raise, type: .Door)
                
                performAction(operation)
                
            case let light as Light:
                
                let operation = ActionOperation(id: light.id, number: light.number, action: .Raise, type: .Light)
                
                performAction(operation)
                
            default:
                
                fatalError("Invalid Component")
                
            }
            
        }
        
    }
    
    @IBAction func lower(sender: UIBarButtonItem) {
        
        if ServerCoordinator.sharedCoordinator.canAddActionOperation() {
            
            switch component {
                
            case let door as Door:
                
                let operation = ActionOperation(id: door.id, number: door.number, action: .Lower, type: .Door)
                
                performAction(operation)
                
            case let light as Light:
                
                let operation = ActionOperation(id: light.id, number: light.number, action: .Lower, type: .Light)
                
                performAction(operation)
                
            default:
                
                fatalError("Invalid Component")
                
            }
            
        }
        
    }
    
}

// MARK: - Notifications

extension ComponentViewController {
    
    func statusChanged(notification: NSNotification) {
        
        raiseButtonItem.enabled = true
        
        lowerButtonItem.enabled = true
        
        guard let userInfo = notification.userInfo else { return }
        
        let id = userInfo[ComponentStatusNotificationIdKey] as? String
        
        let component = userInfo[ComponentStatusNotificationComponentKey] as? Component
        
        let error = userInfo[ComponentStatusNotificationErrorKey] as? NSError
        
        switch (id, component, error) {
            
        case let (nil, component?, nil) where component.id == self.component.id:
            
            self.component.state = component.state
            
            self.component.position = component.position
            
        case let (id?, nil, error?) where id == self.component.id:
            
            self.component.state = .Stopped
            
            self.component.position = .Error
            
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
            
        default:
            
            break
            
        }
        
        let indexSet = NSIndexSet(index: Section.State.rawValue)
        
        tableView.beginUpdates()
        
        tableView.reloadSections(indexSet, withRowAnimation: .Fade)
        
        tableView.endUpdates()
        
    }
    
}