//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Jerry on 2/27/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

@objc protocol MentionsViewControllerDelegate {
    optional func mentionsViewController(mentionsViewController: MentionsViewController, didOpenHamburger isOpen: Bool)
}

class MentionsViewController: UIViewController, UITableViewDataSource {
    var tweets = [Tweet]()
    var isOpen = false
    weak var delegate:MentionsViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.barTintColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        requestTimeline { (tweetsArray) -> () in
            self.tweets = tweetsArray
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MentionsCell") as! MentionTableViewCell
        let tweet = tweets[indexPath.row]
        let user = tweet.user
        let profileImageUrl = NSURL(string: (user?.profileImgUrl)!)
        let tapGesture = UITapGestureRecognizer(target: self, action: "onImageTapped:")
        cell.profileImageView.addGestureRecognizer(tapGesture)
        cell.profileImageView.userInteractionEnabled = true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHamburgerTapped(sender: UIBarButtonItem) {
        delegate?.mentionsViewController!(self, didOpenHamburger: isOpen)
    }
    
    func requestTimeline(completion: (tweetsArray: [Tweet]) ->()) {
        TwitterClient.sharedInstance.mentionsTimelineWithParams(nil) { (tweets, error) -> () in
            completion(tweetsArray: tweets!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mentionsToProfile" {
            let destination = segue.destinationViewController as! UserViewController
            let indexPath = sender as! NSIndexPath
            destination.user = tweets[indexPath.row].user
        } else {
            let destination = segue.destinationViewController as! TweetViewController
            let button = sender as! UIButton
            let btnPosition = button.convertPoint(CGPointZero, toView: tableView)
            let indexPath = tableView.indexPathForRowAtPoint(btnPosition)
            let tweet = tweets[indexPath!.row]
            destination.title = "Reply to @\(tweet.user!.username!)"
            destination.tweet = tweet
        }
    }
    
    func onImageTapped(sender: UITapGestureRecognizer) {
        let point = sender.view
        let mainCell = point?.superview
        let main = mainCell?.superview
        let cell = main as! MentionTableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        performSegueWithIdentifier("mentionsToProfile", sender: indexPath)
    }
}
