//
//  CastCell.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class CastCell: UITableViewCell {
  
  // MARK: Outlets
  
  @IBOutlet weak private var profileView: UIImageView!
  @IBOutlet weak private var nameLabel: UILabel!
  @IBOutlet weak private var characterLabel: UILabel!
  
  // MARK: lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func populate(with cast: Casts.ViewModel) {
    self.nameLabel.text = cast.name
    self.characterLabel.text = cast.character
    // TODO: la imagen del chaboncito
  }

}
