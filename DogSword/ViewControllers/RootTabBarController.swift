//
//  RootTabBarController.swift
//  DogSword
//
//  Created by Filipe Patricio on 12/03/2021.
//

import UIKit

class RootTabBarController: UITabBarController {
  
  var dogsDataProvider: DogsDataService?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    guard let dogsDataProvider = self.dogsDataProvider else{
      return
    }
    
    self.children.forEach{ child in
      guard let navigationController = child as? UINavigationController,
            var dogsDataProviderVC = navigationController.viewControllers.first as? DogsDataServiceProtocol else{
        return
      }
      
      dogsDataProviderVC.dogsDataProvider = dogsDataProvider
      
    }
  }
  
}
