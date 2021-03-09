//
//  BreedCollectionViewDataSource.swift
//  DogSword
//
//  Created by Filipe Patricio on 09/03/2021.
//

import UIKit
import AlamofireImage

enum BreedDataSourceType{
  case list
  case search
}

class BreedCollectionViewDataSource: NSObject, UICollectionViewDataSource{
  
  var breedList: [Breed] = []
  var breedDataSourceType: BreedDataSourceType
  var dogsDataProvider: DogsDataService
  
  init(breedDataSourceType: BreedDataSourceType, dogsDataProvider: DogsDataService){
    self.breedDataSourceType = breedDataSourceType
    self.dogsDataProvider = dogsDataProvider
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return breedList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreedCell", for: indexPath) as! BreedCollectionViewCell
    
    
    cell.breedGroupLabel.isHidden = breedDataSourceType == .list
    cell.breedOriginLabel.isHidden = breedDataSourceType == .list
    
    // Reset cell image on reusing cells
    cell.breedImageView.image = UIImage(named: "dog")
    
    // Set new values
    cell.breedName = breedList[indexPath.row].name
    cell.breedOriginLabel.text = "Origin: \(breedList[indexPath.row].origin ?? "Undefined")"
    cell.breedGroupLabel.text = "Group: \(breedList[indexPath.row].breedGroup ?? "Undefined")"
    
    if let breedImage = breedList[indexPath.row].imageInfo,
       let breedImageUrlString = breedImage.url,
       let imageUrl = URL(string: breedImageUrlString){
        cell.breedImageView.af.setImage(withURL: imageUrl)
    }else if let breedImageId = breedList[indexPath.row].imageId{
      self.dogsDataProvider.breedImage(byId: breedImageId).done{ imageInfo in
        if let breedImageUrlString = imageInfo.url,
           let imageUrl = URL(string: breedImageUrlString){
          cell.breedImageView.af.setImage(withURL: imageUrl)
        }
      }.catch{ error in
        print(error)
      }
    }
    
    return cell
  }
}
