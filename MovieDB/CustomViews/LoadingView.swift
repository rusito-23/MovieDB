//
//  LoadingView.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 25/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit
import Lottie

enum LoadingType {
  case poster
  case movie
  case refresh
  
  var rawValue: (file: String, anim: String) {
    get {
      switch self {
      case .movie:
        return ("LoadingView", "loading")
      case .poster:
        return ("LoadingView", "poster_loading")
      case .refresh:
        return ("RefreshView", "loading")
      }
    }
  }
}


class LoadingView: UIView {
  
  //   MARK: setup
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var loadingView: LOTAnimationView!
  private var type: LoadingType = .movie
  
  required convenience init(type: LoadingType) {
    self.init(frame: CGRect.zero)
    self.type = type
    customSetup()
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
    loadAnimation()
  }
  
  private func loadBundle() {
    Bundle.main.loadNibNamed(self.type.rawValue.file, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  private func loadAnimation() {
    loadingView.setAnimation(named: self.type.rawValue.anim)
    loadingView.loopAnimation = true
    loadingView.play()
  }
  
  public func setupWithSuperView(_ superView: UIView) {
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


