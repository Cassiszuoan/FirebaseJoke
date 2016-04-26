//
//  JokesFeedTableViewController.swift
//  FirebaseJokes
//
//  Created by Matthew Maher on 1/23/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import Firebase
class JokesFeedTableViewController: UITableViewController {
    
    
    var jokes = [Joke]()
    var joke:Joke!
    var voteRef:Firebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //observeEventType is called whenever anytinh changes in the FireBase
        DataService.dataService.JOKE_REF.observeEventType(.Value, withBlock:{snapshot in
         print(snapshot.value)
        self.jokes = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let joke = Joke(key:key,dictionary: postDictionary)
                        
                        self.jokes.insert(joke,atIndex: 0)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jokes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       let joke = jokes[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("JokeCellTableViewCell") as? JokeCellTableViewCell{
            
            cell.configureCell(joke)
            return cell
        }else{
            
            return JokeCellTableViewCell()
        }
        
        
        }
    
    
    
    
   
    
    


}
