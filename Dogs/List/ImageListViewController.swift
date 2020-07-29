//
//  ImageListViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit
import Kingfisher
//import RealmSwift

class ImageListViewController: UICollectionViewController {
    
    private let cellID = "cellID"
    
    var dogs = [Dog]()
    var breed: String = ""
    
    var dogImage: [Image]!
    var imageResults = [String]()
    let router = ApiRouter()
    
    let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
    
    let load: UIActivityIndicatorView = {
        let load = UIActivityIndicatorView()
        load.style = UIActivityIndicatorView.Style.large
        return load
    }()
    
    func addToFavourite(cell: ImageCell) {
        
        guard let indexPathTapped = collectionView.indexPath(for: cell) else { return }
        let dog = dogs[indexPathTapped.row]
        let hasFavourited = dog.hasFavourited
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        
        dogs[indexPathTapped.row].hasFavourited = !hasFavourited
        
        if dog.hasFavourited {
            cell.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .normal)
        }
        
        print(dog)
        
    }
    
    func setupUI() {
        self.view.addSubview(load)
        load.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
    }
    
    @objc func sharePhoto() {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = "Photo from Dog App"
        
        let objectsToShare = [textToShare, image!] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]

        activityVC.popoverPresentationController?.sourceView = UIView()
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        load.startAnimating()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),style: .plain, target: self, action: #selector(sharePhoto))
        
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
        
        setupUI()
        requestImages()
        
    }
    
    func requestImages() {
        router.requestImages { (images, error) in

            if let imageData = images {
                self.dogImage = imageData
            } else {
                
//                let alert = UIAlertController(title: "Some erver error", message: "Try connect later", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                      switch action.style{
//                      case .default:
//                            print("default")
//                      case .cancel:
//                            print("cancel")
//                      case .destructive:
//                            print("destructive")
//                      @unknown default:
//                        print("Error: \(String(describing: error))")
//                    }}))
//                self.present(alert, animated: true, completion: nil)
                
            }

            let imageArray = self.dogImage[0].message
            for imageType in imageArray {
                self.imageResults.append(imageType)
            }
            
            for image in self.imageResults {
                self.dogs.append(Dog(breed: self.breed, image: image, hasFavourited: false))
            }
            
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
        
        cell.vc = self
        cell.imageView.kf.setImage(with: URL(string: imageResults[indexPath.row]), placeholder: UIImage(named: ""))

        return cell
        
    }
}
