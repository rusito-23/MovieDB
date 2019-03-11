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
import Swinject

protocol MoviesDisplay: class
{
  func displayMovies(movies: [Movies.ViewModel])
  func displayError(_ msg: String)
}

class MoviesViewController: UIViewController {

  var interactor: MoviesInteractor?

  // MARK: outlets
  
  @IBOutlet private weak var moviesTableView: UITableView!
  let loadingView = LoadingView()
  let refreshView = LoadingView(type: .refresh)
  let errorView = ErrorView()

  // MARK: Routing
  
  var blurView: UIView?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is SingleMovieViewController {
      let vc = segue.destination as? SingleMovieViewController
      vc?.modalPresentationStyle = .overCurrentContext
      vc?.id = self.selectedMovie
      vc?.caller = self
      loadBlur()
    }
  }
  
  @IBAction func unwindSingleMovie(segue: UIStoryboardSegue) {
    logger.verbose("unwindSingleMovie")
    unLoadBlur()
  }
  
  // MARK: Setup
  private var movies: [Movies.ViewModel] = []
  private var selectedMovie: Int?
  private var refreshControl = UIRefreshControl()
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor = injector.resolve(MoviesInteractor.self, argument: self as MoviesDisplay)


    prepareRefreshControl()
    prepareNib()
    loadMovies()
  }
  
}

// MARK: UI Logic

extension MoviesViewController {
  
  func loading(_ run: Bool) {
    if run {
      self.loadingView.setupWithSuperView(self.view)
    } else {
      self.refreshControl.endRefreshing()
      self.loadingView.removeFromSuperview()
    }
  }

  func loadMovies() {
    loading(true)
    interactor?.findMovies()
  }
  
  func didSelectMovie(_ movie: Movies.ViewModel) {
    self.selectedMovie = movie.id
    self.performSegue(withIdentifier: "SingleMovieSegue", sender: self)
  }
  
}

// MARK: MoviesDisplay implementation

extension MoviesViewController: MoviesDisplay {

  func displayError(_ msg: String) {
    loading(false)
    errorView.errorMessage.text = msg
    errorView.setupForSuperView(self.view)
  }
  
  func displayMovies(movies: [Movies.ViewModel])
  {
    loading(false)
    self.movies = movies
    self.moviesTableView.allowsSelection = true
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
    
    cell.populate(with: movie)
    return cell
  }

}

extension MoviesViewController: UITableViewDelegate {
  
  // register nib file for cell view
  func prepareNib() {
    let nib = UINib.init(nibName: "MovieCell", bundle: nil)
    self.moviesTableView.register(nib, forCellReuseIdentifier: "MovieCell")
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200 // this number comes from the loaded nib height
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movie = self.movies[indexPath.row]
    self.didSelectMovie(movie)
  }

}


// MARK: SingleMovie Caller protocol

extension MoviesViewController: SingleMovieCaller {
  
  func blur(alpha: CGFloat) {
    blurView?.alpha = alpha
  }
  
  func resetBlur() {
    blurView?.alpha = getOriginalBlur()
  }
  
  func getOriginalBlur() -> CGFloat {
    return 0.8
  }
  
  func loadBlur() {
    blurView = UIView(frame: self.view.frame)
    blurView?.backgroundColor = UIColor.black
    blurView?.alpha = getOriginalBlur()
    self.view.addSubview(blurView!)
  }
  
  func unLoadBlur() {
    self.blurView?.fadeOut()
    self.blurView?.removeFromSuperview()
    self.blurView = nil
  }

}

// MARK: refresh Control

extension MoviesViewController {
  
  func prepareRefreshControl() {
    refreshControl.tintColor = .clear
    refreshControl.backgroundColor = .clear
    
    moviesTableView.refreshControl = refreshControl
    
    refreshControl.addTarget(self, action: #selector(refreshMovies(_:)), for: .valueChanged)
    refreshView.setupWithSuperView(refreshControl)
  }
  
  
  @objc func refreshMovies(_ sender: Any) {
    interactor?.refreshMovies()
    self.moviesTableView.allowsSelection = false
  }

}
