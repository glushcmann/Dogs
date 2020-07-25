//
//  ImageListViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit
import Kingfisher

class ImageListViewController: UICollectionViewController {
    
    private let cellID = "cellID"
    var breed: String = ListViewController.breedTitle
    let subBreed: String = SublistViewController.subBreedTitle
    var dogImage: [Image]!
    var imageResults = [String]()
    let router = ApiRouter()
    
    let likeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        return button
    }()
    
    func setupUI() {
        
        self.view.addSubview(likeButton)
        addConstrint(withVisualFormat: "H:[v0]-50-|", views: likeButton)
        addConstrint(withVisualFormat: "V:[v0]-50-|", views: likeButton)
        
    }
    
    @objc func sharePhoto() {
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = breed
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),style: .plain, target: self, action: #selector(sharePhoto))
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal

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
                print("Error: \(String(describing: error))")
            }

            let imageArray = self.dogImage[0].message
            for imageType in imageArray {
                self.imageResults.append(imageType)
            }

            self.collectionView.reloadData()
//            self.loading.stopAnimating()
        }
    }
    
}

extension ImageListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCell
     
        cell.imageView.kf.setImage(with: URL(string: imageResults[indexPath.row]), placeholder: UIImage(named: ""))

        return cell
    }
}
