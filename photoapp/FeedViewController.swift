//
//  FeedViewController.swift
//  photoapp
//
//  Created by John Kouris on 9/11/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set view controller as the data source and delege
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add pull-to-refresh
        addRefreshControl()
        
        // Call the PhotoService to retrieve the photos
        PhotoService.retrievePhotos { (retrievedPhotos) in
            // Set our photos array to the retrieved photos
            self.photos = retrievedPhotos
            
            // reload the table view
            self.tableView.reloadData()
        }
    }
    
    func addRefreshControl() {
        // Create refresh control
        let refreshControl = UIRefreshControl()
        
        // Set target
        refreshControl.addTarget(self, action: #selector(refreshFeed(refreshControl:)), for: .valueChanged)
        
        // Add to table view
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshFeed(refreshControl: UIRefreshControl) {
        // Call the photo service
        PhotoService.retrievePhotos { (newPhotos) in
            // Assign new photos to photos property
            self.photos = newPhotos
            
            DispatchQueue.main.async {
                // Refresh table view
                self.tableView.reloadData()
                
                // Stop the spinner
                refreshControl.endRefreshing()
            }
        }
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a photo cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.photoCellId, for: indexPath) as? PhotoCell else { return UITableViewCell() }
        
        // Get the photo this cell is displaying
        let photo = self.photos[indexPath.row]
        
        // call display photo method of the cell
        cell.displayPhoto(photo: photo)
        
        // Return cell
        return cell
    }
    
}
