//
//  LoginViewController.swift
//  FirebaseJokes
//
//  Created by Matthew Maher on 1/23/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If we have uid stored , the user is already login - no need to sign 
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil {
            self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func tryLogin(sender: AnyObject) {
        
        let email = emailField.text
        let password =  passwordField.text
        
        if email != "" && password != ""
        {
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
            
                if error != nil {
                    print (error)
                    self.loginErrorAlert("Oops!",message:"Check your username and password.")
                    
                }else{
                    // Be suer the correct uid is stored
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    // Enter the app! 
                    
                    self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
                }
            
            
            
            
            })
            
        }
        else{
            loginErrorAlert("Oops!", message: "Don't forget to enter your email and password.")
            }
        }
    
    
    // Firebase has built-in  support for user authentication with email address and password .
    
    
    
    func  loginErrorAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
}
