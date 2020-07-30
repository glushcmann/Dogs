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
                
            case .failure(let error): 
                
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
                
            case .failure(let error):
            
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
        }
    }
    
}
