//
//  MovieCellInteractor.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 28/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol MovieCellBuisnessLogic {
  func loadPoster(for viewModel: Movies.ViewModel)
  func cancelOldPoster()
}

class MovieCellInteractor: MovieCellBuisnessLogic {
  
  //  MARK: setup
  
  var presenter: MovieCellPresenter?
  var movieService: MovieService? = MovieService()
  var movieDAO = GenericDAOImpl<Movie>()
  var request: Request?

  //  MARK: load poster
  
  func loadPoster(for viewModel: Movies.ViewModel) {
    
    guard let id = viewModel.id,
          let movie = movieDAO.findByPrimaryKey(id) else {
        presenter?.presentPoster(nil)
        return
    }
    
    request = movieService?.fetchPoster(for: movie, completion: { [weak self] (_ poster: UIImage!) in
      guard let `self` = self else { return }
      self.presenter?.presentPoster(poster)
    })

  }
  
  func cancelOldPoster() {
    self.request?.cancel()
  }

}
