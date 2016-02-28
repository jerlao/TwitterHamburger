//
//  MenuViewController.swift
//  Twitter
//
//  Created by Jerry on 2/25/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import AFNetworking

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    private let menuArray = ["Timeline", "Mentions", "Profile"]
    var hamburgerViewController: HamburgerViewController!
    var timelineViewController: UIViewController!
    var mentionsViewController: UIViewController!
    private var profileViewController: UIViewController!
    private var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        timelineViewController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController")
        mentionsViewController = storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationController")
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        
        viewControllers.append(timelineViewController)
        viewControllers.append(mentionsViewController)
        viewControllers.append(profileViewController)
        tableView.rowHeight = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        cell.viewLabel.text = menuArray[indexPath.row]
        switch indexPath.row {
        case 0: cell.iconImageView.image = UIImage(named: "feed")
        case 1: cell.iconImageView.image = UIImage(named: "timeline")
        case 2: cell.iconImageView.image = UIImage(named: "profile")
        default: cell.iconImageView.image = UIImage(named: "feed")
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let contentVC = viewControllers[indexPath.row] as! UINavigationController
        hamburgerViewController.contentViewController = contentVC
        if contentVC.topViewController is TimelineViewController {
            let timelineVC = contentVC.topViewController as! TimelineViewController
            timelineVC.isOpen = false
        } else if contentVC.topViewController is MentionsViewController {
            let mentionsVC = contentVC.topViewController as! MentionsViewController
            mentionsVC.isOpen = false
        } else {
            let profileVC = contentVC.topViewController as! ProfileViewController
            profileVC.isOpen = false
        }
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
