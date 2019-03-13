//
//  Genre.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 13/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import RealmSwift
import RealmDAO


class Genre: Object, Transferrable {
  typealias S = GenreTO

  var id = RealmOptional<Int>()
  @objc dynamic var name: String?
  
  func transfer() -> S {
    var to = GenreTO()
    to.id = self.id.value
    to.name = self.name
    return to
  }
  
  convenience init?(json: [String: Any]) {
    self.init()
    
    guard let id = json["id"] as? Int,
          let name = json["name"] as? String else {
            logger.error("Error parsing genre!")
            return nil
    }
    
    self.id = RealmOptional<Int>(id)
    self.name = name
  }
  
}

struct GenreTO {
  var id: Int?
  var name: String?
}


// MARK: Service/View structs
enum Genres
{
  
  //  MARK: Request
  struct Request
  {
  }
  
  //  MARK: Response
  struct Response
  {
    var genres: [Genre] = []
    
    init? (json genres: [[String: Any]]) {
      for json in genres {
        if let genre = Genre(json: json) {
          self.genres.append(genre)
        }
      }
    }
  }
  
}
