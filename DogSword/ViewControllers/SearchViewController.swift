//
//  SearchViewController.swift
//  DogSword
//
//  Created by Filipe Patricio on 08/03/2021.
//

import UIKit

class SearchViewController: UIViewController {
  
  @IBOutlet weak var breedCollectionView: UICollectionView!
  
  var breedCollectionViewDataSource: BreedCollectionViewDataSource?
  
  var searchTimer: Timer?
  let searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    
    searchController.searchBar.placeholder = "Search Breed"
    searchController.searchBar.searchBarStyle = .default
    searchController.definesPresentationContext = false
    
    return searchController
  }()
  
  var dogsDataProvider: DogsDataService?
  var breedList: [Breed]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dogsDataProvider = DogsDataProvider()
    guard let dogsDataProvider = self.dogsDataProvider else{
      return
    }
    
    self.searchController.searchResultsUpdater = self
    self.searchController.obscuresBackgroundDuringPresentation = false
    
    self.navigationItem.searchController = searchController
    
    self.breedCollectionViewDataSource =  BreedCollectionViewDataSource(breedDataSourceType: .search, dogsDataProvider: dogsDataProvider)
    self.breedCollectionView.dataSource = self.breedCollectionViewDataSource
    self.breedCollectionView.delegate = self
    
    self.breedCollectionView.register(UINib(nibName:"BreedCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "BreedCell")
  }
}

extension SearchViewController: UISearchResultsUpdating{
  func updateSearchResults(for searchController: UISearchController) {
    //Invalidate and Reinitialise
    self.searchTimer?.invalidate()
    
    guard let breedName = searchController.searchBar.text,
          breedName != "" else { return }
    
    searchTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] (timer) in
      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        self?.searchBreed(byName: breedName)
      }
    })
  }
  
  func searchBreed(byName breedName:String){
    //Use search text and perform the query
    guard let dogsDataProvider = self.dogsDataProvider,
          let breedCollectionViewDataSource = self.breedCollectionViewDataSource else{
      return
    }
    dogsDataProvider.breedSearch(byName: breedName).done{ breedList -> Void in
      self.breedList = breedList
      breedCollectionViewDataSource.breedList = breedList
      self.breedCollectionView.reloadData()
    }.catch{ error in
      print(error)
    }
  }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize{
    return CGSize(width: collectionView.bounds.width, height: 100)
  }
}
