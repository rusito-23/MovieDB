//
//  GenericDAO.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 22/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import RealmSwift

protocol GenericDAO {
  associatedtype T:Object
  
  func save(_ object: T) -> Bool
  
  func saveAll(_ objects: [T]) -> Int
  
  func findAll() -> [T]
  
  func findByPrimaryKey(_ id: Any) -> T?
  
}
