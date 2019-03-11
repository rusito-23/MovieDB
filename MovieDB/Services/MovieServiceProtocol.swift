//
//  MovieServiceImpl.swift
//  MovieDB
//
//  Created by Igor on 09/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

enum MovieServiceAction: String {
  case discover
  case poster
  case trailer
}

protocol MovieService {
  func findAll(completion: @escaping (Movies.Response?) -> Void)
  func fetchPoster(for url: String?, completion: @escaping (UIImage?) -> Void)
  func fetchBackDrop(for url: String?, completion: @escaping (UIImage?) -> Void)
}

protocol MovieServiceUrlCreator {
  func createUrl(for action: MovieServiceAction, with path: String?) -> URL?
}
