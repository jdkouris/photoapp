//
//  CreateProfileViewController.swift
//  photoapp
//
//  Created by John Kouris on 9/11/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateProfileViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style the confirm button
        confirmButton.layer.cornerRadius = 20
    }

    @IBAction func confirmTapped(_ sender: Any) {
        // Check that there is a user logged in
        guard Auth.auth().currentUser != nil else { return }
        
        // Get the username
        // Check it against whitespaces, new lines, illegal character, etc.
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check that the username isn't nil
        if username == nil || username == "" {
            // Show an error message
            return
        }
        
        // Call the user service to create the profile
        UserService.createProfile(userId: Auth.auth().currentUser!.uid, username: username!) { (user) in
            // Check if it was created successfully
            if user != nil {
                // If so, go to the tab bar controller
                
                // Save the user to local storage
                LocalStorageService.saveUser(userId: user!.userId, username: user!.username)
                
                let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController)
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()
            } else {
                // If not, display error
            }
        }
    }

}
