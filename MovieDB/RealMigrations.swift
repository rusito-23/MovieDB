//
//  RealMigrations.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 08/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
  
  
  static public func runMigrations() {
    
    Realm.Configuration.defaultConfiguration = Realm.Configuration(
      schemaVersion: 1,
      migrationBlock: { migration, oldSchemaVersion in
        // MIGRATIONS!
      }
    )

  }
  
}
