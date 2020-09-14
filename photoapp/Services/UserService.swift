//
//  UserService.swift
//  photoapp
//
//  Created by John Kouris on 9/14/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation
import FirebaseFirestore

class UserService {
    
    static func createProfile(userId: String, username: String, completion: @escaping (PhotoUser?) -> Void) {
        // Create a dictionary for the profile data
        let profileData = ["username": username]
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Create the document for the userid
        db.collection("users").document(userId).setData(profileData) { (error) in
            if error == nil {
                // Profile created successfully
                // Create and return a photo user
                var user = PhotoUser()
                user.username = username
                user.userId = userId
                
                completion(user)
            } else {
                // Something went wrong
                // Return nil
                completion(nil)
            }
        }
    }
    
    static func retrieveProfile(userId: String, completion: @escaping (PhotoUser?) -> Void) {
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Check for a profile, given the user id
        db.collection("users").document(userId).getDocument { (snapshot, error) in
            
            if error != nil || snapshot == nil {
                // An error occurred
                return
            }
            
            if let profile = snapshot!.data() {
                // Profile was found, create a new Photo user
                var user = PhotoUser()
                user.userId = snapshot!.documentID
                user.username = profile["username"] as? String
                
                // Return the user
                completion(user)
            } else {
                // Couldn't get profile, no profile
                // Return nil
                completion(nil)
            }
        }
    }
    
}
