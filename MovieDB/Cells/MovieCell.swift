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
  @IBOutlet weak var titleView: UITextView!
  @IBOutlet weak var descriptionView: UITextView!
  @IBOutlet weak var posterView: UIImageView!
  // constraints
  var titleConstraint = NSLayoutConstraint()
  
  private var movie: Movies.List.ViewModel?
  
  func populate(with movie: Movies.List.ViewModel) {
    self.movie = movie
    self.titleView.text = movie.title
    self.descriptionView.text = movie.description
    updateTextViewConstraints()

    if movie.poster == nil {
      self.posterView.image = nil
      MoviesWorker().fetchPoster(for: movie, completion: populatePoster)
    } else {
      self.posterView.image = movie.poster!
    }
  }
  
  func populatePoster(_ poster: UIImage?) {
    DispatchQueue.main.async {
      self.posterView.image = poster
      self.movie?.poster = poster
    }
  }
  
  private func updateTextViewConstraints() {
    // remove old constraints
    titleView.removeConstraint(titleConstraint)

    // update title height constraint
    titleConstraint.constant = self.titleView.contentSize.height

    // re-add constraints
    titleView.addConstraint(titleConstraint)
  }
  
}
