//
//  SingleMovieInteractor.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 22/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol SingleMovieInteractor {
  func find(by id: Int?)
  var presenter: SingleMoviePresenter? { get set }
}

class SingleMovieInteractorImpl: SingleMovieInteractor {
  var presenter: SingleMoviePresenter?
  
  // MARK: setup
  
  var movieDAO = GenericDAOImpl<Movie>()
  var movieService: MovieService?

  func find(by id: Int?) {
    guard let `id` = id else {
      presenter?.present(nil)
      return
    }
    
    movieDAO.findByPrimaryKey(id, completion: { [weak self] (movie: Movie?) -> () in
      guard let `self` = self else { return }
      guard let `movie` = movie else {
        self.presenter?.present(nil)
        return
      }
      
      print("movie.trailerUrl :   \(String.init(describing: movie.trailerUrl)) ")
      
      let movieRef = ThreadSafeReference(to: movie)
      
      self.movieService?.fetchBackDrop(for: movie.backDropPath, completion: { [weak self] (_ poster: UIImage!) in
        guard let `self` = self else { return }
        guard let `movie` = self.movieDAO.resolve(movieRef) else {
          logger.warning("Lost movie reference!!")
          self.presenter?.present(nil)
          return
        }
        
        let viewModel = movie.asViewModel(poster: poster)
        self.presenter?.present(viewModel)
      })
    })

  }

}
