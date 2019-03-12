//
//  SingleMoviePresenter.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 22/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

protocol SingleMoviePresenter {
  func present(_ movie: Movies.ViewModel?)
  func presentTrailer(_ id: String?)
  var viewController: SingleMovieDisplay? { get set }
}

class SingleMoviePresenterImpl: SingleMoviePresenter {
  weak var viewController: SingleMovieDisplay?
  
  func present(_ movie: Movies.ViewModel?) {
    DispatchQueue.main.async {
      
      guard let `movie` = movie else {
        self.viewController?.displayError("An error ocurred while loading the movie")
        return
      }
      
      self.viewController?.displayMovie(movie)
    }
  }
  
  func presentTrailer(_ id: String?) {
    DispatchQueue.main.async {
      if let `id` = id {
        self.viewController?.displayTrailer(id)
      } else {
        self.viewController?.displayTrailerError("An error ocurred while loading the trailer")
      }
    }
  }
  
}
