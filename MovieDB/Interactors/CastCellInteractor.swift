//
//  CastCellInteractor.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 19/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit
import RealmDAO

protocol CastCellInteractor {
  func loadProfile(for viewModel: Casts.ViewModel)
  func cancelOldProfile()
  var presenter: CastCellPresenter? { get set }
}

class CastCellInteractorImpl: CastCellInteractor {
  
  var presenter: CastCellPresenter?
  
  // MARK: Setup
  var movieService: MovieService?
  var request: Bool = false
  var castID: Int?
  
  // MARK: protocol implementation
  
  func loadProfile(for viewModel: Casts.ViewModel) {
    
    let profileCompletion = { [weak self] (_ profile: UIImage?) -> Void in
      guard let `self` = self else { return }
      self.presenter?.present(profile)
    }
    
    guard let id = viewModel.id else {
      presenter?.present(nil)
      return
    }
    
    self.castID = id
    
    // search the cast in db
    self.fetchProfileFromCache(viewModel, completion: { [weak self] (_ profile: UIImage?) in
      guard let `self` = self else { return }
      
      // if image doesn't exist in cache, fetch from service
      if let `profile` = profile {
        profileCompletion(profile)
      } else {
        self.fetchFromService(viewModel, completion: profileCompletion)
      }
    })
    
    
  }
  
  func cancelOldProfile() {
    request = false
  }
  
  private func fetchProfileFromCache(_ cast: Casts.ViewModel, completion: @escaping (_ : UIImage?) -> Void ) {
    DispatchQueue.global(qos: .background).async {
      // fetching poster from cache
      if let profile = UIImage.fromCache(key: cast.profilePath) {
        completion(profile)
      } else {
        completion(nil)
      }
    }
  }
  
  private func fetchFromService(_ cast: Casts.ViewModel, completion: @escaping (_ : UIImage?) -> Void ) {
    request = true
    movieService?.fetchPoster(for: cast.profilePath, completion: { [weak self] (_ profile: UIImage?) in
      guard let `self` = self else { return }
      
      if let url = cast.profilePath, let `profile` = profile {
        // save poster to cache (allways)
        profile.toCache(key: url)
      }
      
      // if the cell is already loading another movie, escape
      guard self.request, cast.id == self.castID else { return }
      completion(profile)
    })
  }
  
}
