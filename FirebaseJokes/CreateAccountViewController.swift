//
//  CreateAccountViewController.swift
//  FirebaseJokes
//
//  Created by Matthew Maher on 1/23/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import Firebase
class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        
        if username != "" && email != "" && password != ""{
            
            // Set Email and Password for new Users
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: {error, result in
                
                if error != nil {
                    // There was a problem
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account . Try again later")
                    
                }else{
                    // Create and Login the New User with authUser
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock:{err, authData in
                    let user = ["provider": authData.provider!, "email":email!,"username":username!]
                        
                        DataService.dataService.createNewAccount(authData.uid,user:user)
                    
                    })
                    
                    // Store the uid for future access !
                    NSUserDefaults.standardUserDefaults().setValue(result["uid"], forKey: "uid")
                    
                    self.performSegueWithIdentifier("NewUserLoggedIn", sender: nil)
                }
                
                
    })
        
        }
        
        else{
            signupErrorAlert("Oops!", message: "Don't forget to enter your email,password,and a username")
        }
        
    }
    
    
    func signupErrorAlert(title:String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert,animated:true,completion:nil)
    }
    
    @IBAction func cancelCreateAccount(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}
