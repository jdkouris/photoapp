//
//  Constants.swift
//  photoapp
//
//  Created by John Kouris on 9/14/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Storyboard {
        static let profileSegue = "goToCreateProfile"
        static let tabBarController = "mainTabBarController"
        static let loginNavController = "loginNavController"
        static let photoCellId = "PhotoCell"
    }
    
    struct LocalStorage {
        static let userIdKey = "storedUserId"
        static let usernameKey = "storedUsername"
    }
    
}
