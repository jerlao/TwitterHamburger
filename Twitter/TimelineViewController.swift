//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Jerry on 2/18/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TimelineViewControllerDelegate {
    optional func timelineViewController(timelineViewController: TimelineViewController, didOpenHamburger isOpen: Bool)
}

class TimelineViewController: UIViewController, UITableViewDataSource, TweetViewControllerDelegate {
    
    var tweets = [Tweet]()
    var user:User?
    @IBOutlet var tableView: UITableView!
    weak var delegate:TimelineViewControllerDelegate?
    var isOpen = false
    @IBOutlet weak var hamburgerButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.barTintColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Do any additional setup after loading the view.
        requestTimeline { (tweetsArray) -> () in
            self.tweets = tweetsArray
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TwitterTableViewCell
        let tweet = tweets[indexPath.row]
        let user = tweet.user
        let profileImageUrl = NSURL(string: (user?.profileImgUrl)!)
        cell.tweet = tweet
        cell.tweetLabel.text = tweet.text
        cell.usernameLabel.text = user?.name
        cell.userHandleLabel.text = "@\((user?.username)!)"
        cell.profileImageView.setImageWithURL(profileImageUrl!, placeholderImage: UIImage(named: "finch"))
        cell.profileImageView.layer.cornerRadius = 10
        cell.tweetTimeLabel.text = tweet.createdTime
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        tweets = []
        requestTimeline { (tweetsArray) -> () in
            self.tweets = tweetsArray
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    func requestTimeline(completion: (tweetsArray: [Tweet]) ->()) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            completion(tweetsArray: tweets!)
        }
    }
    
    func didSendTweet(tweetViewController: TweetViewController, response: NSDictionary) {
        let newTweet = Tweet(dictionary: response)
        tweets.insert(newTweet, atIndex: 0)
        tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CellToDetailSegue" {
            let indexPath = tableView.indexPathForSelectedRow
            let tweet = tweets[indexPath!.row]
            let destination = segue.destinationViewController as! DetailViewController
            destination.title = "Tweet"
            destination.tweet = tweet
        } else {
            let destination = segue.destinationViewController as! TweetViewController
            if segue.identifier == "NewTweetSegue" {
                destination.title = "New Tweet"
                destination.delegate = self
            } else if segue.identifier == "ReplyTweetSegue" {
                let button = sender as! UIButton
                let btnPosition = button.convertPoint(CGPointZero, toView: tableView)
                let indexPath = tableView.indexPathForRowAtPoint(btnPosition)
                let tweet = tweets[indexPath!.row]
                destination.title = "Reply to @\(tweet.user!.username!)"
                destination.tweet = tweet
            }
        }
    }

    @IBAction func onHamburgerTapped(sender: UIBarButtonItem) {
        delegate?.timelineViewController!(self, didOpenHamburger: isOpen)
        isOpen = !isOpen
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
