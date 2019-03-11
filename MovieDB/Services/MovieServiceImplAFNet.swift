//
//  MovieServiceImplAFNet.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 11/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking


class MovieServiceImplAFNet: MovieService {
  
  init() {
  }
  
  private let urlCreator = injector.resolve(MovieServiceUrlCreator.self)
  
  private func manager(with url: URL) -> AFHTTPSessionManager {
    let manager = AFHTTPSessionManager(baseURL: url)
    manager.requestSerializer = AFJSONRequestSerializer()
    manager.responseSerializer = AFJSONResponseSerializer()
    manager.securityPolicy.allowInvalidCertificates = true
    return manager
  }
  
  func findAll(completion: @escaping (Movies.Response?) -> Void) {
    guard let url = urlCreator?.createUrl(for: .discover, with: nil) else {
      completion(nil)
      return
    }
    
    logger.debug("url: \(url)")

    let manager = self.manager(with: url)
    
    manager.get("", parameters: nil, success: { (_ task: URLSessionDataTask, _ responseObject: Any?) -> Void in
      
      guard let data = responseObject as? [String: Any],
        let results = data["results"] as? [[String : Any]] else {
          completion(nil)
          return
      }
      
      let res = Movies.Response(json: results)
      completion(res)
      }, failure: { (_ task: URLSessionDataTask?, _ error: Error) -> Void in
        completion(nil)
    })

  }
  
  func fetchPoster(for url: String?, completion: @escaping (UIImage?) -> Void) {
    completion(nil)
  }
  
  func fetchBackDrop(for url: String?, completion: @escaping (UIImage?) -> Void) {
    completion(nil)
  }

}
