//
//  DetailViewController.swift
//  Twitter
//
//  Created by Jerry on 2/19/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetTextBG: UIView!
    @IBOutlet weak var messagePointerView: UIView!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    @IBOutlet weak var retweetButtonOutlet: UIButton!
    
    var tweet:Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let profileImageUrl = NSURL(string: tweet.user!.profileImgUrl!)
        profileImageView.setImageWithURL(profileImageUrl!, placeholderImage: UIImage(named: "finch"))
        profileImageView.layer.cornerRadius = 10
        userLabel.text = tweet.user!.name
        usernameLabel.text = "@\(tweet.user!.username!)"
        tweetTextBG.layer.cornerRadius = 10
        tweetLabel.text = tweet.text
        messagePointerView.transform = CGAffineTransformMakeRotation(0.785398)
        if tweet.isFavorited == true {
            favoriteButtonOutlet.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        }
        if tweet.isRetweeted == true {
            retweetButtonOutlet.setTitleColor(UIColor(red: 102/255, green: 204/255, blue: 0, alpha: 1), forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReply(sender: UIButton) {
    }

    @IBAction func onRetweet(sender: UIButton) {
        let tweetID = tweet.id
        TwitterClient.sharedInstance.retweet(["id": tweetID!]) { (response, error) -> () in
        }
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        let tweetID = tweet.id
        TwitterClient.sharedInstance.favoriteTweet(["id": tweetID!]) { (response, error) -> () in
            self.favoriteButtonOutlet.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! TweetViewController
        if segue.identifier == "ReplyTweetSegue" {
            destination.title = "Reply to @\(tweet.user!.username!)"
            destination.tweet = tweet
        }
    }

}
