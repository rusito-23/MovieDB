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
  
  @IBOutlet weak var titleView: UITextView!
  @IBOutlet weak var descriptionView: UITextView!
  @IBOutlet weak var posterView: UIImageView!
  
  func populate(with movie: Movies.List.ViewModel) {
    self.titleView.text = movie.title
    self.descriptionView.text = movie.description
    self.posterView.image = nil
    
    MoviesWorker().fetchPoster(for: movie, completion: populatePoster)
  }
  
  func populatePoster(_ poster: UIImage?) {
    DispatchQueue.main.async {
      self.posterView.image = poster
    }
  }
  
}
