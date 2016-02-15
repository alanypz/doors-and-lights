//
//  ConponentCollectionViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/17/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ConponentCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FilterTableViewControllerDelegate {
    
    var groups: [Group] = []
    
    @IBOutlet weak var selectButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var actionButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //  Commented out log-in segue for quick testing.
//        performSegueWithIdentifier("LoginSegue", sender: nil)
        
    }
    
    // MARK: Editing
    
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        selectButtonItem.title = editing ? "Done" : "Select"
    
        navigationController?.setToolbarHidden(!editing, animated: animated)
        
        guard let collectionView = collectionView else { return }
        
        collectionView.allowsMultipleSelection = editing
    
        let count = collectionView.indexPathsForSelectedItems()?.count ?? 0
        
        actionButtonItem.enabled = count != 0
        
        let headerViews = collectionView.visibleSupplementaryViewsOfKind(UICollectionElementKindSectionHeader) as! [GroupCollectionReusableView]
        
        for header in headerViews {
            
            header.setEditing(editing, animated: animated)
            
        }
        
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "FilterSegue":
            
            let navigation = segue.destinationViewController as! UINavigationController
            
            let viewController = navigation.topViewController as! FilterTableViewController
            
            viewController.delegate = self
            
            //            case "SettingsSegue":
            //
            //            let navigation = segue.destinationViewController as! UINavigationController
            //
            //                let viewController = navigation.topViewController as! SettingsTableViewController
            //
            //            viewController.delegate = self
            
        default:
            
            break
            
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func toggleEditing(sender: UIBarButtonItem) {
        
        setEditing(!editing, animated: true)
        
    }
    
    @IBAction func performAction(sender: UIBarButtonItem) {
        
        if let components = collectionView?.indexPathsForSelectedItems()?.map({ groups[$0.section].components[$0.item] }) {
            
            let actions = UIAlertController(title: "Select Action", message: "Performed on door and light components", preferredStyle: .ActionSheet)
            
            actions.addAction(UIAlertAction(title: "Raise", style: .Default, handler: nil))
            
            actions.addAction(UIAlertAction(title: "Lower", style: .Default, handler: nil))
            
            actions.addAction(UIAlertAction(title: "Stop", style: .Destructive, handler: nil))
            
            actions.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            actions.popoverPresentationController?.barButtonItem = sender
            
            actions.popoverPresentationController?.sourceView = view
            
            presentViewController(actions, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func newGroup(sender: UIBarButtonItem) {
        
        if let collectionView = collectionView {
            
            setEditing(true, animated: true)
            
            let indexSet = NSIndexSet(index: groups.count)
            
            let components = [Component(name: "", garage: 1, bay: 1, side: "", status: .Raised), Component(name: "", garage: 1, bay: 1, side: "", status: .Raised), Component(name: "", garage: 1, bay: 1, side: "", status: .Raised), Component(name: "", garage: 1, bay: 1, side: "", status: .Raised), Component(name: "", garage: 1, bay: 1, side: "", status: .Raised), Component(name: "", garage: 1, bay: 1, side: "", status: .Raised), Component(name: "", garage: 1, bay: 1, side: "", status: .Raised), Component(name: "", garage: 1, bay: 1, side: "", status: .Raised), Component(name: "", garage: 1, bay: 1, side: "", status: .Raised)]
            
            groups.append(Group(title: "", components: components))
            
            let selectedIndexPaths = collectionView.indexPathsForSelectedItems()
            
            //move those items to the new section
            
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
            
            header.titleTextField.tag = indexPath.section
            
            header.selectButton.tag = indexPath.section

            header.deleteButton.tag = indexPath.section
            
            header.titleTextField.addTarget(self, action: "didEditGroupTitle:", forControlEvents: .EditingChanged)
            
            header.selectButton.addTarget(self, action: "didSelectGroup:", forControlEvents: .TouchUpInside)
            
            header.deleteButton.addTarget(self, action: "didDeleteGroup:", forControlEvents: .TouchUpInside)
            
            header.setEditing(editing, animated: false)
            
            return header
            
        default:
            
            fatalError("Invalid Collection Supplementary View")
            
        }
        
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let storyboard = storyboard where !editing {
            
            let viewController = storyboard.instantiateViewControllerWithIdentifier("Component") as! ComponentViewController
            
            viewController.component = groups[indexPath.section].components[indexPath.item]
            
            let navigation = UINavigationController(rootViewController: viewController)
            
            navigation.modalPresentationStyle = .FormSheet
            
            presentViewController(navigation, animated:true, completion: nil)
            
        }
            
        else {
            
            actionButtonItem.enabled = true
            
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if editing {
        
            actionButtonItem.enabled = false

        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    override func collectionView(collectionView: UICollectionView, targetIndexPathForMoveFromItemAtIndexPath originalIndexPath: NSIndexPath, toProposedIndexPath proposedIndexPath: NSIndexPath) -> NSIndexPath {
        
        return proposedIndexPath
        
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let component = groups[sourceIndexPath.section].components.removeAtIndex(sourceIndexPath.item)
        
        groups[destinationIndexPath.section].components.insert(component, atIndex: destinationIndexPath.item)
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        traitCollection.userInterfaceIdiom
        
        return CGSize(width: 100, height: 100)
        
    }
    
    //MARK: GroupActions
    
    func sectionForView(view: UIView) -> NSIndexPath? {
    
        guard let collectionView = collectionView, superview = view.superview else { return nil }
        
        return NSIndexPath(forItem: 0, inSection: view.tag)
        
        let point = collectionView.convertPoint(view.center, fromView: superview)
    
        return collectionView.indexPathForItemAtPoint(point)
    
    }
    
    func didEditGroupTitle(sender: UITextField) {
        
        if let indexPath = sectionForView(sender) {
        
            let group = groups[indexPath.section]
            
            group.title = sender.text ?? ""
        
        }
    
    }
    
    func didSelectGroup(sender: UIButton) {
        
        if let collectionView = collectionView, indexPath = sectionForView(sender) {
            
            setEditing(true, animated: true)
            
            let group = groups[indexPath.section]
            
            for item in 0..<group.numberOfComponents() {
                
                collectionView.selectItemAtIndexPath(NSIndexPath(forItem: item, inSection: indexPath.section), animated: true, scrollPosition: .None)
                
            }
            
        }
        
    }
    
    func didDeleteGroup(sender: UIButton) {
        
        if let collectionView = collectionView, indexPath = sectionForView(sender) {
            
            
            
            let group = groups.removeAtIndex(indexPath.section)
        
           // groups.append(Group(title: "", components: group.components))

            
        
            
            
            
            let indexSet = NSIndexSet(index: indexPath.section)
            
            collectionView.performBatchUpdates({
                
                collectionView.deleteSections(indexSet)
                
              //  collectionView.insertSections(NSIndexSet(index: 1))
                
                }, completion: nil)
            
        }

        
        
        // ask for confirmation
        
    }
    
    // MARK: FilteTableViewController Delegate
    
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
    
}