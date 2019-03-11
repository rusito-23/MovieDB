//
//  MoviesInteractorTests.swift
//  MovieDBTests
//
//  Created by Igor Andruskiewitsch on 11/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

@testable import MovieDB
import XCTest
import Swinject

class MoviesInteractorTests: XCTestCase {
  
  // MARK: Subject under test
  
  var sut: MoviesInteractor!
  var spy: MoviesPresenterSpy!
  
  // MARK: Test lifecycle

  override func setUp() {
    super.setUp()
    setupSpy()
    setupMoviesInteractor()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Test Setup
  var group = DispatchGroup()

  func setupMoviesInteractor() {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    let moviesViewController = (storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController)
    sut = injector.resolve(MoviesInteractor.self, argument: moviesViewController)
  }
  
  func setupSpy() {
    spy = MoviesPresenterSpy(group)
    injector.register(MoviesPresenter.self, factory: { (r: Resolver, viewController: MoviesViewController) in
      logger.debug("Registering Spy")
      return self.spy
    })
  }
  
  // MARK: test doubles
  
  class MoviesPresenterSpy: MoviesPresenter {
    var presentMoviesCalled = false
    var group: DispatchGroup?
    
    init(_ group: DispatchGroup) {
      self.group = group
    }

    func presentMovies(_ movies: [Movies.ViewModel]?) {
      presentMoviesCalled = true
      group?.leave()
    }
    
    var viewController: MoviesDisplay?
  }
  
  // MARK: tests

  func testPresentMoviesCalled() {
    // When
    group.enter()
    sut.findMovies()

    group.wait()
    // Then
    XCTAssertTrue(spy.presentMoviesCalled, "findMovies should allways call presentMovies")
  }
  
}
