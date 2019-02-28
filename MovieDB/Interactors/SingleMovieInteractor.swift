//
//  SingleMovieInteractor.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 22/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

protocol SingleMovieBusiness {
  func find(by id: Int?)
}

class SingleMovieInteractor: SingleMovieBusiness {
  var presenter: SingleMoviePresentation?
  var movieDAO = GenericDAOImpl<Movie>()
  var movieService = MovieService()

  func find(by id: Int?) {
    guard let `id` = id,
          let movie = movieDAO.findByPrimaryKey(id) else {
      presenter?.present(nil)
      return
    }
    
    movieService.fetchBackDrop(for: movie, completion: { [weak self] (_ poster: UIImage!) in
      guard let `self` = self else { return }

      let viewModel = movie.asViewModel(with: poster)
      self.presenter?.present(viewModel)
    })
    
  }

}
