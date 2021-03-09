//
//  DetailViewController.swift
//  DogSword
//
//  Created by Filipe Patricio on 08/03/2021.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var breedImageView: UIImageView!
  @IBOutlet weak var breedNameLabel: UILabel!
  @IBOutlet weak var breedCategoryLabel: UILabel!
  @IBOutlet weak var breedOriginLabel: UILabel!
  @IBOutlet weak var breedTemperamentLabel: UILabel!
  
  var dogsDataProvider: DogsDataService?
  var breed: Breed?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let dogsDataProvider = self.dogsDataProvider,
      let breed = self.breed else{
      return
    }
    
    self.breedNameLabel.text = "Name: \(breed.name ?? "Undefined")"
    self.breedOriginLabel.text = "Original: \(breed.origin ?? "Undefined")"
    self.breedCategoryLabel.text = "Group: \(breed.breedGroup ?? "Undefined")"
    self.breedTemperamentLabel.text = "Temperament: \(breed.temperament ?? "Undefined")"
    
    if let breedImage = breed.imageInfo,
       let breedImageUrlString = breedImage.url,
       let imageUrl = URL(string: breedImageUrlString){
        self.breedImageView.af.setImage(withURL: imageUrl)
    }else if let breedImageId = breed.imageId{
      dogsDataProvider.breedImage(byId: breedImageId).done{ imageInfo in
        if let breedImageUrlString = imageInfo.url,
           let imageUrl = URL(string: breedImageUrlString){
          self.breedImageView.af.setImage(withURL: imageUrl)
        }
      }.catch{ error in
        print(error)
      }
    }
    
  }
}
