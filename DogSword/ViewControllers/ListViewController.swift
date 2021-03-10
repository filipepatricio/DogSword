//
//  ViewController.swift
//  DogSword

//
//  Created by Filipe Patricio on 08/03/2021.
//

import UIKit
import DisplaySwitcher

class ListViewController: UIViewController {
  @IBOutlet weak var viewLayoutButton: UIBarButtonItem!
  @IBOutlet weak var sortButton: UIBarButtonItem!
  @IBOutlet weak var breedCollectionView: UICollectionView!
  
  var dogsDataProvider: DogsDataService?
  var breedList: [Breed] = []
  
  var breedCollectionViewDataSource: BreedCollectionViewDataSource?
  
  let listLayoutStaticCellHeight: CGFloat = 100.0
  let gridLayoutStaticCellHeight: CGFloat = 150.0
  
  let BREED_LIMIT = 10
  var nextBreedPage = 0
  
  private lazy var listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .list)
  private lazy var gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .grid)
  private var layoutState: LayoutState = .list
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dogsDataProvider = DogsDataProvider()
    guard let dogsDataProvider = self.dogsDataProvider else{
      return
    }
    
    self.breedCollectionViewDataSource =  BreedCollectionViewDataSource(breedDataSourceType: .list, dogsDataProvider: dogsDataProvider)
    
    self.breedCollectionView.collectionViewLayout = self.listLayout
    self.breedCollectionView.dataSource = self.breedCollectionViewDataSource
    self.breedCollectionView.delegate = self
    
    self.breedCollectionView.register(UINib(nibName:"BreedCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "BreedCell")
    self.fetchBreeds(page: self.nextBreedPage)
  }
  
  func fetchBreeds(page: Int){
    guard let dogsDataProvider = self.dogsDataProvider,
          let breedCollectionViewDataSource = self.breedCollectionViewDataSource else{
      return
    }
    dogsDataProvider.breedList(page: nextBreedPage, limit: BREED_LIMIT).done{ newBreedList -> Void in
      self.breedList.append(contentsOf: newBreedList)
      breedCollectionViewDataSource.breedList = self.breedList
      self.breedCollectionView.reloadData()
      self.nextBreedPage += 1
    }.catch{ error in
      print(error)
    }
  }
  
  func listGridSwitch(){
    let animationDuration = 0.2
    let transitionManager: TransitionManager
    if layoutState == .list {
      layoutState = .grid
      transitionManager = TransitionManager(duration: animationDuration, collectionView: breedCollectionView!, destinationLayout: gridLayout, layoutState: layoutState)
    } else {
      layoutState = .list
      transitionManager = TransitionManager(duration: animationDuration, collectionView: breedCollectionView!, destinationLayout: listLayout, layoutState: layoutState)
    }
    transitionManager.startInteractiveTransition()
    viewLayoutButton.title = layoutState == .list ? "Grid" : "List"
  }
  @IBAction func viewLayoutButtonTap(_ sender: Any) {
    self.listGridSwitch()
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let segueIdentifier = segue.identifier else{
      print("Segue needs segueIdentifier")
      return
    }
    
    switch segueIdentifier{
    case SegueIdentifier.list.rawValue:
      let detailViewController = segue.destination as! DetailViewController
      detailViewController.breed = sender as? Breed
      detailViewController.dogsDataProvider = self.dogsDataProvider
    default:
      print("Unexpected segue")
    }
  }
  
}

extension ListViewController: UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
    let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    return customTransitionLayout
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    self.performSegue(withIdentifier: SegueIdentifier.list.rawValue, sender: self.breedList[indexPath.row])
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
        self.fetchBreeds(page: self.nextBreedPage)
      }
  }
}
