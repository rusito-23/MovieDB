//
//  CastInteractor.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import RealmDAO

protocol CastInteractor {
  func findAll(for movieID: Int?)
  var presenter: CastPresenter? { get set }
  var movieService: MovieService? { get set }
}

class CastInteractorImpl: CastInteractor {
  
  var presenter: CastPresenter?
  var movieService: MovieService?
  var movieDAO = GenericDAO<Movie>()
  var castDAO = GenericDAO<Cast>()
  
  // MARK: protocol implementation
  
  func findAll(for movieID: Int?) {
    guard let `movieID` = movieID else {
      logger.error("No movieID found for CastInteractor!")
      presenter?.present(nil)
      return
    }
    
    movieDAO.findByPrimaryKey(movieID, completion: { [weak self] (_ movie: MovieStruct?) in
      guard let `self` = self else { return }
      guard let `movie` = movie else {
        logger.error("No movie found for CastInteractor!")
        self.presenter?.present(nil)
        return
      }
      
      // first check if cast is in db
      var cast = movie.cast
      if cast.isEmpty {
        
        // if no casts where found in db
        self.movieService?.findCast(for: movie.id, completion: { [weak self] (_ res: Casts.Response?) in
          guard let `self` = self else { return }
          guard let castObjs = res?.casts else {
            self.presenter?.present(nil)
            return
          }
          
          // save retrieved casts
          self.castDAO.saveAll(castObjs, completion: { _ in
            self.castDAO.findAll(completion: { (_ casts: [CastTO]) in
              logger.debug(casts)
              cast = casts.compactMap { $0.id }
              // TODO: update the movie!
              self.findAndPresentCast(cast)
            })
          })
        })
      } else {
        self.findAndPresentCast(cast)
      }

    })
  }
  
  private func findAndPresentCast(_ castIDS: [Int]) {
    var cast: [CastTO] = []
    let group = DispatchGroup()

    logger.debug(castIDS)
    for id in castIDS {
      group.enter()
      
      castDAO.findByPrimaryKey(id, completion: { (_ char: CastTO?) in
        if let `char` = char { cast.append(char) }
        group.leave()
      })
      
    }
    
    group.wait()
    self.presenter?.present(cast.compactMap { $0.asViewModel(poster: nil) })
  }
  
  
  
}
