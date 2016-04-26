//
//  JokeCellTableViewCell.swift
//  FirebaseJokes
//
//  Created by Matthew Maher on 1/23/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import Firebase
class JokeCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jokeText: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    @IBOutlet weak var thumbVoteImage: UIImageView!
    var joke: Joke!
    var voteRef: Firebase!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "voteTapped:")
        tap.numberOfTapsRequired = 1
        thumbVoteImage.addGestureRecognizer(tap)
        thumbVoteImage.userInteractionEnabled = true
        
    }
    
    func voteTapped(sender: UITapGestureRecognizer){
        voteRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        
            if let thumbsUpDown = snapshot.value as? NSNull {
                print(thumbsUpDown)
                self.thumbVoteImage.image = UIImage(named: "thumb-down")
                self.joke.addSubstractVote(true)
                self.voteRef.setValue(true)
            }
            else{
                self.thumbVoteImage.image = UIImage(named: "thumb-up")
                self.joke.addSubstractVote(false)
                self.voteRef.removeValue()
            }
        
        // 呼叫 addSubstractVote時 vote -1 
        
        })
    }
    
  
    
    func configureCell(joke:Joke){
        self.joke = joke
        self.jokeText.text = joke.jokeText
        self.totalVotesLabel.text="Total Votes: \(joke.jokeVotes)"
        self.usernameLabel.text = joke.username
        
        
        voteRef = DataService.dataService.CURRENT_USER_REF.childByAppendingPath("votes").childByAppendingPath(joke.jokeKey)
        voteRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let thumbsUpDown = snapshot.value as? NSNull {
                print (thumbsUpDown)
                self.thumbVoteImage.image = UIImage(named: "thumb-down")
                
            }else{
                self.thumbVoteImage.image = UIImage(named: "thumb-up")
            }
            
        })
        
    }
    
}
