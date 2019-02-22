//
//  AbstractDAO.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 22/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import RealmSwift


class GenericDAO <T:Object> {
  
  //  MARK: setup
  var realm: Realm?
  init() {
    do {
      realm = try Realm()
    } catch {
      print("Error al inicializar Realm: \(error)")
    }
  }

  //   MARK: protocol implementation
  
  func save(_ object: T) -> Bool {
    guard let `realm` = realm else {
      return false
    }
    
    do {
      try realm.write {
        realm.add(object)
      }
    } catch {
      return false
    }
    
    return true
  }
  
  func saveAll(_ objects: [T]) -> Int {
    var count = 0
    for obj in objects {
      if save(obj) { count += 1 }
    }
    return count
  }
  
  func findAll() -> [T] {
    let results = realm?.objects(T.self)
    guard let res = results else {
      return []
    }
    return Array(res)
  }

  
}
