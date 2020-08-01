//
//  Router.swift
//  Dogs
//
//  Created by Никита on 22.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

//TODO: add alert 

import UIKit
import Alamofire

class ApiRouter: UIViewController {

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
                
                let vc = ListViewController()
                vc.apiAlert()
                
            }
            
        }
    }
    
    func requestImages(completion: @escaping([Image]?, Error?) -> Void) {
        
        let URL = "https://dog.ceo/api/breeds/image/random/10"
        
        AF.request(URL).responseJSON { response in
            switch response.result {
                
            case .success :
                let decoder = JSONDecoder()
                if let result = try?
                    decoder.decode(Image.self, from: response.data!) {
                    completion([result], nil)
                }
                
            case .failure(_):
                
                let layout = UICollectionViewFlowLayout()
                let vc = ImageListViewController(collectionViewLayout: layout)
                vc.apiAlert()
                
            }
        }
    }
    
}
