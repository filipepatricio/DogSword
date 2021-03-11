//
//  MockDogsDataService.swift
//  DogSwordTests
//
//  Created by Filipe Patricio on 11/03/2021.
//

import Foundation
import PromiseKit
@testable import DogSword



class MockDogsDataProvider: DogsDataService{
  func breedList(page: Int?, limit: Int?) -> Promise<[Breed]> {
    let decoder = JSONDecoder()
    let data = self.readJsonFile(fileName: "breed_list") as! Data
    let breedList = try! decoder.decode([Breed].self, from: data)
    return Promise<[Breed]>{seal in seal.fulfill(breedList)}
  }
  
  func breedSearch(byName breedName: String) -> Promise<[Breed]> {
    let decoder = JSONDecoder()
    let data = self.readJsonFile(fileName: "breed_list") as! Data
    let breedList = try! decoder.decode([Breed].self, from: data)
    return Promise<[Breed]>{seal in seal.fulfill(breedList)}
  }
  
  func breedImage(byId imageId: String) -> Promise<BreedImage> {
    //TODO:
    return Promise<BreedImage>{seal in seal.fulfill(BreedImage())}
  }
}

extension MockDogsDataProvider{
  func readJsonFile(fileName: String)->Any?{
    guard
      let url = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json"),
         let data = try? Data(contentsOf: url)
    else {
         return nil
    }

    return data
  }
}
