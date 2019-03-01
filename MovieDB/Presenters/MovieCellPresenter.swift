//
//  MovieCellPresenter.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 28/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

protocol MovieCellPresentation {
  func presentPoster(_ poster: UIImage?)
}

class MovieCellPresenter: MovieCellPresentation {
  
  var viewController: MovieCell?
  
  func presentPoster(_ poster: UIImage?) {
    if poster != nil {
      viewController?.populatePoster(poster: poster)
    }
  }

}
