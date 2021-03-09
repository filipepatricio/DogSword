//
//  BreedCollectionViewCell.swift
//  DogSword
//
//  Created by Filipe Patricio on 09/03/2021.
//

import UIKit

class BreedCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var breedImageView: UIImageView!
  @IBOutlet weak var breedNameListLabel: UILabel!
  @IBOutlet weak var breedNameGridLabel: UILabel!
  @IBOutlet weak var breedGroupLabel: UILabel!
  @IBOutlet weak var breedOriginLabel: UILabel!
  
  var breedName: String? {
    didSet{
      breedNameListLabel.text = breedName
      breedNameGridLabel.text = breedName
    }
  }
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    breedGroupLabel.isHidden = true
    breedOriginLabel.isHidden = true
    }

}
