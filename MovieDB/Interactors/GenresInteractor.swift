//
//  GenresInteractor.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 13/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import RealmDAO

protocol GenresInteractor {
  var presenter: GenresPresenter? { get set }
  
  func findAll()
}

class GenresInteractorImpl: GenresInteractor {
  
  var presenter: GenresPresenter?
  
  var genresDAO = GenericDAO<Genre>()
  var movieService = injector.resolve(MovieService.self)

  func findAll() {
    
    // check if there are any genres in db
    genresDAO.findAll(completion: { [weak self] (genres: [GenreTO]) in
      guard let `self` = self else { return }
      
      if !genres.isEmpty {
        logger.info("Finding from db")
        
        self.presenter?.present(genres)
      } else {
        // if no genres were found in the db
        logger.info("Fetching from service")
        
        self.movieService?.findGenres(completion: { [weak self] (_ res: Genres.Response?) in
          guard let `self` = self else { return }

          guard let genres = res?.genres else {
            self.presenter?.present(nil)
            return
          }
          
          self.genresDAO.saveAll(genres, completion: { _ in
            let genresTO = genres.map { $0.transfer() }
            self.presenter?.present(genresTO)
          })

        })
      }

    })

  }
  
}
