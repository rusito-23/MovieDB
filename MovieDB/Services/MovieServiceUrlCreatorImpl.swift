//
//  MovieServiceUrlCreatorImpl.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 11/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

class MovieServiceUrlCreatorImpl: MovieServiceUrlCreator {
  
  // MARK: variables
  
  var dictionary: NSDictionary? {
    if let path = Bundle.main.path(forResource: "API_INFO", ofType: "plist") {
      return NSDictionary(contentsOfFile: path)
    }
    logger.error("API_INFO.plist required!")
    return nil
  }

  // todo
  private let movieFilter = "/movie?"
  private let videoFilter = "/videos?"

  // MARK: protocol implementation
  
  func createUrl(for action: MovieServiceAction, with path: String?) -> URL? {
    guard let `apiKey` = apiKey else {
      logger.error("API KEY required!")
      return nil
    }
    
    switch action {
      
        case .discover:
          guard let str = String.concat([url(for: action), action.rawValue, movieFilter, apiKey])  else { return nil }
          return URL(string: str)
    
        case .poster:
          guard let `path` = path,
                let str = String.concat([url(for: action), path])  else { return nil }
          return URL(string: str)
    
        case .trailer:
          guard let id = path,
                let str = String.concat([url(for: action), id, videoFilter, apiKey]) else { return nil }
          return URL(string: str)
    
        case .trailer_yt:
          guard let trailerID = path,
                let str = String.concat([url(for: action), trailerID]) else { return nil }
          return URL(string: str)
    }
  }
  
  
  // MARK: PLIST data
  
  var apiKey: String? {
    get {
      guard let key = dictionary?["key"] as? String else { return nil }
      return "apikey=\(key)"
    }
  }
  
  func url(for action: MovieServiceAction) -> String? {
    return dictionary?[action.rawValue] as? String
  }

}
