//
//  ViewExtensions.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 21/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
    self.alpha = 0.0
    
    UIView.animate(withDuration: duration, delay: delay, options: .transitionFlipFromBottom, animations: {
      self.isHidden = false
      self.alpha = 1.0
    }, completion: completion)
  }
  
  func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
    self.alpha = 1.0
    
    UIView.animate(withDuration: duration, delay: delay, options: .transitionFlipFromTop, animations: {
      self.alpha = 0.0
    }) { (completed) in
      self.isHidden = true
      completion(true)
    }
  }
}
