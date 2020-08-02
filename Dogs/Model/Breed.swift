//
//  Breed.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import Foundation
import RealmSwift

struct Breed : Codable {
    let status: String
    let message: [String: [String]]
}

struct Image: Codable {
    let status: String
    let message: [String]
}

class Dog: Object {
    @objc dynamic var breed: String? = nil
    @objc dynamic var image: String? = nil
    @objc dynamic var hasFavourited: Bool = false
}
