//
//  PhotoCell.swift
//  photoapp
//
//  Created by John Kouris on 9/14/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    var photo: Photo?
    
    func displayPhoto(photo: Photo) {
        // Reset the image
        self.photoImageView.image = nil
        
        // Set photo property
        self.photo = photo
        
        // Set the username
        usernameLabel.text = photo.byUsername
        
        // Set the date
        dateLabel.text = photo.date
        
        // Check if the image is in the image cache, otherwise, download it
        if let cachedImage = ImageCacheService.getImage(url: photo.url!) {
            // Use the cached image
            self.photoImageView.image = cachedImage
            
            // Return because we don't need to download the image
            return
        }
        
        // Check that there's a valid download url
        guard let photoURLString = photo.url else { return }
        guard let url = URL(string: photoURLString) else { return }
        
        // Use url session to download the image asynchonously
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil && data != nil {
                // Set the image view
                let image = UIImage(data: data!)
                
                // Store the image data in cache
                ImageCacheService.saveImage(url: url.absoluteString, image: image)
                
                // Check that the image data we downloaded matches the photo this cell is currently displaying
                if url.absoluteString != self.photo?.url {
                    // The url we downloaded doesn't match the url this cell is currently displaying
                    return
                }
                
                // Set the image view
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            }
        }
        dataTask.resume()
    }

}
