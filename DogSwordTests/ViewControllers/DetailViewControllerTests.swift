//
//  DetailViewControllerTest.swift
//  DogSwordTests
//
//  Created by Filipe Patricio on 11/03/2021.
//

import XCTest
@testable import DogSword

class DetailViewControllerTests: XCTestCase {
  
  func testRender() {
    var breed = Breed()
    breed.name = "NAME"
    breed.origin = "ORIGIN"
    breed.breedGroup = "GROUP"
    breed.temperament = "TEMPERAMENT"
    
    let sut = makeSUT()
    
    sut.fillBreedInfo(breed, MockDogsDataProvider())
    
    XCTAssertEqual(sut.breedNameLabel.text!, "Name: NAME")
    XCTAssertEqual(sut.breedOriginLabel.text!, "Origin: ORIGIN")
    XCTAssertEqual(sut.breedCategoryLabel.text!, "Group: GROUP")
    XCTAssertEqual(sut.breedTemperamentLabel.text!, "Temperament: TEMPERAMENT")
  }
  
  // MARK: - Helpers
  
  func makeSUT() -> DetailViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let sut = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
    sut.loadViewIfNeeded()
    return sut
  }
  
}
