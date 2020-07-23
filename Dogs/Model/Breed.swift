//
//  Breed.swift
//  Dogs
//
//  Created by Никита on 21.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import Foundation

struct Breed : Codable {
    let status: String
    let message: [String: [String]]
}

struct Image: Codable {
    let status: String
    let message: [String]
}
