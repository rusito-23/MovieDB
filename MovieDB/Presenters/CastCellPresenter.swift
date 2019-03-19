//
//  CastCellPresenter.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 19/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

protocol CastCellPresenter {
  func present(_ profile: UIImage?)
  var display: CastCellDisplay? { get set }
}

class CastCellPresenterImpl: CastCellPresenter {
  
  var display: CastCellDisplay?
  
  func present(_ profile: UIImage?) {
    DispatchQueue.main.async {
      if let `profile` = profile {
        self.display?.displayProfile(profile)
      } else {
        self.display?.displayError("An error ocurred while fetching the actor profile")
      }
    }
  }
  
}
