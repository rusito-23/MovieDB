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
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  let errorView = ErrorView()
  let loadingView = LoadingView()

  // MARK: Constraint Outlets
  @IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
  
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
  
  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: view lifecycle
  private var originalY: CGFloat?
  override func viewDidLoad() {
    loading(true)
    self.interactor?.find(by: self.id)
    self.scrollView.delegate = self
    prepareSwipeGestures()
  }
  
  func loading(_ run: Bool) {
    if run {
      loadingView.setupWithSuperView(self.view)
    } else {
      loadingView.removeFromSuperview()
    }
  }
  
  func defineBackButton() {
    guard let image = self.posterView.image?
      .cropped(boundingBox: CGRect(x: 16, y: 0, width: 32, height: 32)) else { return }
    
    // change button color depending on background image
    if image.isDark, let clearImage = UIImage(named: "ic_arrow_back_white") {
      self.backButton.setImage(clearImage, for: .normal)
    } else if let darkImage = UIImage(named: "ic_arrow_back") {
      self.backButton.setImage(darkImage, for: .normal)
    }
    
  }
  
}

// MARK: protocol implementation
extension SingleMovieViewController: SingleMovieDisplay {
  
  func displayMovie(_ movie: Movies.ViewModel) {
    loading(false)
    
    titleView.text = movie.title
    descriptionView.text = movie.overview
    posterView.image = movie.poster
    
    defineBackButton()
  }
  
  func displayError(_ msg: String) {
    loading(false)
    self.errorView.errorMessage.text = msg
    self.errorView.setupForSuperView(self.view)
  }
  
}

// MARK: Swipe Gestures Controll

extension SingleMovieViewController {
  
  func prepareSwipeGestures() {
    
    originalY = self.view.center.y
    
    let posterPanGesture = UIPanGestureRecognizer(target: self, action: #selector(back))
    self.posterView.addGestureRecognizer(posterPanGesture)
  }
  
  //  MARK: swipe actions

  // function to let the user drag the view
  @objc func back(_ sender: UIPanGestureRecognizer) {
    // check if finished
    if sender.state == .ended {
      // if over the first half of the screen
      if self.view.center.y > UIScreen.main.bounds.height  {
        // perform segue
        self.performSegue(withIdentifier: "UnwindSegue", sender: self)
      } else {
        // set original center y
        UIView.animate(withDuration: 0.4, animations: {
          self.view.center.y = self.originalY ?? 333.5
          self.backButton.isHidden = false
        })
      }
    } else {
      let translation = sender.translation(in: self.view)
      guard translation.y > 0 else { return }
      
      // move the view
      self.backButton.isHidden = true
      self.view.center.y += translation.y
      sender.setTranslation(CGPoint.zero, in: self.view)
    }

  }

}

// MARK: UIScrollViewDelegate

extension SingleMovieViewController: UIScrollViewDelegate {
  
  // change poster size on scroll to let the user read the overview
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
    
    if actualPosition.y > 0 {
      if scrollView.contentOffset.y <= 10 {
        UIView.animate(withDuration: 0.4, animations: {
          self.posterHeightConstraint.constant = 300
          self.view.layoutSubviews()
        })
      }
    }else{
      UIView.animate(withDuration: 0.4, animations: {
        self.posterHeightConstraint.constant = 150
        self.view.layoutSubviews()
      })
    }
    
  }
  
}
