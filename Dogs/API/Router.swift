//
//  Router.swift
//  Dogs
//
//  Created by Никита on 22.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

//TODO: add alert 

import Foundation
import Alamofire

class ApiRouter {

    func requestBreeds(completion: @escaping([Breed]?, Error?) -> Void) {
        
        let URL = "https://dog.ceo/api/breeds/list/all"
        
        AF.request(URL).responseJSON { response in
            let decoder = JSONDecoder()
            if let result = try?
                decoder.decode(Breed.self, from: response.data!) {
                completion([result], nil)
            } else {
                print("Unable to decode data")
            }
        }
    }
    
    func requestSubBreeds(completion: @escaping([Breed]?, Error?) -> Void) {
        
        let URL = "https://dog.ceo/api/breed/hound/list"
        
        AF.request(URL).responseJSON { response in
            let decoder = JSONDecoder()
            if let result = try?
                decoder.decode(Breed.self, from: response.data!) {
                completion([result], nil)
            } else {
                print("Unable to decode data")
            }
        }
    }
    
    func requestImages(completion: @escaping([Image]?, Error?) -> Void) {
        
        let URL = "https://dog.ceo/api/breeds/image/random/10"
        
        AF.request(URL).responseJSON { response in
            let decoder = JSONDecoder()
            if let result = try?
                decoder.decode(Image.self, from: response.data!) {
                completion([result], nil)
            } else {
                print("Unable to decode data")
            }
        }
    }
    
}
