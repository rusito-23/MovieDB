//
//  SwinjectStoryboard.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 06/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import Swinject

fileprivate let container = Container()
let injector = container

class Swinject {

  public static func setup() {
    logger.info("Setting up Swinject Dependencies")

    // MARK: Services
    container.register(MovieService.self) { _ in
      MovieServiceImplAlamofire()
    }
    container.register(MovieServiceUrlCreator.self) { _ in
      MovieServiceUrlCreatorImpl()
    }

    // MARK: Presenters
    
    // MoviesPresenter
    container.register(MoviesPresenter.self) { (r: Resolver, viewController: MoviesDisplay) in
      logger.debug("Resolving moviesPresenter")
      let presenter = MoviesPresenterImpl()
      presenter.viewController = viewController
      return presenter
    }
    
    // SingleMoviePresenter
    container.register(SingleMoviePresenter.self) { (r: Resolver, viewController: SingleMovieDisplay) in
      let presenter = SingleMoviePresenterImpl()
      presenter.viewController = viewController
      return presenter
    }
    
    // MovieCellPresenter
    container.register(MovieCellPresenter.self) { (r: Resolver, viewController: MovieCellDisplay) in
      let presenter = MovieCellPresenterImpl()
      presenter.viewController = viewController
      return presenter
    }
    
    // GenrePresenter
    container.register(GenresPresenter.self) { (r: Resolver, display: GenresDisplay) in
      let presenter = GenresPresenterImpl()
      presenter.display = display
      return presenter
    }
    
    // MARK: Interactors
    
    // MoviesInteractor
    container.register(MoviesInteractor.self) { (r: Resolver, viewController: MoviesDisplay) in
      let interactor = MoviesInteractorImpl()
      interactor.presenter = r.resolve(MoviesPresenter.self, argument: viewController)
      interactor.movieService = r.resolve(MovieService.self)
      return interactor
    }
    
    // SingleMovieInteractor
    container.register(SingleMovieInteractor.self) { (r: Resolver, viewController: SingleMovieDisplay) in
      let interactor = SingleMovieInteractorImpl()
      interactor.presenter = r.resolve(SingleMoviePresenter.self, argument: viewController)
      interactor.movieService = r.resolve(MovieService.self)
      return interactor
    }
    
    // MovieCellInteractor
    container.register(MovieCellInteractor.self) { (r: Resolver, viewController: MovieCellDisplay) in
      let interactor = MovieCellInteractorImpl()
      interactor.presenter = r.resolve(MovieCellPresenter.self, argument: viewController)
      interactor.movieService = r.resolve(MovieService.self)
      return interactor
    }
    
    // GenresInteractor
    container.register(GenresInteractor.self) { (r: Resolver, display: GenresDisplay) in
      let interactor = GenresInteractorImpl()
      interactor.presenter = r.resolve(GenresPresenter.self, argument: display)
      interactor.movieService = r.resolve(MovieService.self)
      return interactor
    }
    
  }
  
}
