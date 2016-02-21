//
//  TwitterClient.swift
//  Twitter
//
//  Created by Jerry on 2/18/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "hrFBmBDx4u4QJ6vNibxw0DHAO"
let twitterConsumerSecret = "1EIJrOBzcRrb4OOTgSQNwCg5oH0rfiwNj79OFk1lF9MmOt17gq"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func postTweet(params: NSDictionary?, completion: (response: NSDictionary?, error: NSError?)->()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (sessionTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let favDict = response as! NSDictionary
            completion(response: favDict, error: nil)
            }) { (sessionTask: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(response: nil, error: error)
        }
    }
    
    func favoriteTweet(params: NSDictionary?, completion: (response: NSDictionary?, error: NSError?)->()) {
        POST("1.1/favorites/create.json", parameters: params, success: { (sessionTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let favDict = response as! NSDictionary
            completion(response: favDict, error: nil)
        }) { (sessionTask: NSURLSessionDataTask?, error: NSError) -> Void in
            completion(response: nil, error: error)
        }
    }
    
    func retweet(params: NSDictionary?, completion: (response: NSDictionary?, error: NSError?)->()) {
        let tweetID = params!["id"]
        POST("1.1/statuses/retweet/\(tweetID!).json", parameters: params, success: { (sessionTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let favDict = response as! NSDictionary
            completion(response: favDict, error: nil)
            }) { (sessionTask: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(response: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (sessionTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetArray = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweetArray, error: nil)
            }, failure: { (sessionTask: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "jerlaotwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            // print("Got success token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            // self.loginCompletion?(user: user, error: nil)
        }) { (error: NSError!) -> Void in
            // print("Did not get success token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            // print(accessToken)
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (sessionTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                // print(user.name)
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (sessionTask: NSURLSessionDataTask?, error: NSError) -> Void in
                    // print(error)
                    self.loginCompletion?(user: nil, error: error)
            })
        }) { (error: NSError!) -> Void in
            // print(error)
            self.loginCompletion?(user: nil, error: error)
        }
    }
}
