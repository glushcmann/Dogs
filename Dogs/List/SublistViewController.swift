//
//  SublistViewController.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit
import Alamofire

class SublistViewController: UITableViewController {
    
    private let cellID = "cellID"
    
    var breed: String = ""
    var dogBreed: [Breed]!
    var subBreedResults: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        
        requestFromApi()
        
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
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
            
            self.breed = self.breed.lowercased()
            let subBreedArray = self.dogBreed[0].message[self.breed]
            
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
        
        let layout = UICollectionViewFlowLayout()
        let vc = ImageListViewController(collectionViewLayout: layout)
        vc.breed = subBreedResults[indexPath.row].capitalized
        vc.navigationItem.title = subBreedResults[indexPath.row].capitalized
        self.navigationController?.pushViewController(vc, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popVC))
        
    }
}
