//
//  AbstractDAO.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 22/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import RealmSwift

protocol GenericDAO {
  func save<T:Object>(_ object: T) -> Bool
  func saveAll<T:Object>(_ objects: [T]) -> Int
  func findAll<T:Object>() -> [T]
}

class AbstractDAOImpl: GenericDAO {
  
  //  MARK: setup
  var object: Object.Type
  var realm: Realm?
  
  init<T:Object>(_ type: T.Type) {
    self.object = type
    self.realm = try? Realm()
  }

  
  //   MARK: protocol implementation
  
  func save<T:Object>(_ object: T) -> Bool {
    guard let `realm` = realm else {
      return false
    }
    
    do {
      try realm.write {
        realm.add(object)
      }
    } catch {
      print("Error info: \(error)")
      return false
    }
    
    return true
  }
  
  func saveAll<T:Object>(_ objects: [T]) -> Int {
    var count = 0
    for obj in objects {
      if save(obj) { count += 1 }
    }
    return count
  }
  
  func findAll<T: Object>() -> [T] {
    let results = realm?.objects(self.object)
    guard let res = results else {
      return []
    }
    return Array(res)
  }

  
}
