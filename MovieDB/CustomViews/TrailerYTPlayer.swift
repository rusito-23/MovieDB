//
//  TrailerYTPlayer.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 12/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import WebKit


class TrailerYTPlayer: WKWebView {
  
  var urlCreator = injector.resolve(MovieServiceUrlCreator.self)
  
  func play(videoID: String, superView: UIView) {
    guard let url = urlCreator?.createUrl(for: .trailer_yt, with: videoID) else {
      return
    }
    
    let request = URLRequest(url: url)
    self.load(request)
    self.setupWithSuperView(superView)
  }
  
  private func setupWithSuperView(_ superView: UIView) {
    
    // setup size
    self.translatesAutoresizingMaskIntoConstraints = false
    self.clipsToBounds = true
    self.frame = superView.bounds
    
    // add
    superView.addSubview(self)
    
    // constraints
    
    superView.addConstraints([
      NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1, constant: 0),
      ])
  }
  
}