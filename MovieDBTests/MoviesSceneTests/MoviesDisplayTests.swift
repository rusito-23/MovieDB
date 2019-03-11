//
//  MoviesViewControllerTests.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 11/03/2019.
//  Copyright (c) 2019 Igor Andruskiewitsch. All rights reserved.

@testable import MovieDB
import XCTest
import Swinject

class MoviesDisplayTests: XCTestCase {
  // MARK: Subject under test
  
  var sut: MoviesViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp() {
    super.setUp()
    window = UIWindow()
    setupMoviesViewController()
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
    logger.debug("Tearing down tests")
    Swinject.setup()
  }
  
  // MARK: Test setup
  
  func setupMoviesViewController() {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = (storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController)
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  class MoviesInteractorSpy: MoviesInteractor {
    var findMoviesCalled = false
    var refreshMoviesCalled = false
    
    func findMovies() {
      findMoviesCalled = true
    }
    
    func refreshMovies() {
      refreshMoviesCalled = true
    }
    
    var presenter: MoviesPresenter?
  }
  
  // MARK: Tests
  
  func testShouldLoadMoviesWhenViewIsLoaded() {
    // Given
    let spy = MoviesInteractorSpy()
    injector.register(MoviesInteractor.self, factory: { (r: Resolver, viewController: MoviesDisplay) in
      return spy
    })

    // When
    loadView()
    
    // Then
    XCTAssertTrue(spy.findMoviesCalled, "viewDidLoad() should ask the interactor to load movies")
  }
  
}

