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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Breeds"
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
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
                
                let alert = UIAlertController(title: "Some erver error", message: "Try connect later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                      switch action.style{
                      case .default:
                            print("default")
                      case .cancel:
                            print("cancel")

                      case .destructive:
                            print("destructive")
                      @unknown default:
                        print("Error: \(String(describing: error))")
                    }}))
                self.present(alert, animated: true, completion: nil)
                
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
            
            let vc = SublistViewController()
            vc.navigationItem.title = breedResults[indexPath.row].capitalized
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Breeds", style: .plain, target: self, action: #selector(popVC))
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let layout = UICollectionViewFlowLayout()
            let vc = ImageListViewController(collectionViewLayout: layout)
            vc.navigationItem.title = breedResults[indexPath.row].capitalized
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popVC))
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}
