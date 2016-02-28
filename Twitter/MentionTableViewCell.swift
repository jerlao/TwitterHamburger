//
//  MentionTableViewCell.swift
//  Twitter
//
//  Created by Jerry on 2/27/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

protocol MentionTableViewCellDelegate : class {
    func didFavorite(mentionTableViewCell: MentionTableViewCell)
}


class MentionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    @IBOutlet weak var retweetButtonOutlet: UIButton!
    
    var tweet:Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if tweet?.isFavorited == true {
            favoriteButtonOutlet.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            
        }
        
        if tweet?.isRetweeted == true {
            retweetButtonOutlet.setTitleColor(UIColor(red: 102/255, green: 204/255, blue: 0, alpha: 1), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        if tweet!.isRetweeted == false {
            let tweetID = tweet!.id
            TwitterClient.sharedInstance.retweet(["id": tweetID!]) { (response, error) -> () in
                self.tweet?.isRetweeted = true
                self.retweetButtonOutlet.setTitleColor(UIColor(red: 102/255, green: 204/255, blue: 0, alpha: 1), forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        if tweet!.isFavorited == false {
            let tweetID = tweet!.id
            TwitterClient.sharedInstance.favoriteTweet(["id":tweetID!], completion: { (response, error) -> () in
                self.tweet?.isFavorited = true
                self.favoriteButtonOutlet.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            })
        }
    }
    
    
    
}
