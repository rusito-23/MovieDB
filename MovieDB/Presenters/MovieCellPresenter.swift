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
  var viewController: MovieCellDisplay? { get set }
}

class MovieCellPresenterImpl: MovieCellPresenter {
  
  var viewController: MovieCellDisplay?
  
  func presentPoster(_ poster: UIImage?) {
    DispatchQueue.main.async {
      if poster != nil {
        self.viewController?.populatePoster(poster: poster)
      } else {
        self.viewController?.posterError()
      }
    }
  }

}
