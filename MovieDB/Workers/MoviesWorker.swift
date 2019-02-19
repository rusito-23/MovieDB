//
//  MoviesWorker.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/02/2019.
//  Copyright (c) 2019 Igor Andruskiewitsch. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation
import UIKit

class MoviesWorker {
  
  // discover
  private let endPoint = "https://api.themoviedb.org/3/"
  private let filterStarter = "/movie?"
  private let apiKey = "api_key=***REMOVED***"
  
  // poster
  private let posterEndPoint = "https://image.tmdb.org/t/p/original"
  
  // general
  private let urlSession = URLSession(configuration: .default)
  
  enum Action: String {
    case discover
    case poster
  }
  
  private func createUrl(for action: Action, with path: String?) -> URL? {
    switch action {
    case .discover:
      return URL(string: endPoint + action.rawValue + filterStarter + apiKey)
    case .poster:
      guard let `path` = path else {
        return nil
      }
      return NSURL.init(string: posterEndPoint + path) as! URL
    }
  }
  
  private func createUrlRequest(for action: Action, with path: String?) -> URLRequest? {
    guard let url = createUrl(for: action, with: path) else {
      return nil
    }
    var urlRequest = URLRequest(url: url,
                                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                timeoutInterval: 10.0 * 1000)
    urlRequest.httpMethod = "GET"
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    return urlRequest
  }
  
  func findAll(completion: @escaping (Movies.List.Response?) -> Void) {
    guard let urlRequest = createUrlRequest(for: .discover, with: nil) else {
      completion(nil)
      return
    }
    
    let task = urlSession.dataTask(with: urlRequest) { (data, response, error) -> Void in
      
      guard error == nil else {
        completion(nil)
        print("request has given error")
        return
      }
      
      guard let data = data else {
        completion(nil)
        print("error: data came nil")
        return
      }
      
      // TODO: parsear las peliculas
      guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
        let movies = json?["results"] as? [[String: Any]] else {
          completion(nil)
          return
      }
      
      let result = Movies.List.Response(json: movies)
      completion(result)
    }
    task.resume()
  }
  
  func fetchPoster(for movie: Movies.List.ViewModel, completion: @escaping (UIImage?) -> Void) {
    guard let url = createUrl(for: .poster, with: movie.posterUrl) else {
      completion(nil)
      return
    }
    
    DispatchQueue.global().async {
      guard let data = NSData.init(contentsOf: url),
            let poster = UIImage.init(data: data as Data) else {
        completion(nil)
        return
      }
      completion(poster)
    }
  }
  
}
