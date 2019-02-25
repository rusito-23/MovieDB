//
//  RoundShadowButton.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 25/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class RoundShadowButton: UIButton {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // custom configuration
    self.round()
    self.shadow()
  }
  
  private func round() {
    // make it round
    self.layer.cornerRadius = 10
  }
  
  private func shadow() {
    // make it shadow
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 5, height: 5)
    self.layer.shadowRadius = 3
    self.layer.shadowOpacity = 0.5
  }
  


}
