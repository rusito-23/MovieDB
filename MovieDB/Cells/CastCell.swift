//
//  CastCell.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

protocol CastCellDisplay {
  func displayProfile(_ profile: UIImage)
  func displayError(_ msg: String)
  var interactor: CastCellInteractor? { get set }
}

class CastCell: UITableViewCell {
  
  // MARK: Setup
  
  var interactor: CastCellInteractor?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  private func setup() {
    interactor = injector.resolve(CastCellInteractor.self, argument: self as CastCellDisplay)
  }
  
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
    self.characterLabel.text = "as \(cast.character ?? "guess!")"
    self.interactor?.loadProfile(for: cast)
  }

}


extension CastCell: CastCellDisplay {
  
  func displayProfile(_ profile: UIImage) {
    self.profileView.image = profile
  }
  
  func displayError(_ msg: String) {
    logger.error(msg)
  }

}


