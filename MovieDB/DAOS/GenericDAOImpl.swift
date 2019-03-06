//
//  AbstractDAO.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 22/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import RealmSwift


class GenericDAOImpl <T:Object> : GenericDAO {
  
  //  MARK: setup
  
  var realm: Realm?
  init() {
    do {
      realm = try Realm()
    } catch {
      logger.error("Realm Initialization Error: \(error)")
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
  
  private func findAllResults() -> Results<T>? {
    return realm?.objects(T.self)
  }
  
  func findAll() -> [T] {
    guard let res = findAllResults() else { return [] }
    return Array(res)
  }

  func findByPrimaryKey(_ id: Any) -> T? {
    return self.realm?.object(ofType: T.self, forPrimaryKey: id)
  }
  
  func deleteAll() {
    guard let res = findAllResults() else { return }
    
    do {
      try realm?.write {
        self.realm?.delete(res)
      }
    } catch {
      logger.error("Realm Error Deleting Objects: \(error)")
      return
    }
  }

}
