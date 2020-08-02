//
//  FavouritesImagesViewController.swift
//  Dogs
//
//  Created by Никита on 30.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritesImagesViewController: UICollectionViewController {
    
    private let cellID = "cellID"
    let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
    
    let realm = try! Realm()
    var breed: String = ""
    var image: String = ""
    
    let load: UIActivityIndicatorView = {
        let load = UIActivityIndicatorView()
        load.style = UIActivityIndicatorView.Style.large
        return load
    }()
    
    func addToFavourite(cell: FavouritesImageCell) {
        
        let collectionviewData = self.realm.objects(Dog.self).filter("breed = '\(self.breed)'")
        let indexPathTapped = self.collectionView.indexPath(for: cell)
        let dog = collectionviewData[indexPathTapped!.row]
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        let hasFavourited = dog.hasFavourited

        try! self.realm.write {
            dog.hasFavourited = !hasFavourited
        }

        if collectionviewData.count == 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        }

        collectionView.reloadData()
        
    }
    
    func setupUI() {
        
        self.view.addSubview(load)
        load.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),style: .plain, target: self, action: #selector(openAlert))
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavouritesImageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
    }
    
    @objc func openAlert() {
        
        let optionMenu = UIAlertController(title: nil, message: "Share photo", preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.sharePhoto()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true)
        
    }
    
    func sharePhoto() {
        
        let imageURl = image
        var image: UIImage?
        let url = URL(string: imageURl)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            image = UIImage(data: imageData)
        }
        
        let shareItems = [breed, image!] as [Any]

        let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)

        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.message]
        activityVC.popoverPresentationController?.sourceView = UIView()

        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.reloadData()
        load.startAnimating()
        setupUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        let objectsToDelete = realm.objects(Dog.self).filter("hasFavourited = false")

        try! self.realm.write {
            realm.delete(objectsToDelete)
        }

    }
}

extension FavouritesImagesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfBreeds = realm.objects(Dog.self).filter("breed = '\(breed)'").count
        return numberOfBreeds
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavouritesImageCell
        
        let collectionviewData = realm.objects(Dog.self).filter("breed = '\(breed)'")
        let dog = collectionviewData[indexPath.row]
        
        image = dog.image!
        
        cell.imageView.kf.setImage(with: URL(string: dog.image!), placeholder: UIImage(named: ""))
        cell.favVC = self
        load.stopAnimating()
        
        if dog.hasFavourited {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        }

        return cell
        
    }
}
