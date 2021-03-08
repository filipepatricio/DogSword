//
//  SearchViewController.swift
//  DogSword
//
//  Created by Filipe Patricio on 08/03/2021.
//

import UIKit

class SearchViewController: UIViewController {
  
  var searchTimer: Timer?
  
  let searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    
    searchController.searchBar.placeholder = "Search Breed"
    searchController.searchBar.searchBarStyle = .minimal
    searchController.definesPresentationContext = true
    
    return searchController
  }()
  
  var dogsDataProvider: DogsDataService?
  var breedList: [Breed]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.searchController.searchResultsUpdater = self
    self.navigationItem.searchController = searchController
    
    self.dogsDataProvider = DogsDataProvider()
    // Do any additional setup after loading the view.
  }
}

extension SearchViewController: UISearchResultsUpdating{
  func updateSearchResults(for searchController: UISearchController) {
    //Invalidate and Reinitialise
    self.searchTimer?.invalidate()
    
    guard let breedName = searchController.searchBar.text,
          breedName != "" else { return }
    
    print(breedName)
    
    
    
    searchTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] (timer) in
      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        //Use search text and perform the query
        guard let dogsDataProvider = self?.dogsDataProvider else{
          return
        }
        dogsDataProvider.breedSearch(byName: breedName).done{ breedList -> Void in
          self?.breedList = breedList
          print(breedList)
          //TODO: fill breed list into Collection View
          }.catch{ error in
            print(error)
        }
      }
    })
  }
}
