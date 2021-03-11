//
//  Image.swift
//  DogSword
//
//  Created by Filipe Patricio on 09/03/2021.
//

import Foundation

struct BreedImage: Codable{
  
  var url: String?
  
  enum CodingKeys: String, CodingKey {
    case url = "url"
  }
  init() {}
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    url = try values.decodeIfPresent(String.self, forKey: .url)
  }
}
