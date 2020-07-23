//
//  TabBarController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let ListController = UINavigationController(rootViewController: ListViewController())
        ListController.title = "List"
        ListController.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        let FavouritesController = UINavigationController(rootViewController: FavouritesViewController())
        FavouritesController.title = "Favourites"
        FavouritesController.tabBarItem.image = UIImage(systemName: "heart.fill")
        
        viewControllers = [ListController, FavouritesController]
        
    }
}
