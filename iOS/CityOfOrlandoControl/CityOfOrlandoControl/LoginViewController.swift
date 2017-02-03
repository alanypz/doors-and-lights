//
//  LoginViewController.swift
//  CityOfOrlandoControl
//
//  Created by Alan Yepez on 1/17/16.
//  Copyright © 2016 cop4935-coo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var completionBlock: (() -> Void)?

    @IBAction func login(sender: UIButton) {
        
        guard let email = emailTextField.text where !email.isEmpty else { return showEmailInvalid() }
        
        guard let password = passwordTextField.text where !password.isEmpty else { return showPasswordInvalid() }
        
//        guard let password = passwordTextField.text where kRegexPassword.match(password) else { return showPasswordInvalid() }
//        
//        guard let email = emailTextField.text where kRegexEmail.match(email) else { return showEmailInvalid() }

        sender.enabled = false
        
        let operation = LoginOperation(email: email, password: password)
        
        operation.loginCompletionBlock = { [weak self] (error) in
        
            switch (self, error) {
            
            case let (controller?, nil):
                
                controller.completionBlock?()
             
                controller.dismissViewControllerAnimated(true, completion: nil)
               
            case let (controller?, _?):
                
                controller.showError("Unable to login.")
                
                sender.enabled = true

            default:
                
                break
                
            }
        
        }
        
        ServerCoordinator.sharedCoordinator.addOperation(operation)

    }
    
    @IBAction func info(sender: UIButton) {
        
        let alertController = UIAlertController(title: "About", message: "This is Senior Design II.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
        
        

    }
    
    func showEmailInvalid() {
    
        let alertController = UIAlertController(title: "Error", message: "Invalid email address", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
        

    }
    
    func showPasswordInvalid() {
    
        let alertController = UIAlertController(title: "Error", message: "Invalid password.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    func showError(error: String) {

        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}

// MARK: - Text Field Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == emailTextField {
        
            return passwordTextField.becomeFirstResponder()
        
        }
        
        return textField.resignFirstResponder()
        
    }
    
}

