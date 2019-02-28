//
//  ErrorView.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 25/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class ErrorView: UIView {

  //  MARK: Outlets
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var errorMessage: UILabel!
  
  //  MARK: Setup
  override init(frame: CGRect) {
    super.init(frame: frame)
    customSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    customSetup()
  }
  
  private func customSetup() {
    loadBundle()
  }
  
  private func loadBundle() {
    Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  func setupForSuperView(_ superView: UIView) {
    
    // setup size
    self.frame.size = superView.frame.size

    // add to superView
    superView.addSubview(self)
  }

}
