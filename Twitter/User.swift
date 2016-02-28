//
//  User.swift
//  Twitter
//
//  Created by Jerry on 2/18/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

var _currentUser:User?
let currentUserKey = "kCurrentUserKey"

class User: NSObject {
    var name:String?
    var username:String?
    var profileImgUrl:String?
    var tagline:String?
    var numTweets:String?
    var numFollowers:String?
    var numFollowing:String?
    var dictionary:NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        username = dictionary["screen_name"] as? String
        profileImgUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        numTweets = "\((dictionary["statuses_count"])!)"
        numFollowers = "\((dictionary["followers_count"])!)"
        numFollowing = "\((dictionary["friends_count"])!)"
    }
    
    func logout(completion: () -> ()) {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        completion()
    }
    
    class var currentUser:User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions(rawValue: 0))
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                    NSUserDefaults.standardUserDefaults().synchronize()
                } catch let error as NSError {
                    print(error)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            NSUserDefaults.standardUserDefaults().synchronize()

        }
    }
}
