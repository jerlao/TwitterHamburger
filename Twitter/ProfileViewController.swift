//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Jerry on 2/26/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol ProfileViewControllerDelegate {
    optional func profileViewController(profileViewController: ProfileViewController, didOpenHamburger isOpen: Bool)
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var hamburgerButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var signoutButtonOutlet: UIButton!
    var isOpen = false
    weak var delegate:ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.barTintColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        backgroundImageView.image = UIImage(named: "bgImage")
        let imageUrl = NSURL(string: (User.currentUser?.profileImgUrl)!)
        profileImageView.setImageWithURL(imageUrl!)
        profileImageView.layer.cornerRadius = 10
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.clipsToBounds = true
        userNameLabel.text = User.currentUser?.name
        tweetsLabel.text = User.currentUser!.numTweets ?? "0"
        followingLabel.text = User.currentUser!.numFollowing ?? "0"
        followersLabel.text = User.currentUser!.numFollowers ?? "0"
        signoutButtonOutlet.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHamburgerTapped(sender: AnyObject) {
        delegate?.profileViewController!(self, didOpenHamburger: isOpen)
        isOpen = !isOpen
    }

    @IBAction func onSignout(sender: UIButton) {
        User.currentUser?.logout({ () -> () in
            // self.dismissViewControllerAnimated(true, completion: nil)
            // self.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("UnwindToLogin", sender: self)
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
