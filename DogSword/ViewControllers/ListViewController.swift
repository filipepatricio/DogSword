//
//  ViewController.swift
//  DogSword

//
//  Created by Filipe Patricio on 08/03/2021.
//

import UIKit

class ListViewController: UIViewController {
  var dogsDataProvider: DogsDataService?
  var breedList: [Breed]?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.dogsDataProvider = DogsDataProvider()
    
    guard let dogsDataProvider = self.dogsDataProvider else{
      return
    }
    
    dogsDataProvider.breedList().done{ breedList -> Void in
      self.breedList = breedList
      print(breedList)
      //TODO: fill breed list into Collection View
      }.catch{ error in
        print(error)
    }
  }


}

