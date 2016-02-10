//
//  ConponentCollectionViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/17/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ConponentCollectionViewController: UICollectionViewController, FilterTableViewControllerDelegate, SettingsTableViewControllerDelegate {
    
    var groups: [Group] = []
    
    @IBOutlet weak var selectButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        performSegueWithIdentifier("LoginSegue", sender: nil)
        
    }
    
    // MARK: Editing
    
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        selectButtonItem.title = editing ? "Done" : "Select"
        
        navigationController?.setToolbarHidden(!editing, animated: animated)
        
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "FilterSegue":
            
            let navigation = segue.destinationViewController as! UINavigationController
            
            let viewController = navigation.topViewController as! FilterTableViewController
            
            viewController.delegate = self
            
        case "SettingsSegue":
            
            let navigation = segue.destinationViewController as! UINavigationController
            
            let viewController = navigation.topViewController as! SettingsTableViewController
            
            viewController.delegate = self
            
        default:
            
            break
            
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func toggleEditing(sender: UIBarButtonItem) {
        
        setEditing(!editing, animated: true)
        
    }
    
    @IBAction func performAction(sender: UIBarButtonItem) {
        
        let actions = UIAlertController(title: "Select Action", message: "Performed on door and light components", preferredStyle: .ActionSheet)
        
        actions.addAction(UIAlertAction(title: "Raise", style: .Default, handler: nil))
        
        actions.addAction(UIAlertAction(title: "Lower", style: .Default, handler: nil))
        
        actions.addAction(UIAlertAction(title: "Stop", style: .Destructive, handler: nil))

        actions.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        actions.popoverPresentationController?.barButtonItem = sender
        
        actions.popoverPresentationController?.sourceView = view
        
        presentViewController(actions, animated: true, completion: nil)
        
    }
    
    @IBAction func newGroup(sender: UIBarButtonItem) {
        
        if let collectionView = collectionView {
            
            setEditing(true, animated: true)
            
            let indexSet = NSIndexSet(index: groups.count)
            
            groups.append(Group(title: "New Group", components: []))
            
            collectionView.performBatchUpdates({
                
                collectionView.insertSections(indexSet)
                
                }, completion: nil)
            
        }
        
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("LoginSegue", sender: nil)
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return groups.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return groups[section].numberOfComponents()
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ComponentCollectionViewCell
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! GroupCollectionReusableView
            
            let group = groups[indexPath.section]
            
            header.titleTextField.text = group.title
            
            header.selectButton.tag = indexPath.section
            
            header.deleteButton.tag = indexPath.section
            
            header.selectButton.addTarget(self, action: "didSelectGroup:", forControlEvents: .TouchUpInside)
            
            header.deleteButton.addTarget(self, action: "didDeleteGroup:", forControlEvents: .TouchUpInside)
            
            return header
            
        default:
            
            fatalError("Invalid Collection Supplementary View")
            
        }
        
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let storyboard = storyboard where !editing {
            
            let viewController = storyboard.instantiateViewControllerWithIdentifier("Component") as! ComponentViewController
            
            viewController.component = groups[indexPath.section].components[indexPath.item]
            
            let navigation = UINavigationController(rootViewController: viewController)
            
            presentViewController(navigation, animated:true, completion: nil)
            
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    override func collectionView(collectionView: UICollectionView, targetIndexPathForMoveFromItemAtIndexPath originalIndexPath: NSIndexPath, toProposedIndexPath proposedIndexPath: NSIndexPath) -> NSIndexPath {
        
        return proposedIndexPath
        
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
    
    //MARK: GroupActions
    
    func didSelectGroup(sender: UIButton) {
        
        setEditing(true, animated: true)
        
    }
    
    func didDeleteGroup(sender: UIButton) {
        
       // ask for confirmation
        
    }
    
    // MARK: FilterTableViewController Delegate
    
    var filter = FilterState() {
        
        didSet {
            
            //  Apply changes.
            
        }
        
    }
    
    func doorsFilter(value value: Bool) {
        
        filter.doors = value
        
    }
    
    func lightsFilter(value value: Bool) {
        
        filter.lights = value
        
    }
    
    func raisedFilter(value value: Bool) {
        
        filter.raised = value
        
    }
    
    func loweredFilter(value value: Bool) {
        
        filter.lowered = value
        
    }
    
    func errorsFilter(value value: Bool) {
        
        filter.errors = value
        
    }
    
    // MARK: SettingsTableViewController Delegate

    var setting = SettingsState() {
        
        didSet {
            
            //  Apply changes.
            
        }
        
    }
    
    func notificationsSetting(value value: Bool) {
        
        setting.notifications = value
        
    }
    
}