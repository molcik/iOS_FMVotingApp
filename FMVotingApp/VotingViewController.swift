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
    @IBOutlet weak var smileHappy: UIButton!
    @IBOutlet weak var smileNeutral: UIButton!
    @IBOutlet weak var smileNoComment: UIButton!
    @IBOutlet weak var smileSad: UIButton!
    
    var user: FIRUser?
    enum votes: Int {
        case happy
        case neutral
        case noComment
        case sad
    }
    let ref = FIRDatabase.database().reference()
    let stats = FIRDatabase.database().referenceWithPath("/statistics")
    
    // MARK: Actions
    var userID:String?

    @IBAction func smileHappyAction(sender: AnyObject) {
        vote(votes.happy)
    }
    @IBAction func smileNeutralAction(sender: AnyObject) {
        vote(votes.neutral)
    }
    @IBAction func smileNoCommentAction(sender: AnyObject) {
        vote(votes.noComment)
    }
    @IBAction func smileSadAction(sender: AnyObject) {
        vote(votes.sad)
    }
    
    // MARK: Networking
    // Record new vote, if succesful call update Statistic
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
                    self.updateStatistic()
                    let alert = UIAlertController.init(title: "Thank You", message: "Your vote has been recorded.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.spinner.stopAnimating()
                }
            })
        }
    }
    
    // Download actual votes count and increment it
    func updateStatistic() {
        // Transaction in reference path "/statistics"
        stats.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var stats = currentData.value as? [String: AnyObject] {
                var votes = stats["votes"] as? Int ?? 0
                votes += 1
                stats["votes"] = votes
                currentData.value = stats
                return FIRTransactionResult.successWithValue(currentData)
            }
            return FIRTransactionResult.successWithValue(currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }


    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        /*
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 5.5, initialSpringVelocity: 3.3, options: .Repeat, animations: {
            self.smileHappy.center.x += self.view.bounds.width
            }, completion: nil)
         */
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
