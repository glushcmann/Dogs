//
//  ListViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    static var breedTitle: String = ""
    static var breedIndexPathRow: Int = 0
    private let cellID = "cellID"
    
    var dogBreed: [Breed]!
//    var dogImage: [Image]!
    let router = ApiRouter()
    var breedResults: [String] = []
    var subBreedResults: [String] = []
    var finalResult: [String : [String]] = ["":[""]]
//    var imageResults = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Breeds"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

        tableView.delegate = self
        tableView.dataSource = self
        
        requestFromApi()
//        requestImages()
        
    }
    
    func requestFromApi() {
        router.requestBreeds { (data, error) in
            
            if let data = data {
                self.dogBreed = data
            } else {
                print("Error: \(String(describing: error))")
            }
            
//            for (key, value) in self.dogBreed[0].message {
//                self.breedResults.append(key)
//                self.subBreedResults.append(contentsOf: value)
//            }
            
            self.finalResult = self.dogBreed[0].message
            let breedArray = self.dogBreed[0].message.keys.sorted()
            
            for type in breedArray {
                self.breedResults.append(type)
            }
            self.tableView.reloadData()
        }
    }
    
//    func requestImages() {
//        router.requestImages { (images, error) in
//
//            if let imageData = images {
//                self.dogImage = imageData
//            } else {
//                print("Error: \(String(describing: error))")
//            }
//
//            let imageArray = self.dogImage[0].message
//            for imageType in imageArray {
//                self.imageResults.append(imageType)
//            }
//
//            self.imageCollectionView.reloadData()
//            self.loading.stopAnimating()
//        }
//    }
    
}

extension ListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        if finalResult[breedResults[indexPath.row]]!.count != 0 {
            cell.textLabel?.text = "\(breedResults[indexPath.row].capitalized) (\(finalResult[breedResults[indexPath.row]]!.count) subbreeds)"
        } else {
            cell.textLabel?.text = "\(breedResults[indexPath.row].capitalized)"
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ListViewController.breedTitle = breedResults[indexPath.row].capitalized
        ListViewController.breedIndexPathRow = indexPath.row
        
        if finalResult[breedResults[indexPath.row]]!.count != 0 {
            navigationController?.pushViewController(SublistViewController(), animated: false)
        } else {
            navigationController?.pushViewController(ImageListViewController(), animated: false)
        }
    }
    
}
