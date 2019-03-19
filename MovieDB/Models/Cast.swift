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


class Cast {
  
  var id: Int?
  var name: String?
  var character: String?
  var profilePath: String?
  
  convenience init?(json: [String: Any]) {
    self.init()
    
    guard let id = json["id"] as? Int,
          let name = json["name"] as? String,
          let character = json["character"] as? String else {
            logger.error("Error parsing cast!")
            logger.debug(json)
            return nil
    }
    
    self.id = id
    self.name = name
    self.character = character
    self.profilePath = json["profile_path"] as? String
  }
  
  func asViewModel(poster: UIImage?) -> Casts.ViewModel {
    var viewModel = Casts.ViewModel()
    viewModel.id = self.id
    viewModel.name = self.name
    viewModel.character = self.character
    viewModel.profilePath = self.profilePath
    return viewModel
  }
  
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
  
  struct ViewModel
  {
    var id: Int?
    var name: String?
    var character: String?
    var image: UIImage?
    var profilePath: String?
  }
  
}
