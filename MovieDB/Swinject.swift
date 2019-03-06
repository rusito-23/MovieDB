//
//  SwinjectStoryboard.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 06/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import Swinject

let container = Container()
let injector = container

class Swinject {

  public static func setup() {


    // Presenters
    container.register(MoviesPresenter.self) { (r: Resolver, viewController: MoviesViewController) in
      let presenter = MoviesPresenterImpl()
      presenter.viewController = viewController
      return presenter
    }
    container.register(SingleMoviePresenter.self) { (r: Resolver, viewController: SingleMovieViewController) in
      let presenter = SingleMoviePresenterImpl()
      presenter.viewController = viewController
      return presenter
    }
    container.register(MovieCellPresenter.self) { (r: Resolver, viewController: MovieCell) in
      let presenter = MovieCellPresenterImpl()
      presenter.viewController = viewController
      return presenter
    }
    
    // Interactors
    container.register(MoviesInteractor.self) { (r: Resolver, viewController: MoviesViewController) in
      let interactor = MoviesInteractorImpl()
      interactor.presenter = r.resolve(MoviesPresenter.self, argument: viewController)
      return interactor
    }
    container.register(SingleMovieInteractor.self) { (r: Resolver, viewController: SingleMovieViewController) in
      let interactor = SingleMovieInteractorImpl()
      interactor.presenter = r.resolve(SingleMoviePresenter.self, argument: viewController)
      return interactor
    }
    container.register(MovieCellInteractor.self) { (r: Resolver, viewController: MovieCell) in
      let interactor = MovieCellInteractorImpl()
      interactor.presenter = r.resolve(MovieCellPresenter.self, argument: viewController)
      return interactor
    }

  }

}
