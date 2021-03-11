//
//  APIRouter.swift
//  DogSword
//
//  Created by Filipe Patricio on 11/03/2021.
//

import Foundation
import Alamofire

enum APIRouter {
  case breedList(parameters:Parameters)
  case breedSearch(parameters:Parameters)
  case breedImage(imageId:String)
  
  var baseURL: String {
    switch self {
    case .breedList,
         .breedSearch,
         .breedImage:
      return "https://api.thedogapi.com"
    }
  }
  
  var apiVersion: String {
    switch self {
    case .breedList,
         .breedSearch,
         .breedImage:
      return "/v1"
    }
  }
  
  var path: String {
    switch self {
    case .breedList:
      return "/breeds"
    case .breedSearch:
      return "/breeds/search"
    case .breedImage(let imageId):
      return "/images/\(imageId)"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .breedList:
      return .get
    case .breedSearch:
      return .get
    case .breedImage:
      return .get
    }
  }
  
  var parameters: Parameters {
    switch self {
    case .breedList(let parameters):
      return parameters
    case .breedSearch(let parameters):
      return parameters
    case .breedImage:
      return [:]
    }
  }
}

// MARK: - URLRequestConvertible
extension APIRouter: URLRequestConvertible {
  func asURLRequest() throws -> URLRequest {
    let url = try (baseURL+apiVersion).asURL().appendingPathComponent(path)
    var request = URLRequest(url: url)
    let headers: HTTPHeaders = [
      "x-api-key": "4b924d57-09a9-4de1-80a4-7da2be388c55",
    ]
    request.method = method
    request.headers = headers
    if (method == .get) {
      let encoding = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
      return try encoding.encode(request, with: parameters)
    } else {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      return request
    }
  }
}
