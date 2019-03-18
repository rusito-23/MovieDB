//
//  Cast.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import RealmSwift
import RealmDAO


class Cast: Object, Transferrable {
  typealias S = CastTO
  
  var id = RealmOptional<Int>()
  @objc dynamic var name: String?
  @objc dynamic var character: String?
  @objc dynamic var profilePath: String?

  func transfer() -> S {
    var to = CastTO()
    to.id = self.id.value
    to.name = self.name
    to.character = self.character
    to.profilePath = self.profilePath
    return to
  }
  
  convenience init?(json: [String: Any]) {
    self.init()
    
    guard let id = json["id"] as? Int,
          let name = json["name"] as? String,
          let profilePath = json["profilePath"] as? String,
          let character = json["character"] as? String else {
            logger.error("Error parsing cast!")
            return nil
    }
    
    self.id = RealmOptional<Int>(id)
    self.name = name
    self.character = character
    self.profilePath = profilePath
  }
  
}


struct CastTO {
  var id: Int?
  var name: String?
  var character: String?
  var profilePath: String?
}

// MARK: Service/View structs
enum Casts
{
  
  //  MARK: Request
  struct Request
  {
  }
  
  //  MARK: Response
  struct Response
  {
    var casts: [Cast] = []
    
    init? (json casts: [[String: Any]]) {
      for json in casts {
        if let cast = Cast(json: json) {
          self.casts.append(cast)
        }
      }
    }
  }
  
}
