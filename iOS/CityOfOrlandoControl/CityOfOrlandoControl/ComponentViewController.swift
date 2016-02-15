//
//  ComponentViewController.swift
//  CityOfOrlandoControl
//
//  Created by Jonathan Cools-Lartigue on 2/8/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class ComponentViewController: UITableViewController {

    var component: Component!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
    
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    
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
