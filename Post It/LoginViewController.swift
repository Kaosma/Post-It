//
//  LoginViewController.swift
//  Post It
//
//  Created by Erik Ugarte on 2020-08-30.
//  Copyright © 2020 Creative League. All rights reserved.
//

import FBSDKLoginKit

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Authenticating and re-logging the user if the user's already logged into the app,
        // Otherwise the Login button is displayed
        if let token = AccessToken.current, !token.isExpired {
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get) // <-- GET REQUEST
            request.start(completionHandler: {connection, result, error in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(vc, animated: true)
            })
        } else {
            let loginButton = FBLoginButton()
            loginButton.center = view.center
            loginButton.delegate = self
            loginButton.permissions = ["public_profile", "email"]
            view.addSubview(loginButton)
        }
    }
    // Authenticating and logging in the user if the login button is pressed
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get) // <-- GET REQUEST
        request.start(completionHandler: {connection, result, error in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(vc, animated: true)
        })
    }
    // Logging out the user, an unnecessary button and only available once other views are downslided
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        LoginManager().logOut()
    }
}
