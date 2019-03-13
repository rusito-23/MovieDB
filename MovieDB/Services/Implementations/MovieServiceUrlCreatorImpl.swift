//
//  MovieServiceUrlCreatorImpl.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 11/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

class MovieServiceUrlCreatorImpl: MovieServiceUrlCreator {
  
  // MARK: dictionary
  
  var dictionary: NSDictionary? {
    if let path = Bundle.main.path(forResource: "API_INFO", ofType: "plist") {
      return NSDictionary(contentsOfFile: path)
    }
    logger.error("API_INFO.plist required!")
    return nil
  }

  // MARK: filters
  
  private let movieFilter = "/movie?"
  private let videoFilter = "/videos?"

  // MARK: protocol implementation
  
  func createUrl(for action: MovieServiceAction, with path: String?) -> URL? {

    guard let `apiKey` = apiKey else {
      logger.error("API KEY required!")
      return nil
    }
    
    var str : String?
    
    switch action {
      
        case .discover:
          str = String.concat([url(for: action), action.rawValue, movieFilter, apiKey])
          break

        case .poster:
          str = String.concat([url(for: action), path])
          break

        case .trailer:
          str = String.concat([url(for: action), path, videoFilter, apiKey])
          break

        case .trailer_yt:
          str = String.concat([url(for: action), path])
          break
    
        case .genres:
          str = String.concat([url(for: action), apiKey])
      
    }
    guard str != nil else { return nil }
    return URL(string: str!)
  }
  
  
  // MARK: PLIST data
  
  var apiKey: String? {
    get {
      guard let key = dictionary?["key"] as? String else { return nil }
      return "api_key=\(key)"
    }
  }
  
  func url(for action: MovieServiceAction) -> String? {
    let url = dictionary?[action.rawValue] as? String
    if url == nil { logger.error("No value found for key: \(action.rawValue) in file API_INFO.plist") }
    return url
  }

}
