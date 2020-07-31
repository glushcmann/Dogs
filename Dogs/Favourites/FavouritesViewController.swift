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
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let collectionviewData = realm.objects(Dog.self).filter("hasFavourited = true")
        let dog = collectionviewData[indexPath.row]
        let breed: String = dog.breed!
        let numberOfPhotoInBreed = collectionviewData.filter("breed = '\(breed)'").count
        
        cell.textLabel?.text = "\(breed) (\(numberOfPhotoInBreed) photos)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let collectionviewData = realm.objects(Dog.self).filter("hasFavourited = true")
        let dog = collectionviewData[indexPath.row]
        

        
        let layout = UICollectionViewFlowLayout()
        let vc = FavouritesImagesViewController(collectionViewLayout: layout)
        vc.breed = dog.breed!
        vc.navigationItem.title = dog.breed
        self.navigationController?.pushViewController(vc, animated: false)
        
//        let layout = UICollectionViewFlowLayout()
//        let vc = ImageListViewController(collectionViewLayout: layout)
//        vc.breed = subBreedResults[indexPath.row].capitalized
//        vc.navigationItem.title = subBreedResults[indexPath.row].capitalized
//        self.navigationController?.pushViewController(vc, animated: false)
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popVC))
    }
    
}
