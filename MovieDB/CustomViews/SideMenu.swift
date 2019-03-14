//
//  SlideMenu.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 14/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

protocol SideMenuDelegate {
  func onVisibilityChanged(_ visible: Bool)
}

class SideMenu : UIView {
  
  // delegates
  var delegate: SideMenuDelegate?
  var blurry: Blurry?
  
  // UI vars
  var isVisible = false

}


extension SideMenu {
  
  func setupWithSuperView(_ superView: UIView) {
    
    // fixed width
    self.frame.size.width = 250
    // same height as subview
    self.frame.size.height = UIScreen.main.bounds.height
    // hide view on the right of superView
    self.frame.origin.x = superView.frame.origin.x + superView.frame.width

    // add self on top of superView navigation bar
    UIApplication.shared.keyWindow?.addSubview(self)

    // add gesture control for superView
    let slideGesture = UIPanGestureRecognizer(target: self, action: #selector(onManualSlide))
    superView.addGestureRecognizer(slideGesture)
  }
  
  func showHide() {
    slide(show: !self.isVisible)
  }
  
  public func slide(show: Bool) {
    
    if show {
      self.blurry?.loadBlur(blur: 0.3)
      UIView.animate(withDuration: 0.4, animations: { [weak self] in
        guard let `self` = self else { return }
        // show
        
        self.frame.origin.x = UIScreen.main.bounds.width - self.frame.width
        self.isVisible = true
        self.delegate?.onVisibilityChanged(self.isVisible)
        
        // change blurry
        self.blurry?.blur(alpha: self.center.x.map(from: 0...UIScreen.main.bounds.width,
                                                   to: 0...1))
      })
    } else {
      UIView.animate(withDuration: 0.4, animations: { [weak self] in
        guard let `self` = self else { return }
        // hide
        self.frame.origin.x = UIScreen.main.bounds.width
        self.isVisible = false
        
        // change blurry
        self.blurry?.blur(alpha: 1 - self.center.x.map(from: 0...UIScreen.main.bounds.width,
                                                       to: 0...1))
      }, completion: { _ in
        self.delegate?.onVisibilityChanged(self.isVisible)
        self.blurry?.unLoadBlur()
      })
    }
  }
  
  @objc func onManualSlide(_ sender: UIPanGestureRecognizer) {
    
    if (sender.state == .ended) {
      self.blurry?.unLoadBlur()
      self.showHide()
    } else {
      // translation
      let translation = sender.translation(in: self)

      if (translation.x < 0 && self.frame.origin.x < (UIScreen.main.bounds.width - self.frame.width)) { return }
      self.center.x += translation.x
      sender.setTranslation(CGPoint.zero, in: self)
      
      // blur
      if (!(self.blurry?.isBlurLoaded ?? true)) {
        self.blurry?.loadBlur()
      }
      
      let newAlpha =  self.center.x.map(from: (UIScreen.main.bounds.width - self.frame.width)...UIScreen.main.bounds.width, to: 0...1)
      self.blurry?.blur(alpha: 1 - newAlpha)
    }
    
  }
  
  
}
