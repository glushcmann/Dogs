//
//  SublistViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit

class SublistViewController: UITableViewController {
    
    private let cellID = "cellID"
    let breed: String = ListViewController.breedTitle
    var dogBreed: [Breed]!
    let router = ApiRouter()
    var breedResults: [String] = []
    var subBreedResults: [String] = []
    var finalResult: [String : [String]] = ["":[""]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = breed
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

        tableView.delegate = self
        tableView.dataSource = self
        
        requestFromApi()
        
    }
    
    func requestFromApi() {
        router.requestBreeds { (data, error) in
            
            if let data = data {
                self.dogBreed = data
            } else {
                print("Error: \(String(describing: error))")
            }
            
            let line = ListViewController.breedTitle.lowercased()
            self.finalResult = self.dogBreed[0].message
            let breedArray = self.dogBreed[0].message.keys.sorted()
            let subBreedArray = self.dogBreed[0].message[line]
            
            for type in breedArray {
                self.breedResults.append(type)
            }
            for type in subBreedArray! {
                self.subBreedResults.append(type)
            }
            self.tableView.reloadData()
        }
    }
    
}

extension SublistViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subBreedResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = subBreedResults[indexPath.row].capitalized
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.pushViewController(ImageListViewController(), animated: false)
        
    }
    
}
