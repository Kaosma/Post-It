//
//  ViewController.swift
//  Post It
//
//  Created by Erik Ugarte on 2020-08-30.
//  Copyright © 2020 Creative League. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var textField: UITextField!
    
    // MARK: Actions/Functions
    // Logging out the user when pressing the logout button and changing to the login view
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        LoginManager().logOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: true)
    }
    // Changing to the view PostTableView
    @IBAction func viewPostsButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
        self.present(vc, animated: true)
    }
    // Calling the publishPost method when PostButton is pressed
    @IBAction func onPostPressed(_ sender: UIButton) {
        guard let post = textField.text else { return  }
        publishPost(post: post)
    }
    // Posting to the user's Facebook wall
    func publishPost(post: String) {
        print(post)
    }
    // Main
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

