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
    
    private let cellID = "cellID"
    
    let realm = try! Realm()
    
    var dogs: Results<Dog>?
    var dogsUnique: Results<Dog>?
    var notificationToken: NotificationToken?
    var notificationTokenDistinct: NotificationToken?
    
    func addObserver() {
        
        dogs = realm.objects(Dog.self).filter("hasFavourited = true")
        dogsUnique = realm.objects(Dog.self).distinct(by: ["breed"])

        notificationToken = dogs!.observe { change in
            switch change {
            case .update:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            default: ()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        addObserver()
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Favourites"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
}

extension FavouritesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let results = realm.objects(Dog.self).filter("hasFavourited = true").count
        let uniqueResults = realm.objects(Dog.self).filter("hasFavourited = true").distinct(by: ["breed"]).count
        
        return uniqueResults
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let collectionviewDataForBreed = realm.objects(Dog.self).filter("hasFavourited = true").distinct(by: ["breed"])
        let collectionviewDataForImage = realm.objects(Dog.self).filter("hasFavourited = true")
        let dog = collectionviewDataForBreed[indexPath.row]
        let breed: String = dog.breed!
        let numberOfPhotoInBreed = collectionviewDataForImage.filter("breed = '\(breed)'").count
        
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
        
    }
}
