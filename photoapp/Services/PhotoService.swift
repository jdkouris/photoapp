//
//  PhotoService.swift
//  photoapp
//
//  Created by John Kouris on 9/14/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class PhotoService {
    
    static func retrievePhotos(completion: @escaping ([Photo]) -> Void) {
        // Get a db reference
        let db = Firestore.firestore()
        
        // Get all the documents from the photos collection
        db.collection("photos").getDocuments { (snapshot, error) in
            // Check for errors
            if error != nil { return }
            
            // Get all the documents
            guard let documents = snapshot?.documents else { return }
            
            // Create an array to hold all of our Photo structs
            var photoArray = [Photo]()
            
            // Loop through the documents, create a Photo object for each
            for doc in documents {
                // Create photo object
                let photo = Photo(snapshot: doc)
                
                if photo != nil {
                    // store it in our array
                    photoArray.insert(photo!, at: 0)
                }
            }
            
            // Pass back the photo array
            completion(photoArray)
        }
    }
    
    static func savePhoto(image: UIImage, progressUpdate: @escaping (Double) -> Void) {
        // Check that there's a user logged in
        if Auth.auth().currentUser == nil { return }
        
        // Get the data representation of the UIImage
        let photoData = image.jpegData(compressionQuality: 0.1)
        guard photoData != nil else { return }
        
        // Create a filename
        let filename = UUID().uuidString
        
        // Get the user id of the current user
        let userId = Auth.auth().currentUser!.uid
        
        // Create a firebase storage path/reference
        let ref = Storage.storage().reference().child("images/\(userId)/\(filename).jpg")
        
        // Upload the data
        let uploadTask = ref.putData(photoData!, metadata: nil) { (metadata, error) in
            // Check if upload was successful
            if error == nil {
                // Upon successful upload, create the database entry
                self.createDatabaseEntry(ref: ref)
            }
        }
        
        uploadTask.observe(.progress) { (taskSnapshot) in
            let pct = Double(taskSnapshot.progress!.completedUnitCount) / Double(taskSnapshot.progress!.totalUnitCount)
            progressUpdate(pct)
        }
    }
    
    private static func createDatabaseEntry(ref: StorageReference) {
        // Download url
        ref.downloadURL { (url, error) in
            // If there's no error, then proceed
            if error == nil {
                // Photo id
                let photoId = ref.fullPath
                
                // Get the current user
                let photoUser = LocalStorageService.loadUser()
                
                // User id
                let userId = photoUser?.userId
                
                // Username
                let username = photoUser?.username
                
                // Date
                let df = DateFormatter()
                df.dateStyle = .full
                
                let dateString = df.string(from: Date())
                
                // Create a dictionary of the photo metadata
                let metadata = ["photoId": photoId, "byId": userId!, "byUsername": username!, "date": dateString, "url": url!.absoluteString]
                
                // Save the metadata to the firestore database
                let db = Firestore.firestore()
                
                db.collection("photos").addDocument(data: metadata) { (error) in
                    // Check if saving data was successful
                    if error == nil {
                        // Created db entry for the photo
                    }
                }
            }
        }
    }
    
}
