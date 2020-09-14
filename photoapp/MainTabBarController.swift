//
//  MainTabBarController.swift
//  photoapp
//
//  Created by John Kouris on 9/14/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Detect which tab was tapped
        if item.tag == 2 { // Camera tab
            // Create the action sheet
            let actionSheet = UIAlertController(title: "Add a Photo", message: "Select a source:", preferredStyle: .actionSheet)
            
            // Only add the camera button if it's available
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // Create and add the Camera button
                let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
                    // Display the UIImagePickercontroller set to camera mode
                    self.showImagePickerController(mode: .camera)
                }
                actionSheet.addAction(cameraButton)
            }
            
            // Only add the library button if it's available
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                // Create and add the Photo Library button
                let libraryButton = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                    // display the UIImagePickerController set to library mode
                    self.showImagePickerController(mode: .photoLibrary)
                }
                actionSheet.addAction(libraryButton)
            }
            
            // Create and add the cancel button
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheet.addAction(cancelButton)
            
            // Display the action sheet
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func showImagePickerController(mode: UIImagePickerController.SourceType) {
        // Create the picker and set the mode
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = mode
        
        // Set the tab bar controller as the delegate
        imagePicker.delegate = self
        
        // Present the image picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    func goToFeed() {
        // Switch tab to the first one
        selectedIndex = 0
    }

}

extension MainTabBarController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get a reference to the selected photo
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        // Check that the selected image isn't nil
        if let selectedImage = selectedImage {
            // Get a reference to the camera view controller
            let cameraVC = self.selectedViewController as? CameraViewController
            
            if let cameraVC = cameraVC {
                // Upload it
                cameraVC.savePhoto(image: selectedImage)
            }
        }
        
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
    
}
