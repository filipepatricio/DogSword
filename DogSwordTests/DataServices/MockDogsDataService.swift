//
//  MockDogsDataService.swift
//  DogSwordTests
//
//  Created by Filipe Patricio on 11/03/2021.
//

import Foundation
import PromiseKit
@testable import DogSword

struct MockDogsDataProvider: DogsDataService{
  func breedList(page: Int?, limit: Int?) -> Promise<[Breed]> {
    //TODO:
    return Promise<[Breed]>{seal in seal.fulfill([])}
  }
  
  func breedSearch(byName breedName: String) -> Promise<[Breed]> {
    //TODO:
    return Promise<[Breed]>{seal in seal.fulfill([])}
  }
  
  func breedImage(byId imageId: String) -> Promise<BreedImage> {
    //TODO:
    return Promise<BreedImage>{seal in seal.fulfill(BreedImage())}
  }
  
  
}
