//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Jerry on 2/25/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController, ProfileViewControllerDelegate, TimelineViewControllerDelegate, MentionsViewControllerDelegate {

    
    @IBOutlet weak var timelineView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet(oldMenuViewController) {
            view.layoutIfNeeded()
        
            if oldMenuViewController != nil {
                oldMenuViewController.willMoveToParentViewController(nil)
                oldMenuViewController.view.removeFromSuperview()
            }
            menuViewController.view.frame = menuView.bounds
            menuViewController.willMoveToParentViewController(self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMoveToParentViewController(self)
        }
    }
    
    var contentViewController: UINavigationController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
            }
            if contentViewController.topViewController is ProfileViewController {
                let profileVC = contentViewController.topViewController as! ProfileViewController
                profileVC.delegate = self
            } else if contentViewController.topViewController is TimelineViewController {
                let timelineVC = contentViewController.topViewController as! TimelineViewController
                timelineVC.delegate = self
            } else if contentViewController.topViewController is MentionsViewController {
                let mentionsVC = contentViewController.topViewController as! MentionsViewController
                mentionsVC.delegate = self
            }
            contentViewController.willMoveToParentViewController(self)
            contentViewController.view.frame = self.timelineView.bounds
            timelineView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            view.layoutIfNeeded()
            UIView.animateWithDuration(0.3) { () -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanContentView(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            print(leftMarginConstraint.constant)
            if leftMarginConstraint.constant > 0 {
                originalLeftMargin = leftMarginConstraint.constant
                print("touch began")
            }
        } else if sender.state == UIGestureRecognizerState.Changed {
            if leftMarginConstraint.constant > 0 {
                leftMarginConstraint.constant = originalLeftMargin + translation.x
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, animations: {
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 60
                    self.toggleBoolOnSwipe(true)
                } else {
                    self.leftMarginConstraint.constant = 0
                    self.toggleBoolOnSwipe(false)
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func toggleBoolOnSwipe(setBool: Bool) {
        if contentViewController.topViewController is ProfileViewController {
            let profileVC = contentViewController.topViewController as! ProfileViewController
            profileVC.isOpen = setBool
        } else if contentViewController.topViewController is TimelineViewController {
            let timelineVC = contentViewController.topViewController as! TimelineViewController
            timelineVC.isOpen = setBool
        } else if contentViewController.topViewController is MentionsViewController {
            let mentionsVC = contentViewController.topViewController as! MentionsViewController
            mentionsVC.isOpen = setBool
        }
    }
    
    func profileViewController(profileViewController: ProfileViewController, didOpenHamburger isOpen: Bool) {
        toggleHamburger(isOpen)
    }
    
    func timelineViewController(timelineViewController: TimelineViewController, didOpenHamburger isOpen: Bool) {
        toggleHamburger(isOpen)
    }
    
    func mentionsViewController(mentionsViewController: MentionsViewController, didOpenHamburger isOpen: Bool) {
        toggleHamburger(isOpen)
    }
    
    func toggleHamburger(isOpen: Bool){
        if !isOpen {
            UIView.animateWithDuration(0.3, animations: {
                self.leftMarginConstraint.constant = self.view.frame.size.width - 60
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
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
