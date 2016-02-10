//
//  LoginViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/17/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    let serverURL = NSURL(string: "http://localhost:8080")
    //    let request = NSMutableURLRequest(URL: serverURL!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: UIButton) {
        
        let userEmail = userEmailTextField.text ?? ""
        let userPassword = userPasswordTextField.text ?? ""
        
        if  userPassword.isEmpty || userEmail.isEmpty {
            
            displayAlertMessage("All fields are required.")
            
        }
        else {
            
            //  Tentative URL.
            let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8080/api/authenticate")!)
            let session = NSURLSession.sharedSession()
            let params = [
                "name": userEmail,
                "password": userPassword
            ]
            
            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.HTTPMethod = "POST"
            
            let task = session.dataTaskWithRequest(request, completionHandler: { [weak self] (data, response, error) in
                
                switch (self, data, error) {
                    
                case let (controller?, data?, nil):
                    
                    guard let dictionary = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else { return }
                    
                    guard let success = dictionary["success"] as? Bool where success else {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            let alertMessage = UIAlertController(title: "Error", message: "Invalid username or password.", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alertMessage.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                            
                            controller.presentViewController(alertMessage, animated: true, completion: nil)
                            
                        }
                        
                        return
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        controller.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                    
                case let (controller?, nil, error?):
                    
                    let alertMessage = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertMessage.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                    
                    controller.presentViewController(alertMessage, animated: true, completion: nil)
                    
                default:
                    
                    break
                    
                }
                
                })
            
            task.resume()
            
        }
        
    }
    
    func displayAlertMessage(alertMessage: String)
    {
        let alertMessage = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        
        alertMessage.addAction(dismiss)
        
        self.presentViewController(alertMessage, animated: true, completion: nil)
        
        
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
