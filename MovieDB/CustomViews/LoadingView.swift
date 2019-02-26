//
//  LoadingView.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 25/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit
import Lottie

class LoadingView: UIView {
  
  //   MARK: setup
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var loadingView: LOTAnimationView!
  
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
    Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  private func loadAnimation() {
    loadingView.setAnimation(named: "loading")
    loadingView.loopAnimation = true
    loadingView.play()
  }
  

}
