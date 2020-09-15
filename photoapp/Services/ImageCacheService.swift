//
//  ImageCacheService.swift
//  photoapp
//
//  Created by John Kouris on 9/14/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class ImageCacheService {
    
    static var imageCache = [String: UIImage]()
    
    static func saveImage(url: String?, image: UIImage?) {
        // Check against nil
        guard let url = url, let image = image else { return }
        
        // Save the image
        imageCache[url] = image
    }
    
    static func getImage(url: String?) -> UIImage? {
        // Check that url isn't nil
        guard let url = url else { return nil }
        
        // Check the image cache for the url
        return imageCache[url]
    }
    
}
