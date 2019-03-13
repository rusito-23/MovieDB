//
//  GenresPresenter.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 13/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

protocol GenresPresenter {
  var display: GenresDisplay? { get set }
  
  func present(_ genres: [GenreTO]?)
}

class GenresPresenterImpl: GenresPresenter {
  
  var display: GenresDisplay?

  func present(_ genres: [GenreTO]?) {
    DispatchQueue.main.async {
      
      guard let `genres` = genres else {
        self.display?.error("An error ocurred retrieving the genres")
        return
      }
      
      guard !genres.isEmpty else {
        self.display?.error("No genres were found")
        return
      }
      
      self.display?.display(genres)
    }
  }
  
}
