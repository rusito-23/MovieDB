//
//  MovieCellInteractor.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 28/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit
import RealmDAO

protocol MovieCellInteractor {
  func loadPoster(for viewModel: Movies.ViewModel)
  func cancelOldPoster()
  var presenter: MovieCellPresenter? { get set }
}

class MovieCellInteractorImpl: MovieCellInteractor {
  
  var presenter: MovieCellPresenter?
  
  //  MARK: setup
  
  var movieService: MovieService?
  var movieDAO = GenericDAO<Movie>()
  var request: Bool = false

  //  MARK: load poster
  
  func loadPoster(for viewModel: Movies.ViewModel) {
    
    let posterCompletion = { [weak self] (_ poster: UIImage?) -> Void in
      guard let `self` = self else { return }
      if let `poster` = poster {
        self.presenter?.presentPoster(poster)
      }
    }
    
    guard let id = viewModel.id else {
        presenter?.presentPoster(nil)
        return
    }
    
    movieDAO.findByPrimaryKey(id, completion: { [weak self] (movie: MovieStruct?) -> () in
      guard let `self` = self else { return }
      guard let `movie` = movie else {
        logger.warning("movie not found?")
        self.presenter?.presentPoster(nil)
        return
      }
      
      if !self.fetchPosterCache(movie, completion: posterCompletion) {
        // if image doesn't exist in cache, fetch from service
        self.fetchPosterService(movie, completion: posterCompletion)
      }
      
    })

  }
  
  func cancelOldPoster() {
    request = false
  }

  private func fetchPosterCache(_ movie : MovieStruct, completion: @escaping (UIImage?) -> Void) -> Bool {
    // fetching poster from cache
    if let poster = UIImage.fromCache(key: movie.posterUrl) {
      completion(poster)
      return true
    } else {
      return false
    }
  }
  
  private func fetchPosterService(_ movie : MovieStruct, completion: @escaping (UIImage?) -> Void) {
    // fetching poster from service
    request = true
    movieService?.fetchPoster(for: movie.posterUrl, completion: { [weak self] (_ poster: UIImage!) in
      guard let `self` = self else { return }
      
      if let url = movie.posterUrl, let `poster` = poster, self.request {
        // save poster to cache
        poster.toCache(key: url)
      }
      
      completion(poster)
    })
  }
  
}
