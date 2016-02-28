//
//  ViewController.swift
//  Twitter
//
//  Created by Jerry on 2/18/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {
    
    private var user:User?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTwitterLogin(sender: UIButton) {
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> () in
            if error == nil {
                if let getUser = user {
                    self.user = getUser
                    self.performSegueWithIdentifier("HamburgerSegue", sender: self)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        //nothing goes here
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let hamburgerViewController = segue.destinationViewController as! HamburgerViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        hamburgerViewController.menuViewController = menuViewController
        hamburgerViewController.contentViewController = menuViewController.timelineViewController as! UINavigationController
        menuViewController.hamburgerViewController = hamburgerViewController
    }

}

