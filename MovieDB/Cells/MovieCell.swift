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

  func populate(with movie: Movies.List.ViewModel) {
    self.titleView.text = movie.title
    self.descriptionView.text = movie.description
    self.posterView.image = nil
    
    // show three dots on truncated text
    self.descriptionView.textContainer.lineBreakMode = .byTruncatingTail
    self.titleView.textContainer.lineBreakMode = .byTruncatingTail

    if movie.poster == nil {
      MoviesWorker().fetchPoster(for: movie, completion: populatePoster)
    } else {
      self.posterView.image = movie.poster!
    }
  }
  
  func populatePoster(_ poster: UIImage?, _ movie: Movies.List.ViewModel) {
    DispatchQueue.main.async {
      self.posterView.image = poster
      movie.poster = poster
    }
  }
  
}
