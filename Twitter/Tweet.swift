//
//  Tweet.swift
//  Twitter
//
//  Created by Jerry on 2/18/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user:User?
    var id:String?
    var text:String?
    var createdAtString:String?
    var createdAt:NSDate?
    var createdTime:String?
    var isFavorited = false
    var isRetweeted = false
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        formatter.dateFormat = "MMM d"
        createdTime = formatter.stringFromDate(createdAt!)
        
        if let favorited = dictionary["favorited"] as? Int {
            isFavorited = (favorited == 1)
        }
        
        if let retweeted = dictionary["retweeted"] as? Int {
            isRetweeted = (retweeted == 1)
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

}
