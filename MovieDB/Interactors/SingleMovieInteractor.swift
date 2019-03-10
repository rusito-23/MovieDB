//
//  SingleMovieInteractor.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 22/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit
import XCDYouTubeKit
import RealmDAO

protocol SingleMovieInteractor {
  func find(by id: Int?)
  func fetchTrailer(id: Int?)
  var presenter: SingleMoviePresenter? { get set }
}

class SingleMovieInteractorImpl: SingleMovieInteractor {
  var presenter: SingleMoviePresenter?
  
  // MARK: setup
  
  var movieDAO = GenericDAO<Movie>()
  var movieService: MovieService?

  func find(by id: Int?) {
    guard let `id` = id else {
      presenter?.present(nil)
      return
    }
    
    movieDAO.findByPrimaryKey(id, completion: { [weak self] (movie: MovieStruct?) -> () in
      guard let `self` = self else { return }
      guard let `movie` = movie else {
        self.presenter?.present(nil)
        return
      }
      
      self.movieService?.fetchBackDrop(for: movie.backDropPath, completion: { [weak self] (_ poster: UIImage!) in
        guard let `self` = self else { return }

        let viewModel = movie.asViewModel(poster: poster)
        self.presenter?.present(viewModel)
      })
    })

  }
  
  
  func fetchTrailer(id: Int?) {
    self.movieDAO.findByPrimaryKey(id as Any, completion: { [weak self] (movie: MovieStruct?) -> () in
      guard let `self` = self else { return }
      
      guard let trailerUrl = movie?.trailerUrl else {
        self.presenter?.presentTrailer(nil)
        return
      }
      
      XCDYouTubeClient.default().getVideoWithIdentifier(trailerUrl, cookies: nil, completionHandler: { (video, error) -> () in
        
        if (video != nil) {
          logger.info("video available!")
          self.presenter?.presentTrailer(trailerUrl)
        } else {
          logger.error("no video!: \(String(describing: error))")
          self.presenter?.presentTrailer(nil)
        }
        
      })
    })
  }
  
}
