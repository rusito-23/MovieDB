//
//  MovieServiceImpl.swift
//  MovieDB
//
//  Created by Igor on 09/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

protocol MovieService {
  func findAll(completion: @escaping (Movies.Response?) -> Void)
  func fetchPoster(for url: String?, completion: @escaping (UIImage?) -> Void)
  func fetchBackDrop(for url: String?, completion: @escaping (UIImage?) -> Void)
}
