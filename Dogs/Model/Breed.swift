//
//  Breed.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import Foundation
//import RealmSwift

struct Breed : Codable {
    let status: String
    let message: [String: [String]]
}

struct Image: Codable {
    let status: String
    let message: [String]
}

//class Favourite: Object {
//    var breed = List<Dogs>()
//}
//
//class Dogs: Object {
//    
//    @objc dynamic var dog: String = ""
//    @objc dynamic var images: [String]!
//    
//}

struct Favourite {
    var dogs: [Dog]
}

struct Dog {
    let breed: String
    let image: String
    var hasFavourited: Bool
}
