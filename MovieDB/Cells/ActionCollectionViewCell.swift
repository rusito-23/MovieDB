//
//  ActionCollectionViewCell.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class Action {
  var name: String?
  var icon: UIImage?
  var action: () -> ()
  
  init(name: String, icon: String, action: @escaping () -> ()) {
    self.name = name
    self.icon = UIImage(named: icon)
    self.action = action
  }
}

class ActionCollectionViewCell: UICollectionViewCell {
  
  // MARK: Outlets and lifecycle
  
  @IBOutlet weak private var actionNameLabel: UILabel!
  @IBOutlet weak private var actionIconView: UIImageView!
  
  func populate(_ action: Action) {
    self.actionNameLabel.text = action.name
    self.actionIconView.image = action.icon
  }

}
