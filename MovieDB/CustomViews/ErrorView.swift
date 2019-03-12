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
  @IBOutlet weak var backButton: UIButton!
  
  //  MARK: Setup
  var delegate: ErrorViewDelegate? {
    didSet {
      guard let `delegate` = delegate else { return }
      backButton.addTarget(delegate, action: #selector(delegate.errorBackButtonPressed), for: .touchUpInside)
    }
  }
  
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
    self.translatesAutoresizingMaskIntoConstraints = false
    
    // setup size
    self.frame.size = superView.frame.size

    // add to superView
    superView.addSubview(self)
    
    // constraints
    superView.addConstraints([
      NSLayoutConstraint(item: self.contentView, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: self.contentView, attribute: .width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1, constant: 0),
    ])
  }

}


@objc protocol ErrorViewDelegate {
  func errorBackButtonPressed()
}
