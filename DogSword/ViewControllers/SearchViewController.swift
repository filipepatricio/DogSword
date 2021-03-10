//
//  SearchViewController.swift
//  DogSword
//
//  Created by Filipe Patricio on 08/03/2021.
//

import UIKit
import Toaster

class SearchViewController: UIViewController {
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
          breedName != "" else {
      self.activityIndicator.stopAnimating()
      return
    }
    self.activityIndicator.startAnimating()
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
      print(error.localizedDescription)
      Toast(text: error.localizedDescription).show()
    }.finally {
      self.activityIndicator.stopAnimating()
    }
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let segueIdentifier = segue.identifier else{
      print("Segue needs segueIdentifier")
      return
    }
    
    switch segueIdentifier{
    case SegueIdentifier.search.rawValue:
      let detailViewController = segue.destination as! DetailViewController
      detailViewController.breed = sender as? Breed
      detailViewController.dogsDataProvider = self.dogsDataProvider
    default:
      print("Unexpected segue")
    }
  }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize{
    return CGSize(width: collectionView.bounds.width, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    guard let breedList = self.breedList else{
      return
    }
    self.performSegue(withIdentifier: SegueIdentifier.search.rawValue, sender: breedList[indexPath.row])
  }
  
}
