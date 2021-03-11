//
//  SearchViewControllerTests.swift
//  DogSwordTests
//
//  Created by Filipe Patricio on 11/03/2021.
//

import XCTest
@testable import DogSword

class SearchViewControllerTests: XCTestCase {
    
    func testSearchBreed() {
      let sut = makeSUT()
      sut.searchBreed(byName: "test")
      RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
      XCTAssertEqual(sut.breedCollectionView.numberOfItems(inSection: 0), 5)
    }
    
    // MARK: - Helpers
    
    func makeSUT() -> SearchViewController {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let sut = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
      sut.dogsDataProvider = MockDogsDataProvider()
      sut.loadViewIfNeeded()
      return sut
    }
    
  }
