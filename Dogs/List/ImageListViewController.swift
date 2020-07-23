//
//  ImageListViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {
    
    var breed: String = ListViewController.breedTitle
    let subBreed: String = SublistViewController.subBreedTitle
    var dogImage: [Image]!
    var imageResults = [String]()
    let router = ApiRouter()
    
    @objc func sharePhoto() {
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = breed
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),style: .plain, target: self, action: #selector(sharePhoto))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popVC))
        
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

//            self.imageCollectionView.reloadData()
//            self.loading.stopAnimating()
        }
    }
    
}

