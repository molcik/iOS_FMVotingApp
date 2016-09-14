//
//  VotingViewController.swift
//  FMVotingApp
//
//  Created by Filip Molcik on 14/09/16.
//  Copyright © 2016 Filip Molcik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class VotingViewController: UIViewController {
    
    // MARK: Attributes
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var user: FIRUser?
    enum votes: String {
        case happy
        case sad
        case neutral
        case angry
    }
    let ref = FIRDatabase.database().reference()
    
    // MARK: Actions
    var userID:String?
    @IBAction func smileHappyAction(sender: AnyObject) {
        vote(votes.happy)
    }
    @IBAction func smileSadAction(sender: AnyObject) {
        vote(votes.sad)
    }
    @IBAction func smileNeutralAction(sender: AnyObject) {
        vote(votes.neutral)
    }
    
    // 
    func vote(vote: votes ) {
        if let user = user {
            self.spinner.startAnimating()
            // data to save
            let key = ref.child("votes").childByAutoId().key
            let entry = ["uid": user.uid,
                        "timestamp": Firebase.FIRServerValue.timestamp(),
                        "vote": vote.rawValue]
            let childUpdates = ["/votes/\(key)": entry,
                                "/user-votes/\(user.uid)/\(key)/": entry]
            // save data
            self.ref.updateChildValues(childUpdates, withCompletionBlock: { (error, snapshot) in
                if error != nil {
                    // show error
                    let alert = UIAlertController.init(title: "Error", message: "There was an error with processing your vote, pleas try again later", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.spinner.stopAnimating()
                } else {
                    // show thanks note
                    let alert = UIAlertController.init(title: "Thank You", message: "Your vote has been recorded.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.spinner.stopAnimating()
                }
            })
        } else {
            
        }
    }

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Orientation
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
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
