//
//  MovieCell.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 19/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

protocol MovieCellDisplay {
  func populatePoster(poster: UIImage?)
  func posterError()
}

class MovieCell: UITableViewCell {
  
  var interactor: MovieCellInteractor?
  
  // MARK: Outlets
  
  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var descriptionView: UITextView!
  @IBOutlet weak var posterView: UIImageView!
  @IBOutlet weak var posterContainer: UIView!
  
  //  MARK: SETUP
  
  var loadingView = LoadingView(type: .poster)

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  private func setup() {
    interactor = injector.resolve(MovieCellInteractor.self, argument: self as MovieCellDisplay)
  }

  //  MARK: populate logic

  func populate(with movie: Movies.ViewModel) {
    self.selectionStyle = .none
    
    self.titleView.text = movie.title
    self.descriptionView.text = movie.overview

    // show three dots on truncated text
    self.descriptionView.textContainer.lineBreakMode = .byTruncatingTail
    
    // load poster
    loadingPoster(true)
    interactor?.loadPoster(for: movie)
  }
  
  func cancelPoster() {
    self.interactor?.cancelOldPoster()
    self.posterView.image = nil
  }
  
  // loading indicator handler
  private func loadingPoster(_ run: Bool) {
    if run {
      cancelPoster()
      loadingView.setupWithSuperView(self.posterContainer)
    } else {
      loadingView.removeFromSuperview()
    }
  }
  
  // prevent cell from loading the wrong image by canceling old request
  override func prepareForReuse() {
    super.prepareForReuse()
    loadingPoster(true)
  }
  

}


extension MovieCell: MovieCellDisplay {
  
  func populatePoster(poster: UIImage?) {
    loadingPoster(false)
    self.posterView.image = poster
  }
  
  func posterError() {
    loadingPoster(false)
    self.posterView.image = UIImage.init(named: "no_image")
  }

}
