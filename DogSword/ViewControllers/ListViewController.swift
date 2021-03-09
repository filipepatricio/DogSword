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
  var breedList: [Breed]?
  
  var breedCollectionViewDataSource: BreedCollectionViewDataSource?
  
  let listLayoutStaticCellHeight: CGFloat = 100.0
  let gridLayoutStaticCellHeight: CGFloat = 150.0
  
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
    self.fetchBreeds()
  }
  
  func fetchBreeds(){
    guard let dogsDataProvider = self.dogsDataProvider,
          let breedCollectionViewDataSource = self.breedCollectionViewDataSource else{
      return
    }
    dogsDataProvider.breedList().done{ breedList -> Void in
      self.breedList = breedList
      breedCollectionViewDataSource.breedList = breedList
      self.breedCollectionView.reloadData()
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
    viewLayoutButton.title = layoutState == .list ? "List" : "Grid"
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
    guard let breedList = self.breedList else{
      return
    }
    self.performSegue(withIdentifier: SegueIdentifier.list.rawValue, sender: breedList[indexPath.row])
  }
}
