//
//  ListViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit
import Alamofire

class ListViewController: UITableViewController {
    
    private let cellID = "cellID"
    
    var dogBreed: [Breed]!
    var breedResults: [String] = []
    var finalResult: [String : [String]] = ["":[""]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
    
    func requestBreeds(completion: @escaping([Breed]?, Error?) -> Void) {
        
        let URL = "https://dog.ceo/api/breeds/list/all"
        
        AF.request(URL).responseJSON { response in
            switch response.result {
                
            case .success :
                
                let decoder = JSONDecoder()
                if let result = try?
                    decoder.decode(Breed.self, from: response.data!) {
                    completion([result], nil)
                } else {
                    print("Unable to decode data")
                }
                
            case .failure(_):
                self.apiAlert()
            }
            
        }
    }
    
    func requestFromApi() {
        self.requestBreeds { (data, error) in
            
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
        
        let number = finalResult[breedResults[indexPath.row]]!.count
        
        if  number == 1 {
            cell.textLabel?.text = "\(breedResults[indexPath.row].capitalized) (\(finalResult[breedResults[indexPath.row]]!.count) subbreed)"
        } else if number == 0 {
            cell.textLabel?.text = "\(breedResults[indexPath.row].capitalized)"
        } else {
            cell.textLabel?.text = "\(breedResults[indexPath.row].capitalized) (\(finalResult[breedResults[indexPath.row]]!.count) subbreeds)"
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if finalResult[breedResults[indexPath.row]]!.count != 0 {
            
            let vc = SublistViewController()
            vc.breed = breedResults[indexPath.row].capitalized
            vc.navigationItem.title = breedResults[indexPath.row].capitalized
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Breeds", style: .plain, target: self, action: #selector(popVC))
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let layout = UICollectionViewFlowLayout()
            let vc = ImageListViewController(collectionViewLayout: layout)
            vc.breed = breedResults[indexPath.row].capitalized
            vc.navigationItem.title = breedResults[indexPath.row].capitalized
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popVC))
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}
