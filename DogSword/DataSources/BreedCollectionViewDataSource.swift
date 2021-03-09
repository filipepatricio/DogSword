//
//  BreedCollectionViewDataSource.swift
//  DogSword
//
//  Created by Filipe Patricio on 09/03/2021.
//

import UIKit
import AlamofireImage

class BreedCollectionViewDataSource: NSObject, UICollectionViewDataSource{
  
  var breedList: [Breed] = []
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return breedList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreedCell", for: indexPath) as! BreedCollectionViewCell
    cell.breedNameLabel.text = breedList[indexPath.row].name
    cell.breedImageView.image = nil
    
    if let breedImage = breedList[indexPath.row].image,
       let breedImageUrlString = breedImage.url,
       let url = URL(string: breedImageUrlString){
      cell.breedImageView.af.setImage(withURL: url)
    }
    
    return cell
  }
  

}
