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
        
        
        func configureCell(Joke:joke){
            self.joke = joke
            
            self.jokeText.text = joke.jokeText
            self.totalVotesLabel.text = "Total Votes: \(joke.jokeVotes)"
            self.usernameLabel.text = joke.username
            
            voteRef = DataService.dataService.CURRENT_USER_REF.childByAppendingPath("votes").childByAppendingPath(joke.jokeKey)
            
            voteRef.observeSingleEventOfType(.Value,withBlock: {snapshot in
                
                if let thumbsUpDown = snapshot.value as? NSNull {
                    print(thumbsUpDown)
                    self.thumbVoteImage.image = UIImage(named: "thumb-down")
                }else{
                    
                    self.thumbVoteImage.image = UIImage ( named: "thumb-up")
                }
                
                
        }
        
    }
    
}
