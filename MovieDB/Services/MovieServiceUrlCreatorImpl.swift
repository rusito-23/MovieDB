//
//  MovieServiceUrlCreatorImpl.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 11/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

class MovieServiceUrlCreatorImpl: MovieServiceUrlCreator {
  // TODO: all private info from this file should be inside a plist
  
  // MARK: variables
  
  // discover
  private let endPoint = "https://api.themoviedb.org/3/"
  private let filterStarter = "/movie?"
  private let apiKey = "api_key=***REMOVED***" // WARNING: this shouldn't be here
  
  // poster
  private let posterEndPoint = "https://image.tmdb.org/t/p/original"
  
  // video
  private let videoFilter = "/videos?"
  private let videoMovieFilter = "movie/"
  
  // youtube
  private let youtube = "https://www.youtube.com/embed/"
  
  // MARK: protocol implementation
  
  func createUrl(for action: MovieServiceAction, with path: String?) -> URL? {
    switch action {
    case .discover:
      return URL(string: endPoint + action.rawValue + filterStarter + apiKey)
    case .poster:
      guard let `path` = path else {
        return nil
      }
      return URL(string: posterEndPoint + path)
    case .trailer:
      guard let id = path else { return nil }
      return URL(string: endPoint + videoMovieFilter + id + videoFilter + apiKey)
    case .trailer_yt:
      guard let trailerID = path else { return nil }
      return URL(string: youtube + trailerID)
    }
  }
  
}
