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
    private let cellID = "cellID"
    
    var dogBreed: [Breed]!
    let router = ApiRouter()
    var breedResults: [String] = []
    var subBreedResults: [String] = []
    var finalResult: [String : [String]] = ["":[""]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Breeds"
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
            
            self.finalResult = self.dogBreed[0].message
            let breedArray = self.dogBreed[0].message.keys.sorted()
            
            for type in breedArray {
                self.breedResults.append(type)
            }
            self.tableView.reloadData()
        }
    }
    
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
        
        if finalResult[breedResults[indexPath.row]]!.count != 0 {
            navigationController?.pushViewController(SublistViewController(), animated: true)
        } else {
            navigationController?.pushViewController(ImageListViewController(), animated: true)
        }
    }
    
}
