//
//  LoginViewController.swift
//  FMVotingApp
//
//  Created by Filip Molcik on 14/09/16.
//  Copyright © 2016 Filip Molcik. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //varRK: Atributes
    
    @IBOutlet weak var mobileIDField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    // MARK: Actions
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        
        let username = mobileIDField.text
        let password = passwordField.text
        
        // Validate the text fields
        if username!.isEmpty || password!.isEmpty {
            let alert = UIAlertController.init(title: "Alert", message: "All fields are mandatory, please fill them.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Run a spinner to show a task in progress
            self.spinner.startAnimating()
            loginButtonOutlet.userInteractionEnabled = false
            FIRAuth.auth()?.signInWithEmail(username!, password: password!) { (user, error) in
                if error != nil {
                    // There was an error logging in to this account
                    self.spinner.stopAnimating()
                    self.loginButtonOutlet.userInteractionEnabled = true
                    print(error)
                    let alert = UIAlertController.init(title: "Error", message: "There was an error login in. Check your credentials and try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    // We are now logged in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.spinner.stopAnimating()
                        self.loginButtonOutlet.userInteractionEnabled = true
                        let votingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Voting") as! VotingViewController
                        votingViewController.user = user
                        self.presentViewController(votingViewController, animated: true, completion: nil)
                    })
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

