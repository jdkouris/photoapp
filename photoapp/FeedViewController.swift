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
        
        // Call the PhotoService to retrieve the photos
        PhotoService.retrievePhotos { (retrievedPhotos) in
            // Set our photos array to the retrieved photos
            self.photos = retrievedPhotos
            
            // reload the table view
            self.tableView.reloadData()
        }
    }

}
