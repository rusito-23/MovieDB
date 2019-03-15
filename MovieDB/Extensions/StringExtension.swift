//
//  StringExtension.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 12/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

extension String {
  
  static func concat(_ list: [String?]) -> String? {
    if !list.contains(nil) {
      return list.compactMap  { $0 }.joined()
    } else {
      return nil
    }
  }
  
  func trim() -> String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var isEmptyTrimmed: Bool {
    get {
      return self.trim().isEmpty
    }
  }

}
