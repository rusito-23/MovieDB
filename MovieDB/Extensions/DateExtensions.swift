//
//  DateExtensions.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

// DATE FORMAT EXTENSIONS

extension DateFormatter {
  static let snakeFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-dd-MM"
    return formatter
  }()
}

extension Date {
  func string(with format: DateFormatter) -> String {
    return format.string(from: self)
  }
  
  init?(string: String, format: DateFormatter) {
    guard let date = format.date(from: string) else { return nil }
    self.init(timeIntervalSince1970: date.timeIntervalSince1970)
  }
}
