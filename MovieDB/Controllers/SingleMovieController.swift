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

  // MARK: view lifecycle
  override func viewDidLoad() {
    posterView.contentMode = .scaleAspectFit
    self.populate(movie)
  }
  
  private func populate(_ movie: Movies.List.ViewModel?) {
    guard let `movie` = movie else {
      _ = navigationController?.popViewController(animated: true)
      return
    }
    
    titleView.text = movie.title
    descriptionView.text = movie.description

    if let poster = movie.poster {
      posterView.image = poster
    } else {
      MoviesWorker().fetchPoster(for: movie, completion: populatePoster)
    }
  }
  
  private func populatePoster(_ poster: UIImage?) {
    DispatchQueue.main.async { [weak self] in
      if let `self` = self {
        self.movie?.poster = poster
        self.posterView.image = poster
      }
    }
  }
  
}
