//
//  DogsDataService.swift
//  DogSword
//
//  Created by Filipe Patricio on 08/03/2021.
//

import Foundation
import Alamofire
import PromiseKit

protocol DogsDataService{
  func breedList() -> Promise<[Breed]>
  func breedSearch(byName breedName:String) -> Promise<[Breed]>
//  func breedDetail() -> Promise<Breed>
}

struct DogsDataProvider:DogsDataService{
  let baseUrl: String!
  let apiVersion: String!
  let headers: HTTPHeaders!
  
  init(){
    self.baseUrl = "https://api.thedogapi.com"
    self.apiVersion = "/v1"
    self.headers = [
      "x-api-key": "4b924d57-09a9-4de1-80a4-7da2be388c55",
    ]
  }
  
  func breedList()->Promise<[Breed]>{
    return Promise<[Breed]> { seal in
      _ = AF.request(self.baseUrl + self.apiVersion + "/breeds",
                     method: .get,
                     headers: headers)
        .responseData { response in
          switch (response.result) {
          case .success(let value):
            let breedList = try! JSONDecoder().decode([Breed].self, from: value)
            seal.fulfill(breedList)
          case .failure(let error):
            print (error)
            seal.reject(error)
          }
        }
    }
  }
  
  func breedSearch(byName breedName:String) -> Promise<[Breed]>{
    return Promise<[Breed]> { seal in
      _ = AF.request(self.baseUrl + self.apiVersion + "/breeds/search",
                     method: .get,
                     parameters: ["q":breedName],
                     headers: headers)
        .responseData { response in
          switch (response.result) {
          case .success(let value):
            let breedList = try! JSONDecoder().decode([Breed].self, from: value)
            seal.fulfill(breedList)
          case .failure(let error):
            print (error)
            seal.reject(error)
          }
        }
    }
  }
  
//  func breedDetail() -> Promise<Breed>{
//    //TODO:
//  }
}
