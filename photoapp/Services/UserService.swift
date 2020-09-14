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
