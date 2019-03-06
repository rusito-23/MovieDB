//
//  MovieCellPresenter.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 28/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

protocol MovieCellPresenter {
  func presentPoster(_ poster: UIImage?)
  var viewController: MovieCell? { get set }
}

class MovieCellPresenterImpl: MovieCellPresenter {
  
  var viewController: MovieCell?
  
  func presentPoster(_ poster: UIImage?) {
    if poster != nil {
      viewController?.populatePoster(poster: poster)
    }
  }

}
