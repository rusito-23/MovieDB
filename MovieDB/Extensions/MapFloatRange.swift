//
//  MapGloat.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 06/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import QuartzCore

extension CGFloat {
  func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
    let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
    return result
  }
}

extension Double {
  func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> Double {
    return Double(CGFloat(self).map(from: from, to: to))
  }
}

extension Float {
  func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> Float {
    return Float(CGFloat(self).map(from: from, to: to))
  }
}
