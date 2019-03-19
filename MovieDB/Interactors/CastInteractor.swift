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
      
      // fetch cast from service
      logger.info("Fetching cast from service")
      let castTO = self.fetchCastsFromService(movieStruct: movie)
      self.findAndPresentCast(castTO)
    })
  }
  
  private func findAndPresentCast(_ cast: [Cast]) {
    self.presenter?.present(cast.compactMap { $0.asViewModel(poster: nil) })
  }
  
  
  private func fetchCastsFromService(movieStruct: MovieStruct) -> [Cast] {
    logger.debug("fetchCastsFromService")
    
    let group = DispatchGroup()
    var cast: [Cast] = []
    
    group.enter()
    movieService?.findCast(for: movieStruct.id, completion: { [weak self] (_ res: Casts.Response?) -> Void in
      guard let `self` = self else { return }
      guard res?.casts != nil else { self.presenter?.present(nil); return}
      cast = res!.casts
      group.leave()
    })
    
    group.wait()
    return cast
  }
  
  
}
