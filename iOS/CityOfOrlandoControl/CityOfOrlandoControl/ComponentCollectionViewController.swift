//
//  ComponentCollectionViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/17/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ComponentCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var groups: [Group] = []
    
    var saveAction: UIAlertAction?
    
    var filter = FilterTableViewController.Filter()
    
    var timer: NSTimer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComponentCollectionViewController.statusChanged(_:)), name: ComponentStatusNotification, object: ServerCoordinator.sharedCoordinator)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComponentCollectionViewController.autoRefreshChanged(_:)), name: DefaultsAutoRefreshNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if !ServerCoordinator.sharedCoordinator.isAuthenticated() {
            
            performSegueWithIdentifier("Login", sender: nil)
            
        }
        
    }
    
    // MARK: - Collection View Data Source
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return groups.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return max(groups[section].numberOfComponents(), 1)
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch groups[indexPath.section].numberOfComponents() {
            
        case 0:
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Empty", forIndexPath: indexPath)
            
            cell.layer.borderColor = UIColor.darkGrayColor().CGColor
            
            return cell
            
        default:
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ComponentCollectionViewCell
            
            configureCell(cell, atIndexPath: indexPath)
            
            return cell
            
        }
        
    }
    
    func configureCell(cell: ComponentCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let component = groups[indexPath.section].components[indexPath.item]
        
        switch component {
            
        case let (component as Door):
            
            cell.titleLabel.text = "#\(component.number)"
            
            cell.imageView.image = UIImage(named: "Garage")
            
            cell.positionView.image = findPositionIcon(component.position)
            
            configureActivity(component.state, activity: cell.activityIndicatorView, positionView: cell.positionView)
            
            let enabled = shouldEnableComponent(component)
            
            cell.contentView.alpha = enabled ? 1 : 0.35
            
            cell.contentView.tintAdjustmentMode = enabled ? .Automatic : .Dimmed
            
            cell.layer.borderWidth = 0.5
            
            cell.layer.borderColor = UIColor.darkGrayColor().CGColor
            
        case let (component as Light):
            
            cell.titleLabel.text = "#\(component.number)"
            
            cell.imageView.image = UIImage(named: "Bulb")
            
            cell.positionView.image = findPositionIcon(component.position)
            
            configureActivity(component.state, activity: cell.activityIndicatorView, positionView: cell.positionView)
            
            let enabled = shouldEnableComponent(component)
            
            cell.contentView.alpha = enabled ? 1 : 0.35
            
            cell.contentView.tintAdjustmentMode = enabled ? .Automatic : .Dimmed
            
            cell.layer.borderWidth = 0.5
            
            cell.layer.borderColor = UIColor.darkGrayColor().CGColor
            
        default:
            
            fatalError("Invalid Component Class: \(component.dynamicType)")
            
        }
        
    }
    
    func findPositionIcon(position: Component.Position) -> UIImage {
        
        switch position {
            
        case .Lowered:
            
            return UIImage(named: "DownArrow")!
            
        case .Raised:
            
            return UIImage(named: "UpArrow")!
            
        case .Error:
            
            return UIImage(named: "Warning")!
            
        }
        
    }
    
    func configureActivity(state: Component.State, activity: UIActivityIndicatorView, positionView: UIImageView) {
        
        switch state {
            
        case .Executing:
            
            positionView.hidden = true
            
            activity.startAnimating()
            
        case .Stopped:
            
            positionView.hidden = false
            
            if activity.isAnimating() {
                
                activity.stopAnimating()
                
            }
            
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! GroupCollectionReusableView
            
            let group = groups[indexPath.section]
            
            header.textLabel.text = group.title
            
            header.editButton.tag = indexPath.section
            
            header.editButton.addTarget(self, action: #selector(ComponentCollectionViewController.editGroupTitle(_:)), forControlEvents: .TouchUpInside)
            
            return header
            
        default:
            
            fatalError("Invalid Collection Supplementary View")
            
        }
        
    }
    
    // MARK: - Collection View Delegate
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return groups[indexPath.section].numberOfComponents() > 0 && ServerCoordinator.sharedCoordinator.canAddComponentsOperation()
        
    }
    
    override func collectionView(collectionView: UICollectionView, targetIndexPathForMoveFromItemAtIndexPath originalIndexPath: NSIndexPath, toProposedIndexPath proposedIndexPath: NSIndexPath) -> NSIndexPath {
        
        switch groups[proposedIndexPath.section].numberOfComponents() {
            
        case 0:
            
            return NSIndexPath(forItem: 0, inSection: proposedIndexPath.section)
            
        default:
            
            return proposedIndexPath
            
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let sourceGroup = groups[sourceIndexPath.section]
        
        let destinationGroup = groups[destinationIndexPath.section]
        
        let removeEmpty = destinationGroup.numberOfComponents() == 0
        
        let component = sourceGroup.components.removeAtIndex(sourceIndexPath.item)
        
        destinationGroup.components.insert(component, atIndex: destinationIndexPath.item)
        
        let removeGroup = sourceGroup.numberOfComponents() == 0
        
        if removeGroup {
            
            groups.removeAtIndex(sourceIndexPath.section)
            
        }
        
        collectionView.performBatchUpdates({
            
            if removeGroup {
                
                collectionView.deleteSections(NSIndexSet(index: sourceIndexPath.section))
                
            }
            
            if removeEmpty {
                
                collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: 1, inSection: destinationIndexPath.section)])
                
            }
            
            }, completion: nil)
        
        saveComponents()
        
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        switch groups[indexPath.section].numberOfComponents() {
            
        case 0:
            
            return false
            
        default:
            
            return shouldEnableComponent(groups[indexPath.section].components[indexPath.item])
            
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case "Login":
                
                let viewController = segue.destinationViewController as! LoginViewController
                
                viewController.completionBlock = {
                    
                    self.fetchComponents()
                    
                    if Defaults.autoRefresh {
                        
                        self.createAutoRefreshTimer()
                        
                    }
                    
                }
                
            case "Logout":
                
                let viewController = segue.destinationViewController as! LoginViewController
                
                viewController.completionBlock = {
                    
                    self.fetchComponents()
                    
                }
                
                ServerCoordinator.sharedCoordinator.token = nil
                
                ServerCoordinator.sharedCoordinator.cancelAllOperations()
                
                timer?.invalidate()
                
                groups.removeAll()
                
                collectionView?.reloadData()
                
            case "Detail":
                
                let navigation = segue.destinationViewController as! UINavigationController
                
                let viewController = navigation.topViewController as! ComponentViewController
                
                if let indexPath = collectionView?.indexPathsForSelectedItems()?.first {
                    
                    viewController.component = groups[indexPath.section].components[indexPath.item]
                    
                    viewController.actionHandler = { [weak self] in
                        
                        self?.collectionView?.performBatchUpdates({
                            
                            self?.collectionView?.reloadItemsAtIndexPaths([indexPath])
                            
                            }, completion: nil)
                        
                    }
                    
                }
                
            case "Filter":
                
                let navigation = segue.destinationViewController as! UINavigationController
                
                let viewController = navigation.topViewController as! FilterTableViewController
                
                viewController.filter = filter
                
                viewController.completionBlock = { (filter) in
                    
                    self.updateFilter(filter)
                    
                }
                
            default:
                
                return
                
            }
            
        }
        
    }
    
}

// MARK: - Components

extension ComponentCollectionViewController {
    
    func fetchComponents() {
        
        ServerCoordinator.sharedCoordinator.cancelActionOperation()
        
        let operation = ComponentsOperation()
        
        operation.componentsCompletionBlock = { [weak self] (components, error) in
            
            switch (self, components, error) {
                
            case let (controller?, components?, nil):
                
                ServerCoordinator.sharedCoordinator.cancelActionOperation()
                
                controller.groupComponents(components)
                
                controller.checkComponents(components)
                
                controller.showRefreshItems(true)
                
            case let (controller?, nil, error?):
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                
                controller.presentViewController(alertController, animated: true, completion: nil)
                
                controller.showRefreshItems(true)
                
            default:
                
                break
                
            }
            
        }
        
        ServerCoordinator.sharedCoordinator.addOperation(operation)
        
    }
    
    func checkComponents(components: [Component]) {
        
        if let index = components.indexOf({ $0.state == .Executing }) {
            
            switch (components[index]) {
                
            case let door as Door:
                
                let operation = ActionOperation(id: door.id, number: door.number, type: .Door)
                
                ServerCoordinator.sharedCoordinator.addOperation(operation)
                
            case let light as Light:
                
                let operation = ActionOperation(id: light.id, number: light.number, type: .Light)
                
                ServerCoordinator.sharedCoordinator.addOperation(operation)
                
            default:
                
                break
                
            }
            
        }
        
    }
    
    func groupComponents(components: [Component]) {
        
        var allComponents = components
        
        groups.removeAll()
        
        if let dictionaries = NSUserDefaults.standardUserDefaults().objectForKey("Groups") as? [NSDictionary] {
            
            var groups: [Group] = []
            
            for dictionary in dictionaries {
                
                if let title = dictionary["title"] as? String, ids = dictionary["components"] as? [String] {
                    
                    let group = Group(title: title)
                    
                    for id in ids {
                        
                        if let index = allComponents.indexOf({ $0.id == id }) {
                            
                            group.components.append(allComponents.removeAtIndex(index))
                            
                        }
                        
                    }
                    
                    if group.numberOfComponents() > 0 {
                        
                        groups.append(group)
                        
                    }
                    
                }
                
            }
            
            self.groups = groups
            
        }
        
        if allComponents.count > 0 {
            
            groups.append(Group(title: "New Components", components: allComponents))
            
        }
        
        collectionView?.reloadData()
        
        saveComponents()
        
    }
    
    func saveComponents() {
        
        let data = groups.map { ["title": $0.title, "components": $0.components.map { $0.id }] }
        
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "Groups")
        
    }
    
}

extension ComponentCollectionViewController {
    
    // MARK: - Filter
    
    func updateFilter(filter: FilterTableViewController.Filter) {
        
        self.filter = filter
        
        if let collectionView = collectionView {
            
            for indexPath in collectionView.indexPathsForVisibleItems() {
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ComponentCollectionViewCell {
                    
                    configureCell(cell, atIndexPath: indexPath)
                    
                }
                
            }
            
        }
        
    }
    
    func shouldEnableComponent(component: Component) -> Bool {
        
        switch component {
            
        case let (component as Door):
            
            return filter.doors && ((filter.lowered && component.position == .Lowered) || (filter.raised && component.position == .Raised) || (filter.errors && component.position == .Error))
            
        case let (component as Light):
            
            return filter.lights && ((filter.lowered && component.position == .Lowered) || (filter.raised && component.position == .Raised) || (filter.errors && component.position == .Error))
            
        default:
            
            fatalError("Invalid Component Class: \(component.dynamicType)")
            
        }
        
    }
    
}

// MARK: - ToolBar Items

extension ComponentCollectionViewController {
    
    func showRefreshItems(animated: Bool) {
        
        let newGroupItem = UIBarButtonItem(title: "New Group", style: .Plain, target: self, action: #selector(ComponentCollectionViewController.newGroup(_:)))
        
        let textLabel = UILabel()
        
        let date = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        textLabel.text = "Updated On\n\(date)"
        
        textLabel.textAlignment = .Center
        
        textLabel.numberOfLines = 2
        
        textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        
        textLabel.sizeToFit()
        
        let textItem = UIBarButtonItem(customView: textLabel)
        
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(ComponentCollectionViewController.refresh(_:)))
        
        setToolbarItems([newGroupItem, flexibleItem, textItem, flexibleItem, refreshItem], animated: animated)
        
        view.tintAdjustmentMode = .Automatic
        
    }
    
    func showLoadingItems(animated: Bool) {
        
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let textLabel = UILabel()
        
        textLabel.text = "Loading Components..."
        
        textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        
        textLabel.sizeToFit()
        
        let textItem = UIBarButtonItem(customView: textLabel)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        
        let loadingItem = UIBarButtonItem(customView: activityIndicator)
        
        activityIndicator.startAnimating()
        
        setToolbarItems([flexibleItem, textItem, flexibleItem, loadingItem], animated: animated)
        
        view.tintAdjustmentMode = .Dimmed
        
    }
    
}

// MARK: - Actions

extension ComponentCollectionViewController {
    
    func newGroup(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Group", message: "Please enter a title", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            
            textField.placeholder = "Title"
            
            textField.autocapitalizationType = .Words
            
            textField.autocorrectionType = .Yes
            
            textField.clearButtonMode = .Always
            
            textField.delegate = self
            
            textField.addTarget(self, action: #selector(ComponentCollectionViewController.titleChanged(_:)), forControlEvents: .EditingChanged)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
            self.saveAction = nil
            
            })
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { [weak alertController] (action) in
            
            self.saveAction = nil
            
            if let title = alertController?.textFields?.first?.text, collectionView = self.collectionView {
                
                let indexSet = NSIndexSet(index: self.groups.count)
                
                self.groups.append(Group(title: title))
                
                collectionView.performBatchUpdates({
                    
                    collectionView.insertSections(indexSet)
                    
                    }, completion: nil)
                
            }
            
        }
        
        saveAction.enabled = false
        
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        presentViewController(alertController, animated: true, completion: nil)
        
        self.saveAction = saveAction
        
    }
    
    func refresh(sender: UIBarButtonItem) {
        
        if ServerCoordinator.sharedCoordinator.canAddComponentsOperation() {
            
            showLoadingItems(true)
            
            fetchComponents()
            
        }
        
    }
    
}

// MARK: - Group Actions

extension ComponentCollectionViewController {
    
    func editGroupTitle(sender: UIButton) {
        
        let group = groups[sender.tag]
        
        let alertController = UIAlertController(title: "Edit Group", message: "Please update a title", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            
            textField.placeholder = "Title"
            
            textField.text = group.title
            
            textField.autocapitalizationType = .Words
            
            textField.autocorrectionType = .Yes
            
            textField.clearButtonMode = .Always
            
            textField.delegate = self
            
            textField.addTarget(self, action: #selector(ComponentCollectionViewController.titleChanged(_:)), forControlEvents: .EditingChanged)
            
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
            self.saveAction = nil
            
            })
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { [weak alertController] (action) in
            
            self.saveAction = nil
            
            let indexPath = NSIndexPath(forItem: 0, inSection: sender.tag)
            
            if let title = alertController?.textFields?.first?.text, collectionView = self.collectionView, view = collectionView.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath) as? GroupCollectionReusableView  {
                
                group.title = title
                
                view.textLabel.text = title
                
            }
            
            self.saveComponents()
            
        }
        
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        presentViewController(alertController, animated: true, completion: nil)
        
        self.saveAction = saveAction
        
    }
    
}

// MARK: - Text Field Delegate

extension ComponentCollectionViewController: UITextFieldDelegate {
    
    func titleChanged(sender: UITextField) {
        
        if let action = saveAction, text = sender.text {
            
            action.enabled = !text.isEmpty
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}

// MARK: Timer

extension ComponentCollectionViewController {
    
    func autoRefresh(timer: NSTimer) {
        
        
        guard let gestureRecognizers = collectionView?.gestureRecognizers where gestureRecognizers.indexOf({ $0.state == .Changed || $0.state == .Began }) == nil else { return }
        
        if ServerCoordinator.sharedCoordinator.canAddComponentsOperation() {
            
            fetchComponents()
            
        }
        
    }
    
    func createAutoRefreshTimer() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(ComponentCollectionViewController.autoRefresh(_:)), userInfo: nil, repeats: true)
        
    }
    
}

// MARK: Notification

extension ComponentCollectionViewController {
    
    func autoRefreshChanged(notification: NSNotification) {
        
        timer?.invalidate()
        
        if let newValue = notification.userInfo?["newValue"] as? Bool where newValue {
            
            createAutoRefreshTimer()
            
        }
        
    }
    
    func statusChanged(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        if let component = userInfo[ComponentStatusNotificationComponentKey] as? Component, let result = findComponent(component.id) {
            
            result.component.state = component.state
            
            result.component.position = component.position
            
            collectionView?.performBatchUpdates({
                
                self.collectionView?.reloadItemsAtIndexPaths([result.indexPath])
                
                }, completion: nil)
            
        }
        
        if let id = userInfo[ComponentStatusNotificationIdKey] as? String, let result = findComponent(id) {
            
            result.component.state = .Stopped
            
            result.component.position = .Error
            
            collectionView?.performBatchUpdates({
                
                self.collectionView?.reloadItemsAtIndexPaths([result.indexPath])
                
                }, completion: nil)
            
        }
        
        if let error = userInfo[ComponentStatusNotificationErrorKey] as? NSError where presentedViewController == nil{
            
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func findComponent(id: String) -> (component: Component, indexPath: NSIndexPath)? {
        
        for (section, group) in groups.enumerate() {
            
            if let item = group.components.indexOf({ $0.id == id }) {
                
                return (group.components[item], NSIndexPath(forItem: item, inSection: section))
                
            }
            
        }
        
        return nil
        
    }
    
}

