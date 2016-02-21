//
//  TweetViewController.swift
//  Twitter
//
//  Created by Jerry on 2/20/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

protocol TweetViewControllerDelegate : class {
    func didSendTweet(tweetViewController: TweetViewController, response: NSDictionary)
}

class TweetViewController: UIViewController {
    
    var tweet:Tweet?
    weak var delegate: TweetViewControllerDelegate?
    @IBOutlet weak var textTextView: UITextView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        bgView.layer.cornerRadius = 10
        sendButtonOutlet.layer.cornerRadius = 10
        sendButtonOutlet.layer.borderColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1).CGColor
        sendButtonOutlet.layer.borderWidth = 2
        
        if let newTweet = tweet {
            let atUser = newTweet.user?.username
            textTextView.text = "@\(atUser!): "
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSend(sender: UIButton) {
        var dictionary: NSDictionary
        if let tweetExist = tweet {
            dictionary = ["status":textTextView.text, "in_reply_to_status_id":tweetExist.id!]
        } else {
            dictionary = ["status":textTextView.text]
        }
        TwitterClient.sharedInstance.postTweet(dictionary) { (response, error) -> () in
            print(response)
            self.delegate?.didSendTweet(self, response: response!)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
