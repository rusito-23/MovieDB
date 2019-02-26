//
//  PosterSegue.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 26/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

class PosterSegue: UIStoryboardSegue {
  
  override func perform() {
    
    let moviesVC = self.source as! MoviesViewController
    let singleVC = self.destination as! SingleMovieViewController
    
    let moviesView = moviesVC.view!
    let singleView = singleVC.view!

    let screenHeight = UIScreen.main.bounds.size.height
    
    UIView.animate(withDuration: 0.4, animations: { () -> Void in
      moviesView.frame = moviesView.frame.offsetBy(dx: 0.0, dy: -screenHeight)
      singleView.frame = singleView.frame.offsetBy(dx: 0.0, dy: -screenHeight)
    }) { (Finished) -> Void in
      moviesVC.present(singleVC,
                       animated: false,
                       completion: nil)
    }
    
  }
  
}
