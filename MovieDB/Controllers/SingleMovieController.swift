//
//  SingleMovieController.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 19/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit
import XCDYouTubeKit
import ToastSwiftFramework

// MARK: Display protocol

protocol SingleMovieDisplay: class {
  func displayMovie(_ movie: Movies.ViewModel)
  func displayError(_ msg: String)
  func displayTrailer(_ id: String)
  func displayTrailerError(_ msg: String)
}


// MARK: view Controller implementation

class SingleMovieViewController: UIViewController {
  
  var interactor: SingleMovieInteractor?
  
  // MARK: Outlets
  
  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var descriptionView: UITextView!
  @IBOutlet weak var posterView: UIImageView!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var actionsCollectionView: ActionsCollectionView!
  
  // MARK: Constraint Outlets
  
  @IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
  
  // MARK: Setup
  
  private var originalY: CGFloat = 333.5
  var id: Int?
  var blurry: Blurry?
  let errorView = ErrorView()
  let loadingView = LoadingView()
  var trailerPlayer = TrailerYTPlayer()
  
  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: view lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loading(true)
    self.interactor = injector.resolve(SingleMovieInteractor.self, argument: self as SingleMovieDisplay)
    self.interactor?.find(by: self.id)
    
    // delegations
    self.scrollView.delegate = self
    self.errorView.delegate = self
    
    // setup
    prepareSwipeGestures()
    prepareActions()
  }
  

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    dismissVideoPlayer()
  }
  
}

// MARK: UI logic

extension SingleMovieViewController {

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
    logger.error(msg)
    loading(false)
    self.errorView.errorMessage.text = msg
    self.errorView.setupForSuperView(self.view)
  }
  
  func displayTrailer(_ id: String) {
    loadingTrailer(false)
    trailerPlayer.play(videoID: id, superView: posterView, errorCompletion: displayTrailerError)
  }
  
  func displayTrailerError(_ msg: String) {
    loadingTrailer(false)
    trailerPlayer.removeFromSuperview()
    self.view.makeToast(msg)
  }

}

// MARK: Swipe Gestures Controll

extension SingleMovieViewController {
  
  func prepareSwipeGestures() {
    originalY = self.view.center.y
    
    let posterPanGesture = UIPanGestureRecognizer(target: self, action: #selector(dragPosterView))
    let trailerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(dragPosterView))
    trailerPanGesture.delegate = self

    self.posterView.addGestureRecognizer(posterPanGesture)
    self.trailerPlayer.addGestureRecognizer(trailerPanGesture)
  }
  
  //  MARK: swipe actions

  // function to let the user drag the view
  @objc func dragPosterView(_ sender: UIPanGestureRecognizer) {
    // check if finished
    if sender.state == .ended {
      // if over the first half of the screen
      if self.view.center.y > UIScreen.main.bounds.height  {
        // perform segue
        self.performSegue(withIdentifier: "UnwindSegue", sender: self)
      } else {
        // set original center y
        UIView.animate(withDuration: 0.4, animations: {
          self.view.center.y = self.originalY
          self.backButton.isHidden = false
        })
        // reset caller blur
        blurry?.resetBlur()
      }
    } else {
      let translation = sender.translation(in: self.view)
      guard self.view.center.y > (originalY) - 5 else { return }
      
      // move the view
      self.backButton.isHidden = true
      self.view.center.y += translation.y
      sender.setTranslation(CGPoint.zero, in: self.view)
      
      // unblur/blur the caller ViewController
      blurry?.blur(alpha: 1 - self.view.center.y.map(from: originalY...UIScreen.main.bounds.height * 2,
                                                 to: 0...(blurry?.getOriginalBlur() ?? 1)))
    }

  }

}

// delegate for trailerView pan gesture
extension SingleMovieViewController: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
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
          self.errorView.frame.size.height = 300
          self.trailerPlayer.frame.size.height = 300
          self.view.layoutSubviews()
        })
      }
    }else{
      UIView.animate(withDuration: 0.4, animations: {
        self.posterHeightConstraint.constant = 150
        self.errorView.frame.size.height = 150
          self.trailerPlayer.frame.size.height = 150
        self.view.layoutSubviews()
      })
    }
    
  }
  
}

// MARK: extension for video handling

extension SingleMovieViewController {
  
  func dismissVideoPlayer() {
    trailerPlayer.removeFromSuperview()
  }
  
  func loadingTrailer(_ run: Bool) {
    if run {
      loadingView.setupWithSuperView(self.posterView)
      dismissVideoPlayer()
    } else {
      loadingView.removeFromSuperview()
    }
  }

  @objc func onTrailerFinished() {
    logger.verbose("trailer finished")
    dismissVideoPlayer()
  }

}


// MARK: extension for errorViewDelegate
extension SingleMovieViewController: ErrorViewDelegate {
  
  @objc func errorBackButtonPressed() {
    self.performSegue(withIdentifier: "UnwindSegue", sender: self)
  }
  
}

// MARK: actions

extension SingleMovieViewController {
  
  func prepareActions() {
    actionsCollectionView.actions = [
      Action(name: "Watch trailer", icon: "ic_play", action: self.playTrailer),
      Action(name: "Explore cast", icon: "ic_cast", action: self.exploreCast),
      Action(name: "Genres", icon: "ic_genres", action: self.genres),
    ]
  }
  
  func playTrailer() {
    loadingTrailer(true)
    self.interactor?.fetchTrailer(id: self.id)
  }
  
  func exploreCast() {
    logger.warning("Explore cast has no implementation")
  }
  
  func genres() {
    logger.warning("Genres is not yet implemented")
  }

}
