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
      let castIDS = movie.cast
      var castTO: [CastTO] = []
      if castIDS.isEmpty {
        // fetch cast from service
        logger.info("Fetching cast from service")
        castTO = self.fetchCastsFromService(movieStruct: movie)
      } else {
        // for each cast id, search it, if not found, break and fetch from service
        logger.info("Searching for casts in db")
        let group = DispatchGroup()
        
        for id in castIDS {
          group.enter()
          self.castDAO.findByPrimaryKey(id, completion: { (_ c : CastTO?) in
            if c != nil { castTO.append(c!) } else { logger.warning("Cast \(id) not found!") }
            group.leave()
          })
        }
        
        group.wait()
      }

      self.findAndPresentCast(castTO)
    })
  }
  
  private func findAndPresentCast(_ cast: [CastTO]) {
    self.presenter?.present(cast.compactMap { $0.asViewModel(poster: nil) })
  }
  
  
  private func fetchCastsFromService(movieStruct: MovieStruct) -> [CastTO] {
    logger.debug("fetchCastsFromService")
    
    let group = DispatchGroup()
    var cast: [Cast] = []
    
    group.enter()
    movieService?.findCast(for: movieStruct.id, completion: { [weak self] (_ res: Casts.Response?) -> Void in
      guard let `self` = self else { return }
      guard res?.casts != nil else { self.presenter?.present(nil); return}
      cast = res!.casts
      
      let movie: Movie = movieStruct.asObject()
      
      // save all casts into db
      for c in cast {
        self.castDAO.save(c, completion: { _ in } )
        movie.cast.append(c.id.value ?? 0)
      }
      
      // save all ids into the movie
      self.movieDAO.updateByPrimaryKey(movie, completion: { _ in })
      
      // leave group so we can return the cast
      group.leave()

    })
    
    group.wait()
    return cast.compactMap { $0.transfer() }
  }
  
  
}
