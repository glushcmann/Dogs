//
//  FavouritesViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController {
    
    private let cellID = "cellID"
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        self.navigationItem.title = "Favourites"
    }
    
}

extension FavouritesViewController {
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return defaults.dictionaryRepresentation().count
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
//        cell.textLabel?.text = defaults.dictionaryRepresentation().in[indexPath.row]
        
        return cell
    }
    
}
