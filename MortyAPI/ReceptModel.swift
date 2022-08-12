//
//  ReceptModel.swift
//  MortyAPI
//
//  Created by Егор Филиппов on 30.05.2022.
//

import Foundation

struct ReceptModel: Decodable {
    let recipes: [Recipe]
}


struct Recipe: Decodable {
    let uuid: String
    let name: String
    let images: [String]
    let lastUpdated: Int
    let recipeDescription: String?
    let instructions: String
    let difficulty: Int
    
    enum CodingKeys: String, CodingKey {
        case uuid, name, images, lastUpdated
        case recipeDescription = "description"
        case instructions, difficulty
    }
}

extension Recipe: Hashable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
