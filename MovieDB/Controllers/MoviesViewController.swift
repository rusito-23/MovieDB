//
//  MoviesViewController.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/02/2019.
//  Copyright (c) 2019 Igor Andruskiewitsch. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MoviesDisplayLogic: class
{
  func displayMovies(movies: [Movies.ViewModel])
  func displayError(_ msg: String)
}

class MoviesViewController: UIViewController
{
  var interactor: MoviesBusinessLogic?

  // MARK: outlets
  
  @IBOutlet private weak var errorView: ErrorView!
  @IBOutlet private weak var moviesTableView: UITableView!
  @IBOutlet private weak var loadingView: LoadingView!
  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let interactor = MoviesInteractor()
    let presenter = MoviesPresenter()
    self.interactor = interactor
    interactor.presenter = presenter
    presenter.viewController = self
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is SingleMovieViewController {
      let vc = segue.destination as? SingleMovieViewController
      vc?.id = self.selectedMovie
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refreshMovies()
  }
  
  func loading(_ run: Bool) {
    if run {
      self.loadingView.isHidden = false
    } else {
      self.loadingView.isHidden = true
    }
  }
  
  // MARK: fetch movies
  
  var movies: [Movies.ViewModel] = []
  var selectedMovie: Int?
  
  func refreshMovies() {
    loading(true)
    interactor?.findMovies()
  }
  

  func displayMovie(_ movie: Movies.ViewModel) {
    self.selectedMovie = movie.id
    self.performSegue(withIdentifier: "SingleMovieSegue", sender: self)
  }
}

// MARK: extensions for MoviesDisplayLogic

extension MoviesViewController: MoviesDisplayLogic {
  
  func displayError(_ msg: String) {
    self.errorView.isHidden = false
    self.errorView.errorMessage.text = msg
  }
  
  func displayMovies(movies: [Movies.ViewModel])
  {
    loading(false)
    self.movies = movies
    self.moviesTableView.reloadData()
  }
  
}


// MARK: extensions for tableView

extension MoviesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
    let movie = self.movies[indexPath.row]
    
    cell.selectionStyle = .none
    cell.populate(with: movie)
    return cell
  }

}

extension MoviesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movie = self.movies[indexPath.row]
    self.displayMovie(movie)
  }
}
