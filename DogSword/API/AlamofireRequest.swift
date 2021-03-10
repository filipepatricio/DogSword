//
//  AlamofireRequest.swift
//  DogSword
//
//  Created by Filipe Patricio on 10/03/2021.
//

import Foundation
import Alamofire

extension Alamofire.DataRequest {
  
  public static func dataResponseSerializer() -> Alamofire.DataResponseSerializer{
    return DataResponseSerializer{
      
    }
  }
}
