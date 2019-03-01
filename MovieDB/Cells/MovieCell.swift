//
//  MovieCell.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 19/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit



class MovieCell: UITableViewCell {
  
  // MARK: Outlets
  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var descriptionView: UITextView!
  @IBOutlet weak var posterView: UIImageView!
  
  //  MARK: SETUP
  var interactor: MovieCellInteractor?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  private func setup() {
    interactor = MovieCellInteractor()
    let presenter = MovieCellPresenter()
    interactor?.presenter = presenter
    presenter.viewController = self
  }

  //  MARK: populate logic

  func populate(with movie: Movies.ViewModel) {
    self.selectionStyle = .none
    
    self.titleView.text = movie.title
    self.descriptionView.text = movie.overview

    // show three dots on truncated text
    self.descriptionView.textContainer.lineBreakMode = .byTruncatingTail
    
    // load poster
    if let poster = movie.poster {
      self.posterView.image = poster
    } else {
      interactor?.loadPoster(for: movie)
    }
    
  }
  
  func populatePoster(poster: UIImage?) {
    self.posterView.image = poster
  }
  

}
