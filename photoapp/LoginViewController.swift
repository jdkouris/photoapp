//
//  LoginViewController.swift
//  photoapp
//
//  Created by John Kouris on 9/11/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style the login button
        loginButton.layer.cornerRadius = 20
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        // Create a Firebase AuthUI object
        let authUI = FUIAuth.defaultAuthUI()
        
        // Check that it isn't nil
        if let authUI = authUI {
            // Set self as delegate for the authUI
            authUI.delegate = self
            
            // Set sign-in providers
            authUI.providers = [FUIEmailAuth()]
            
            // Get the prebuilt UI view controller
            let authViewController = authUI.authViewController()
            
            // Present it
            present(authViewController, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            // There was an error
            return
        }
        
        let user = authDataResult?.user
        
        if let user = user {
            // Got a user
            // Check on the db side if user has a profile
            UserService.retrieveProfile(userId: user.uid) { (user) in
                // Check if user is nil
                if user == nil {
                    // If not, go to create profile view controller
                    self.performSegue(withIdentifier: Constants.Storyboard.profileSegue, sender: self)
                } else {
                    // If so, go to tab bar controller
                    
                    // Save user to local storage
                    LocalStorageService.saveUser(userId: user!.userId, username: user!.username)
                    
                    // Create an instance of the tab bar controller
                    let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController)
                    guard tabBarVC != nil else { return }
                    
                    // Set it as the root view controller of the window
                    self.view.window?.rootViewController = tabBarVC
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
}
