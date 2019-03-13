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
  
  //  MARK: private setup
  
  init() {
  }
  
  private let urlCreator = injector.resolve(MovieServiceUrlCreator.self)
  
  private func manager(with url: URL) -> AFHTTPSessionManager {
    let manager = AFHTTPSessionManager(baseURL: url)
    manager.requestSerializer = AFJSONRequestSerializer()
    manager.responseSerializer = AFJSONResponseSerializer()
    manager.securityPolicy.allowInvalidCertificates = true
    manager.securityPolicy.validatesDomainName = false
    manager.securityPolicy.allowInvalidCertificates = true
    return manager
  }
  
  //  MARK: protocol implementation
  
  func findAll(completion: @escaping (Movies.Response?) -> Void) {
    DispatchQueue.global(qos: .background).async {

      guard let url = self.urlCreator?.createUrl(for: .discover, with: nil) else {
        completion(nil)
        return
      }
      
      logger.debug("url: \(url)")
      
      let manager = self.manager(with: url)
      
      manager.get("", parameters: nil, progress: nil,
                  success: { (_ task: URLSessionDataTask, _ responseObject: Any?) -> Void in
                    
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
  }
  
  func fetchPoster(for url: String?, completion: @escaping (UIImage?) -> Void) {
    DispatchQueue.global(qos: .background).async {
      guard let url = self.urlCreator?.createUrl(for: .poster, with: url) else {
        completion(nil)
        return
      }
      self.fetchImage(url, completion: completion)
    }
  }
  
  func fetchBackDrop(for url: String?, completion: @escaping (UIImage?) -> Void) {
    DispatchQueue.global(qos: .background).async {
      guard let url = self.urlCreator?.createUrl(for: .poster, with: url) else {
        completion(nil)
        return
      }
      self.fetchImage(url, completion: completion)
    }
  }
  
  private func fetchImage(_ url: URL, completion: @escaping (UIImage?) -> Void) {
    
    let serializer = AFImageResponseSerializer()
    var acceptableContentTypes = Set<String>()
    acceptableContentTypes.insert("image/jpg")
    acceptableContentTypes.insert("image/jpeg")
    serializer.acceptableContentTypes = acceptableContentTypes

    let manager = self.manager(with: url)
    manager.responseSerializer = serializer

    manager.get(url.absoluteString, parameters: nil, progress: nil,
          success: { (_ task: URLSessionDataTask, _ responseObject: Any?) -> Void in
            
            let image = responseObject as? UIImage
            
            completion(image)
            
          }, failure: { (_ task: URLSessionDataTask?, _ error: Error) -> Void in
            logger.error("failed fetchImage task: \(error)")
            completion(nil)
    })
  }
  
  func findGenres(completion: @escaping (Genres.Response?) -> Void) {
    return
  }

}
