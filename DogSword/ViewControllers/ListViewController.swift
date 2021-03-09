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
  let breedCollectionViewDataSource = BreedCollectionViewDataSource()
  
  let listLayoutStaticCellHeight: CGFloat = 100.0
  let gridLayoutStaticCellHeight: CGFloat = 100.0
  
  private lazy var listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .list)

  private lazy var gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .grid)
  
  private var layoutState: LayoutState = .list

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dogsDataProvider = DogsDataProvider()
    
    guard let dogsDataProvider = self.dogsDataProvider else{
      return
    }
    
    self.breedCollectionView.collectionViewLayout = listLayout
    self.breedCollectionView.dataSource = self.breedCollectionViewDataSource
    self.breedCollectionView.delegate = self
    
    self.breedCollectionView.register(UINib(nibName:"BreedCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: "BreedCell")
    
    dogsDataProvider.breedList().done{ breedList -> Void in
      self.breedList = breedList
      print(breedList)
      self.breedCollectionViewDataSource.breedList = breedList
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
}

extension ListViewController: UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
      let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
      return customTransitionLayout
  }
}

