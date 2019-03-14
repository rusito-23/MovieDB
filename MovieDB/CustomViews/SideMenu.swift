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
  var originalX: CGFloat?
  
}


extension SideMenu {
  
  func setupWithSuperView(_ superView: UIView) {
    
    // fixed width
    self.frame.size.width = 250
    // same height as subview
    self.frame.size.height = superView.frame.height
    // hide view on the right of superView
    self.frame.origin.x = super.frame.origin.x + superView.frame.width
    originalX = self.frame.origin.x
    
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
        self.frame.origin.x -= self.frame.width
        self.isVisible = true
        self.delegate?.onVisibilityChanged(self.isVisible)
        
        // change blurry
        if let `originalX` = self.originalX {
          self.blurry?.blur(alpha: self.center.x.map(from: 0...originalX,
                                                     to: 0...1))
        }
      })
    } else {
      UIView.animate(withDuration: 0.4, animations: { [weak self] in
        guard let `self` = self else { return }
        // hide
        self.frame.origin.x += self.frame.width
        self.isVisible = false
        
        // change blurry
        if let `originalX` = self.originalX {
          self.blurry?.blur(alpha: 1 - self.center.x.map(from: 0...originalX,
                                                         to: 0...1))
        }
        }, completion: { _ in
          self.delegate?.onVisibilityChanged(self.isVisible)
          self.blurry?.unLoadBlur()
      })
    }
  }
  
  @objc func onManualSlide(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: self)
    self.center.x += translation.x
    sender.setTranslation(CGPoint.zero, in: sender.view)
  }
  
  
}
