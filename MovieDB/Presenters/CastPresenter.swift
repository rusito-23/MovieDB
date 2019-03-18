//
//  CastPresenter.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation


protocol CastPresenter {
  func present(_ cast: [Casts.ViewModel]?)
  var display: CastDisplay? { get set }
}

class CastPresenterImpl: CastPresenter {

  var display: CastDisplay?
  
  // MARK: protocol implementation
  
  func present(_ cast: [Casts.ViewModel]?) {
    DispatchQueue.main.async { [weak self] in
      guard let `self` = self else { return }
      
      if let `cast` = cast {
        self.display?.displayCast(cast)
      } else {
        self.display?.displayError("An error ocurred while searching the cast")
      }
    }
  }
  
}
