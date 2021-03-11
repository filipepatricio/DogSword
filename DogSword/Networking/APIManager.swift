//
//  APIManager.swift
//  DogSword
//
//  Created by Filipe Patricio on 10/03/2021.
//

import Foundation
import Alamofire

class APIManager {
  static let shared = APIManager()

  let sessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    let responseCacher = ResponseCacher(behavior: .modify { _, response in
      let userInfo = ["date": Date()]
      return CachedURLResponse(
        response: response.response,
        data: response.data,
        userInfo: userInfo,
        storagePolicy: .allowed)
    })

    return Session(
      configuration: configuration,
      cachedResponseHandler: responseCacher)
  }()
}
