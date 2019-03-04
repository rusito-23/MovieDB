//
//  UIImageCacheExtensions.swift
//  MovieDB
//
//  Created by Igor on 04/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImage {
  
  static func fromCache(key: String?) -> UIImage? {
    guard let `key` = key else { return nil }
    return imageCache.object(forKey: key as AnyObject) as? UIImage
  }
  
  func toCache(key: String) {
    imageCache.setObject(self, forKey: key as AnyObject)
  }
  
}
