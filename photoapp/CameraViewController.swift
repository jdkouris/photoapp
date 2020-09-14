//
//  CameraViewController.swift
//  photoapp
//
//  Created by John Kouris on 9/11/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func savePhoto(image: UIImage) {
        // Call the photo service to store the photo
        PhotoService.savePhoto(image: image)
    }

}
