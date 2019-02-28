//
//  SingleMovieController.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 19/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

// MARK: Display protocol

protocol SingleMovieDisplay: class {
  func displayMovie(_ movie: Movies.ViewModel)
  func displayError(_ msg: String)
}


// MARK: view Controller implementation

class SingleMovieViewController: UIViewController {
  
  var interactor: SingleMovieBusiness?
  
  //  MARK: self variables
  var id: Int?

  // MARK: Outlets
  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var descriptionView: UITextView!
  @IBOutlet weak var posterView: UIImageView!
  @IBOutlet weak var errorView: ErrorView!

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
  
  private func setup()
  {
    let interactor = SingleMovieInteractor()
    let presenter = SingleMoviePresenter()
    self.interactor = interactor
    interactor.presenter = presenter
    presenter.viewController = self
  }

  // MARK: view lifecycle
  override func viewDidLoad() {
    self.interactor?.find(by: self.id)
    self.prepareLongPress()
  }
  
  //  MARK: UI Logic
  // TODO: this could belong to another class??
  
  func prepareLongPress() {
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
    longPress.minimumPressDuration = 0.2

    self.posterView.addGestureRecognizer(longPress)
  }
  
  @objc func onLongPress(_ sender: UILongPressGestureRecognizer) {
    
    if (sender.state != .ended) {
      
      self.posterView.center = sender.location(in: self.view)

    } else {
      self.performSegue(withIdentifier: "UnwindSegue", sender: self)
    }
    
  }

}

// MARK: protocol implementation
extension SingleMovieViewController: SingleMovieDisplay {
  
  func displayMovie(_ movie: Movies.ViewModel) {
    titleView.text = movie.title
    descriptionView.text = movie.overview
    posterView.image = movie.poster
  }
  
  func displayError(_ msg: String) {
    self.titleView.isHidden = true
    self.descriptionView.isHidden = true
    
    self.errorView.errorMessage.text = msg
    self.errorView.isHidden = false
  }
  
}
