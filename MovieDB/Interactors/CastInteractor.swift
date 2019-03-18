//
//  CastInteractor.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

protocol CastInteractor {
  func findAll(for movieID: Int?)
  var presenter: CastPresenter? { get set }
  var movieService: MovieService? { get set }
}

class CastInteractorImpl: CastInteractor {
  
  var presenter: CastPresenter?
  var movieService: MovieService?
  
  // MARK: protocol implementation
  
  func findAll(for movieID: Int?) {
    guard let `movieID` = movieID else {
      logger.error("No movieID found for CastInteractor!")
      presenter?.present(nil)
      return
    }
    
    // TODO: implementar esto en serio
    
  }
  
}
