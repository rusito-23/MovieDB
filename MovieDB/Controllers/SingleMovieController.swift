//
//  SingleMovieController.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 19/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

class SingleMovieViewController: UIViewController {
  
  //  MARK: self variables
  var movie: Movies.List.ViewModel?
  
  // MARK: Outlets
  @IBOutlet weak var titleView: UITextView!
  @IBOutlet weak var descriptionView: UITextView!
  @IBOutlet weak var posterView: UIImageView!
  @IBOutlet weak var descriptionViewHeightConstraint: NSLayoutConstraint!
  
  // MARK: view lifecycle
  override func viewDidLoad() {
    self.populate(movie)
  }
  
  func populate(_ movie: Movies.List.ViewModel?) {
    guard let `movie` = movie else {
      _ = navigationController?.popViewController(animated: true)
      return
    }
    
    titleView.text = movie.title
    descriptionView.text = movie.description
    descriptionViewHeightConstraint.constant = self.descriptionView.contentSize.height
    if let poster = movie.poster {
      posterView.image = poster
    } else {
      MoviesWorker().fetchPoster(for: movie, completion: populatePoster)
    }
  }
  
  func populatePoster(_ poster: UIImage?) {
    DispatchQueue.main.async { [weak self] in
      if let `self` = self {
        self.movie?.poster = poster
        self.posterView.image = poster
      }
    }
  }
  
}
