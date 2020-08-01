//
//  ImageListViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift
import Alamofire

class ImageListViewController: UICollectionViewController {
    
    private let cellID = "cellID"
    let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
    var imageShowing = 0
    
    let realm = try! Realm()
    var dogs = Dog()
    var breed: String = ""
    
    var dogImage: [Image]!
    var imageResults = [String]()
    
    let load: UIActivityIndicatorView = {
        let load = UIActivityIndicatorView()
        load.style = UIActivityIndicatorView.Style.large
        return load
    }()
    
    func addToRealm() {
        
        for image in self.imageResults {
            
            let dog = Dog()
            dog.breed = self.breed
            dog.image = image
            dog.hasFavourited = false
            
            try! self.realm.write {
                self.realm.add(dog)
            }
        
        }
    }
    
    func addToFavourite(cell: ImageCell) {
        
        let collectionviewData = self.realm.objects(Dog.self).filter("breed = '\(self.breed)'")
        let indexPathTapped = self.collectionView.indexPath(for: cell)
        let dog = collectionviewData[indexPathTapped!.row]
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        let hasFavourited = dog.hasFavourited
        
        try! self.realm.write {
            dog.hasFavourited = !hasFavourited
        }

        if dog.hasFavourited {
            cell.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .normal)
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
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
    }
    
    func requestImages(completion: @escaping([Image]?, Error?) -> Void) {
        
        let URL = "https://dog.ceo/api/breeds/image/random/10"
        
        AF.request(URL).responseJSON { response in
            switch response.result {
                
            case .success :
                let decoder = JSONDecoder()
                if let result = try?
                    decoder.decode(Image.self, from: response.data!) {
                    completion([result], nil)
                }
                
            case .failure(_):
                self.apiAlert()
            }
        }
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
    
    func apiAlert() {
        
        let alert = UIAlertController(title: "Some server error", message: "Try connect later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")
              case .cancel:
                    print("cancel")
              case .destructive:
                    print("destructive")
              @unknown default:
                print("Error")
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func sharePhoto() {
        
        let imageURl = imageResults[imageShowing]
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
        
        load.startAnimating()
        setupUI()
        dataProccesing()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        let objectsToDelete = realm.objects(Dog.self).filter("hasFavourited = false")

        try! self.realm.write {
            realm.delete(objectsToDelete)
        }

    }
    
    func dataProccesing() {
        self.requestImages { (images, error) in

            if let imageData = images {
                self.dogImage = imageData
            } else {}

            let imageArray = self.dogImage[0].message
            for imageType in imageArray {
                self.imageResults.append(imageType)
            }
            
            self.addToRealm()
            self.collectionView.reloadData()
            self.load.stopAnimating()
            
        }
    }
}

extension ImageListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCell
        
        let collectionviewData = realm.objects(Dog.self).filter("breed = '\(breed)'")
        let dog = collectionviewData[indexPath.row]
        let image: String = dog.image!
        imageShowing = indexPath.row
        
        cell.listVC = self
        cell.imageView.kf.setImage(with: URL(string: image), placeholder: UIImage(named: ""))
        
        if dog.hasFavourited {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        }
        
        return cell
        
    }
}
