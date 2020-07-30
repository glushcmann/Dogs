//
//  FavouritesViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritesViewController: UITableViewController {
    
    let realm = try! Realm()
    
    private let cellID = "cellID"
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Favourites"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    }
    
}

extension FavouritesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let results = realm.objects(Dog.self).filter("hasFavourited = true")
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  отобразить все лайки
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
//        let results = realm.objects(Dog.self).filter("hasFavourited = true")
        
        cell.textLabel?.text = "1"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
}
