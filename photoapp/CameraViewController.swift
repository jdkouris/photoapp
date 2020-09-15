//
//  CameraViewController.swift
//  photoapp
//
//  Created by John Kouris on 9/11/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var doneButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style the done button
        doneButton.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide and reset all elements
        progressBar.alpha = 0
        progressBar.progress = 0
        
        doneButton.alpha = 0
        
        progressLabel.alpha = 0
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        // Get a reference to the tab bar controller
        let tabBarVC = self.tabBarController as? MainTabBarController
        
        if let tabBarVC = tabBarVC {
            // Call go to feed
            tabBarVC.goToFeed()
        }
    }
    
    
    func savePhoto(image: UIImage) {
        // Call the photo service to store the photo
        PhotoService.savePhoto(image: image) { (pct) in
            DispatchQueue.main.async {
                // Update the progress bar
                self.progressBar.alpha = 1
                self.progressBar.progress = Float(pct)
                
                // Update the label
                let roundedPct = Int(pct * 100)
                self.progressLabel.text = "\(roundedPct)%"
                self.progressLabel.alpha = 1
                
                // Check if it's done
                if pct == 1 {
                    self.doneButton.alpha = 1
                    self.progressLabel.text = "Upload Complete!"
                }
            }
        }
    }

}
