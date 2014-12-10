//
//  SocialCalendarViewController.swift
//  socialCalendar
//
//  Created by Miles Crabill on 12/10/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit

class SocialCalendarViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for vc in viewControllers {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logout")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func logout() {
        PFUser.logOut()
        var vc = storyboard?.instantiateInitialViewController() as LoginViewController
        presentViewController(vc, animated: true, completion: nil)
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
