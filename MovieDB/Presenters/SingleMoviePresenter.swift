//
//  SingleMoviePresenter.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 22/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

protocol SingleMoviePresentation {
  func present(_ movie: Movies.ViewModel?)
}

class SingleMoviePresenter: SingleMoviePresentation {
  weak var viewController: SingleMovieDisplay?
  
  func present(_ movie: Movies.ViewModel?) {
    DispatchQueue.main.async {
      guard let `movie` = movie else {
        self.viewController?.displayError("Ocurrió un error al recuperar la pelicula")
        return
      }
      
      self.viewController?.displayMovie(movie)
    }
  }
  
}
