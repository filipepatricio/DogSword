//
//  ListViewControllerTests.swift
//  DogSwordTests
//
//  Created by Filipe Patricio on 11/03/2021.
//

import XCTest
@testable import DogSword

class ListViewControllerTests: XCTestCase {
  
  func testFetchBreedsOnLoad() {
    let sut = makeSUT()
    RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    //It will fetchBreedsList on viewDidLoad
    XCTAssertEqual(sut.breedCollectionView.numberOfItems(inSection: 0), 5)
  }
  
  // MARK: - Helpers
  
  func makeSUT() -> ListViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let sut = storyboard.instantiateViewController(identifier: "ListViewController") as! ListViewController
    sut.dogsDataProvider = MockDogsDataProvider()
    sut.loadViewIfNeeded()
    return sut
  }
  
}
