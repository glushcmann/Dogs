//
//  SublistViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit

class SublistViewController: UITableViewController {
    
    static var subBreedTitle: String = ""
    private let cellID = "cellID"
    
    let breed: String = ListViewController.breedTitle
    var dogBreed: [Breed]!
    let router = ApiRouter()
    var subBreedResults: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = breed
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        
        requestFromApi()
        
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestFromApi() {
        router.requestBreeds { (data, error) in
            
            if let data = data {
                self.dogBreed = data
            } else {
                print("Error: \(String(describing: error))")
            }
            
            let line = ListViewController.breedTitle.lowercased()
            let subBreedArray = self.dogBreed[0].message[line]
            
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
        
        SublistViewController.subBreedTitle = subBreedResults[indexPath.row].capitalized
        let vc = ImageListViewController()
        vc.navigationController?.navigationItem.title = subBreedResults[indexPath.row].capitalized
        self.navigationController?.pushViewController(ImageListViewController(), animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popVC))
        
    }
    
}
