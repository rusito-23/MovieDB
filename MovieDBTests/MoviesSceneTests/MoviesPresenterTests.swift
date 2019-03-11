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

class MoviesPresenterTests: XCTestCase {
  
  // MARK: Subject under test
  
  var sut: MoviesPresenter!
  var spy: MoviesViewControllerSpy!
  
  // MARK: Test lifecycle
  var group = DispatchGroup()
  
  override func setUp() {
    super.setUp()
    setUpPresenter()
  }
  
  override func tearDown() {
    super.tearDown()
    logger.debug("Tearing down tests")
    Swinject.setup()
  }
  
  // MARK: Test Setup

  func setUpPresenter() {
    spy = MoviesViewControllerSpy(group)
    sut = injector.resolve(MoviesPresenter.self, argument: spy as MoviesDisplay)
  }

  // MARK: test doubles
  
  class MoviesViewControllerSpy: MoviesDisplay {
    var group: DispatchGroup
    
    var displayMoviesCalled = false
    var displayErrorCalled = false
    
    init(_ group: DispatchGroup) {
      self.group = group
    }
    
    func displayMovies(movies: [Movies.ViewModel]) {
      displayMoviesCalled = true
      group.leave()
    }
    
    func displayError(_ msg: String) {
      displayErrorCalled = true
      group.leave()
    }
    
  }
  
  // MARK: tests
  
  func testDisplayEmptyList() { DispatchQueue.global(qos: .background).async {
    // When
    self.group.enter()
    self.sut.presentMovies([])
    
    // Then
    self.group.wait()
    XCTAssertTrue(self.spy.displayErrorCalled, "Empty list should not be valid movie presentation")
  }}
  
  func testDisplayNilValue() { DispatchQueue.global(qos: .background).async {
    // When
    self.group.enter()
    self.sut.presentMovies(nil)
    
    // Then
    self.group.wait()
    XCTAssertTrue(self.spy.displayErrorCalled, "nil should not be valid movie presentation")
  }}
  
  
  func testDisplayList() { DispatchQueue.global(qos: .background).async {
    // With
    self.group.enter()
    let movies = [
      Movies.ViewModel(),
      Movies.ViewModel(),
      Movies.ViewModel(),
    ]
    
    // When
    self.sut.presentMovies(movies)
    
    // Then
    self.group.wait()
    XCTAssertTrue(self.spy.displayMoviesCalled, "ViewModel list is a valid presentation")
  }}
  
  
}
