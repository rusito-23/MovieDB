//
//  Movie.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 25/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

// MARK: REALM object

class Movie: Object, Structable {
  typealias S = MovieStruct
  
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String?
  @objc dynamic var overview: String?
  @objc dynamic var releaseDate: Date?
  @objc dynamic var posterUrl: String?
  @objc dynamic var backDropPath: String?
  @objc dynamic var trailerUrl: String?
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  convenience init?(json: [String: Any]) {
    self.init()
    
    guard
      let id = json["id"] as? Int,
      let title = json["title"] as? String,
      let description = json["overview"] as? String,
      let releaseDateString = json["release_date"] as? String,
      let backDropPath = json["backdrop_path"] as? String,
      let posterUrl = json["poster_path"] as? String else {
        logger.error("Error parsing movie: \(json) ")
        return nil
    }
    
    self.id = id
    self.title = title
    self.overview = description
    self.releaseDate = Date(string: releaseDateString, format: .snakeFormat)
    self.posterUrl = posterUrl
    self.backDropPath = backDropPath
  }
  
  func asViewModel(poster: UIImage?) -> Movies.ViewModel {
    var viewModel = Movies.ViewModel()
    viewModel.id = self.id
    viewModel.title = self.title
    viewModel.overview = self.overview
    viewModel.poster = poster
    return viewModel
  }
  
  func toStruct() -> MovieStruct {
    var movie = MovieStruct()
    movie.id = self.id
    movie.title = self.title
    movie.overview = self.overview
    movie.releaseDate = self.releaseDate
    movie.posterUrl = self.posterUrl
    movie.backDropPath = self.backDropPath
    movie.trailerUrl = self.trailerUrl
    return movie
  }
  
}

struct MovieStruct {
  var id: Int = 0
  var title: String?
  var overview: String?
  var releaseDate: Date?
  var posterUrl: String?
  var backDropPath: String?
  var trailerUrl: String?
}


