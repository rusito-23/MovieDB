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

    container.register(MoviesInteractor.self) { _ in MoviesInteractorImpl() }
    container.register(SingleMovieInteractor.self) { _ in SingleMovieInteractorImpl() }
    container.register(MovieCellInteractor.self) { _ in MovieCellInteractorImpl() }

  }

}
