//
//  SettingsViewController.swift
//  photoapp
//
//  Created by John Kouris on 9/11/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style the sign out button
        signOutButton.layer.cornerRadius = 20
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            // Try to sign out the user from Firebase
            try Auth.auth().signOut()
            
            // Clear local storage
            LocalStorageService.clearUser()
            
            // Transition to authentication flow
            let loginNavVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginNavController)
            self.view.window?.rootViewController = loginNavVC
            self.view.window?.makeKeyAndVisible()
        } catch {
            // Couldn't sign out
        }
    }

}
