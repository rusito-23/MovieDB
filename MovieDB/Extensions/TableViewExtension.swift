//
//  TableViewExtension.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 14/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
    return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
  }
  
  func scrollToTop(animated: Bool) {
    let indexPath = IndexPath(row: 0, section: 0)
    if self.hasRowAtIndexPath(indexPath: indexPath) {
      self.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
  }
}
