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
  let background = { (block: @escaping () -> ()) in
    DispatchQueue.global(qos: .background).async (execute: block)
  }

  //   MARK: protocol implementation
  
  func save(_ object: T, completion: @escaping (_ : Bool) -> () ) {
    background {
      do {
        let realm = try! Realm()
        try realm.write {
          realm.add(object)
        }
      } catch {
        completion(false)
      }
      completion(true)
    }
  }
  
  func saveAll(_ objects: [T], completion: @escaping (_ : Int) -> () ){
    background {
      var count = 0
      guard let realm = try? Realm() else { completion(count); return }
      for obj in objects {
        do {
          try realm.write {
            realm.add(obj)
            count += 1
          }
        } catch {
        }
      }
      completion(count)
    }
  }
  
  private func findAllResults() -> Results<T>? {
    if let realm = try? Realm() {
      return realm.objects(T.self)
    }
    return nil
  }
  
  func findAll(completion: @escaping ([T]) -> () ) {
    background {
      guard let res = self.findAllResults() else { completion([]); return }
      completion(Array(res))
    }
  }

  func findByPrimaryKey(_ id: Any, completion: @escaping (T?) -> () ){
    background{
      let realm = try? Realm()
      completion(realm?.object(ofType: T.self, forPrimaryKey: id))
    }
  }
  
  func deleteAll(completion: @escaping (_ : Bool) -> () ) {
    background {
      guard let res = self.findAllResults(),
            let realm = try? Realm() else {
              logger.error("No realm")
              completion(false)
              return
      }
      
      do {
        try realm.write {
          realm.delete(res)
          completion(true)
        }
      } catch {
        logger.error("error deleting movies")
        completion(false)
      }
    }
  }

  func resolve(_ ref : ThreadSafeReference<T>) -> T? {
    let realm = try! Realm()
    return realm.resolve(ref)
  }

}
