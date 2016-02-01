//
//  ConponentCollectionViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/17/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ConponentCollectionViewController: UICollectionViewController, FilterTableViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)

        performSegueWithIdentifier("LoginSegue", sender: nil)
        
//        var defaultItems = [UIBarButtonItem]()
//        defaultItems.append(
//            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
//            
//        )
//        defaultItems.append(
//            UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)
//        )
//        setToolbarItems(defaultItems, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    @IBAction func logout(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("LoginSegue", sender: nil)
        
    }
    
     // MARK: - Navigation

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
    
    // MARK: - Filter Table View Controller Delegate
    
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
    
    
    @IBAction func showActions(sender: UIBarButtonItem) {
        
        let actions = UIAlertController(title: "Select Action", message: "Performed on Door and Light components", preferredStyle: .ActionSheet)
        
        actions.addAction(UIAlertAction(title: "Raise", style: .Default, handler: nil))
        actions.addAction(UIAlertAction(title: "Lower", style: .Default, handler: nil))
        actions.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(actions, animated: true, completion: nil)
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
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

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}