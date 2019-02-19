//
//  MoviesPresenter.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/02/2019.
//  Copyright (c) 2019 Igor Andruskiewitsch. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MoviesPresentationLogic {
  func presentMovies(response: Movies.List.Response?)
}

class MoviesPresenter: MoviesPresentationLogic {
  weak var viewController: MoviesDisplayLogic?
  
  // MARK: Do something
  
  func presentMovies(response: Movies.List.Response?) {
    DispatchQueue.main.async {  [weak self] in
      guard let `self` = self else {
        return
      }
      
      guard let res = response else {
        self.viewController?.displayError()
        return
      }
      self.viewController?.displayMovies(movies: res.movies)
    }
  }
}
