//
//  GenreCellTableViewCell.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 13/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class GenreCell: UITableViewCell {
  
  // MARK: Outlets
  
  @IBOutlet weak private var name: UILabel!
  
  // MARK: Setup

  override func setSelected(_ selected: Bool, animated: Bool) {
    if (selected) {
      self.name.textColor = .yellow
    } else {
      self.name.textColor = .white
    }
    self.backgroundColor = .clear
  }

  func populate(_ genre: GenreTO) {
    self.name.text = genre.name
  }
  
}
