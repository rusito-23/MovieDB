//
//  StringMatch.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 20/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation


protocol StringSearch {
  func compare(haystack: String, needle: String) -> Bool
}

class NaiveStringSearchImpl: StringSearch {
  
  func compare(haystack: String, needle: String) -> Bool {
    
    // first, split into arrays and sort
    let `haystack` = haystack.uppercased().split(separator: " ")
    let `needle` = needle.uppercased().split(separator: " ")
    
    // now, search if there are ocurrences
    
    var count = 0

    for n in needle {
      
      for w in haystack {
        
        let zipped = zip(n, w).compactMap { $0 }

        if zipped.count >= n.count {
          
          var equals = true
          
          for (a, b) in zipped {
            equals = equals && (a == b)
          }
          
          if equals {
            count += 1
            break
          }
          
        }

      }
      
    }

    return count >= needle.count
  }
  

}
