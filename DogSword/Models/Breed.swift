//
//  Breed.swift
//  DogSword
//
//  Created by Filipe Patricio on 08/03/2021.
//

import Foundation


struct Breed: Codable{

  var name: String?
  var breedGroup: String?
  var origin: String?
  var temperament: String?
  var imageInfo: BreedImage?
  var imageId: String?
  
  enum CodingKeys: String, CodingKey {
    case breedGroup = "breed_group"
    case name = "name"
    case origin = "origin"
    case temperament = "temperament"
    case imageInfo = "image"
    case imageId = "reference_image_id"
  }
  
  init(){}
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    breedGroup = try values.decodeIfPresent(String.self, forKey: .breedGroup)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    origin = try values.decodeIfPresent(String.self, forKey: .origin)
    temperament = try values.decodeIfPresent(String.self, forKey: .temperament)
    imageInfo = try values.decodeIfPresent(BreedImage.self, forKey: .imageInfo)
    imageId = try values.decodeIfPresent(String.self, forKey: .imageId)
  }
}
