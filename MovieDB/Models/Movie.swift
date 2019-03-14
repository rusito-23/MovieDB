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
import RealmDAO

// MARK: REALM object

class Movie: Object, Transferrable {
  typealias S = MovieStruct
  
  @objc dynamic var id: Int = 0
  var genres = List<Int>()
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
      let genres = json["genre_ids"] as? [Int],
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
    self.genres.append(objectsIn: genres)
  }

  func transfer() -> MovieStruct {
    var movie = MovieStruct()
    movie.id = self.id
    movie.title = self.title
    movie.overview = self.overview
    movie.releaseDate = self.releaseDate
    movie.posterUrl = self.posterUrl
    movie.backDropPath = self.backDropPath
    movie.trailerUrl = self.trailerUrl
    movie.genres.append(contentsOf: self.genres)
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
  var genres: [Int] = []
  
  func asViewModel(poster: UIImage?) -> Movies.ViewModel {
    var viewModel = Movies.ViewModel()
    viewModel.id = self.id
    viewModel.title = self.title
    viewModel.overview = self.overview
    viewModel.poster = poster
    return viewModel
  }
  
}


// MARK: Service/View structs
enum Movies
{
  
  //  MARK: Request
  struct Request
  {
  }
  
  //  MARK: Response
  struct Response
  {
    var movies: [Movie] = []
    
    init? (json movies: [[String: Any]]) {
      for json in movies {
        if let movie = Movie(json: json) {
          self.movies.append(movie)
        }
      }
    }
  }
  
  //  MARK: ViewModel
  struct ViewModel
  {
    var id: Int?
    var title: String?
    var overview: String?
    var releaseDate: Date?
    var poster: UIImage?
  }
  
}
