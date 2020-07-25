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
    
    @objc func sharePhoto() {
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = breed
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),style: .plain, target: self, action: #selector(sharePhoto))
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 20.0
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
