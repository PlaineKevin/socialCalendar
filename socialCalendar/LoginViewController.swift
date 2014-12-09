//
//  LoginViewController.swift
//  socialCalendar
//
//  Created by Miles Crabill on 12/2/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!

    @IBAction func loginVerifyButton(sender: AnyObject) {

        var username = usernameTextField.text
        var password = passwordTextField.text

        if username != "" && password != "" {
            loginUser()
        } else {
            var errorPopup = UIAlertController(title: "Please enter a username and password.", message: nil, preferredStyle: .Alert)
            var okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            errorPopup.addAction(okayAction)
            self.presentViewController(errorPopup, animated: true, completion: nil)
        }
    }

    @IBAction func signupVerifyButton(sender: AnyObject) {
        signupUser()
    }

    func loginUser() {
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) {
            user, error in
            if user != nil {
                self.performSegueWithIdentifier("login", sender: self)
            } else {
                var errorPopup = UIAlertController(title: "Login failed.", message: error.localizedDescription, preferredStyle: .Alert)
                var okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                errorPopup.addAction(okayAction)
                self.presentViewController(errorPopup, animated: true, completion: nil)
            }
        }

    }

    func signupUser() {
        var signupPopup = UIAlertController(title: "Create a Soshall account", message: nil, preferredStyle: .Alert)

        signupPopup.addTextFieldWithConfigurationHandler {
            textField in
            textField.placeholder = "Username"
        }

        signupPopup.addTextFieldWithConfigurationHandler {
            textField in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        }

        signupPopup.addTextFieldWithConfigurationHandler {
            textField in
            textField.placeholder = "Email address"
            textField.keyboardType = .EmailAddress
        }

        var registerAction = UIAlertAction(title: "Register", style: .Default, handler: {
            _ in
            var user = PFUser()
            user.username = (signupPopup.textFields![0] as UITextField).text
            user.password = (signupPopup.textFields![1] as UITextField).text
            user.email = (signupPopup.textFields![2] as UITextField).text

            user.signUpInBackgroundWithBlock {
                success, error in
                if success {
                    self.performSegueWithIdentifier("login", sender: self.navigationController)
                } else {
                    var errorPopup = UIAlertController(title: "An error occurred while registering", message: error.localizedDescription, preferredStyle: .Alert)
                    var okayActionInner = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                    errorPopup.addAction(okayActionInner)
                    self.presentViewController(errorPopup, animated: true, completion: nil)
                }
            }

        })
        signupPopup.addAction(registerAction)
        presentViewController(signupPopup, animated: true, completion: nil)
    }

    func logout() {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // cached user logged in
            performSegueWithIdentifier("login", sender: self)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "login" {
            let vc = segue.destinationViewController as CalendarTabBarViewController
            vc.navigationItem.hidesBackButton = true
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logout")
            vc.navigationItem.title = PFUser.currentUser().username + "'s events"
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        // if no one is logged in, don't perform segue
        if identifier == "login" && PFUser.currentUser() == nil {
            return false
        }

        return true
    }

}
