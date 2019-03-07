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
  
  func save(_ object: T, completion: @escaping (_ : Bool) -> () )
  
  func saveAll(_ objects: [T], completion: @escaping (_ : Int) -> () )
  
  func findAll(completion: @escaping (_ : [T]) -> () )
  
  func findByPrimaryKey(_ id: Any, completion: @escaping (_ : T?) -> () )
  
  func deleteAll(completion: @escaping (_ : Bool) -> ())
  
  func resolve(_ ref : ThreadSafeReference<T>) -> T?
  
}
