//
//  StringExtension.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 12/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

// MARK: concat, trim

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

// MARK: Levenshtein

extension String {
  subscript(index: Int) -> Character {
    return self[self.index(self.startIndex, offsetBy: index)]
  }
}

extension String {
  public func levenshtein(_ other: String) -> Int {
    let sCount = self.count
    let oCount = other.count
    
    guard sCount != 0 else {
      return oCount
    }
    
    guard oCount != 0 else {
      return sCount
    }
    
    let line : [Int]  = Array(repeating: 0, count: oCount + 1)
    var mat : [[Int]] = Array(repeating: line, count: sCount + 1)
    
    for i in 0...sCount {
      mat[i][0] = i
    }
    
    for j in 0...oCount {
      mat[0][j] = j
    }
    
    for j in 1...oCount {
      for i in 1...sCount {
        if self[i - 1] == other[j - 1] {
          mat[i][j] = mat[i - 1][j - 1]       // no operation
        }
        else {
          let del = mat[i - 1][j] + 1         // deletion
          let ins = mat[i][j - 1] + 1         // insertion
          let sub = mat[i - 1][j - 1] + 1     // substitution
          mat[i][j] = min(min(del, ins), sub)
        }
      }
    }
    
    return mat[sCount][oCount]
  }
}
