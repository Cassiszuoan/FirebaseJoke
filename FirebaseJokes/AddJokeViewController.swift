//
//  AddJokeViewController.swift
//  FirebaseJokes
//
//  Created by Matthew Maher on 1/23/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import Firebase

class AddJokeViewController: UIViewController {
    var currentUsername = ""
    @IBOutlet weak var jokeField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: {snapshot in
           let currentUser = snapshot.value.objectForKey("username") as! String
            print("Username: \(currentUser)")
            
            self.currentUsername = currentUser
            }, withCancelBlock: {
        
           error in
                print(error.description)
        
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func saveJoke(sender: AnyObject) {
        
        let jokeText = jokeField.text
        
        if jokeText != "" {
            
            let newJoke: Dictionary<String,AnyObject> = [
               
                "jokeText":jokeText!,
                "votes": 0,
                "author": currentUsername
            
            
            ]
            
            
            DataService.dataService.createNewJoke(newJoke)
            
            if let navController = self.navigationController{
            navController.popViewControllerAnimated(true)
        }
        
        
        }
            
        
        
    }
    
 
    
    
    @IBAction func logout(sender: AnyObject) {
        
    }
}
