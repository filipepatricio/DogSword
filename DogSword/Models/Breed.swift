//
//  Breed.swift
//  DogSword
//
//  Created by Filipe Patricio on 08/03/2021.
//

import Foundation


struct Breed: Codable{

  let breedGroup: String?
  let name: String?
  let origin: String?
  let temperament: String?
  
  enum CodingKeys: String, CodingKey {
    case breedGroup = "breed_group"
    case name = "name"
    case origin = "origin"
    case temperament = "temperament"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    breedGroup = try values.decodeIfPresent(String.self, forKey: .breedGroup)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    origin = try values.decodeIfPresent(String.self, forKey: .origin)
    temperament = try values.decodeIfPresent(String.self, forKey: .temperament)
  }
}
