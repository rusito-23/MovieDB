//
//  Buttons.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 21/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

class FloatingButton: UIButton {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // custom configuration
    self.round()
    self.shadow()
    
    logger.info("Custom configuration")
  }
  
  private func round() {
    // make it round
    self.layer.cornerRadius = 0.5 * self.bounds.size.width
  }
  
  private func shadow() {
    // make it shadow
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 5, height: 5)
    self.layer.shadowRadius = 3
    self.layer.shadowOpacity = 0.5
  }

}
