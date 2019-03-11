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

// MARK: Caller protocol
protocol SingleMovieCaller {
  func blur(alpha: CGFloat)
  func resetBlur()
  func getOriginalBlur() -> CGFloat
}


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

  // MARK: Constraint Outlets
  
  @IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
  
  // MARK: Setup
  
  private var originalY: CGFloat = 333.5
  var id: Int?
  var caller: SingleMovieCaller?
  let errorView = ErrorView()
  let loadingView = LoadingView()
  var videoPlayer: XCDYouTubeVideoPlayerViewController?
  
  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: view lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loading(true)
    self.interactor = injector.resolve(SingleMovieInteractor.self, argument: self)
    self.interactor?.find(by: self.id)
    
    self.scrollView.delegate = self
    prepareSwipeGestures()
    
    NotificationCenter.default.addObserver(self, selector: #selector(onTrailerFinished), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil)
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
    
    videoPlayer = XCDYouTubeVideoPlayerViewController.init(videoIdentifier: id)
    videoPlayer?.present(in: self.posterView)
    videoPlayer?.moviePlayer.play()
  }
  
  func displayTrailerError(_ msg: String) {
    loadingTrailer(false)
    self.errorView.errorMessage.text = msg
    self.errorView.setupForSuperView(self.posterView)
  }

}

// MARK: Swipe Gestures Controll

extension SingleMovieViewController {
  
  func prepareSwipeGestures() {
    originalY = self.view.center.y
    
    let posterPanGesture = UIPanGestureRecognizer(target: self, action: #selector(dragPosterView))
    self.posterView.addGestureRecognizer(posterPanGesture)
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
        caller?.resetBlur()
      }
    } else {
      let translation = sender.translation(in: self.view)
      guard self.view.center.y > (originalY) - 5 else { return }
      
      // move the view
      self.backButton.isHidden = true
      self.view.center.y += translation.y
      sender.setTranslation(CGPoint.zero, in: self.view)
      
      // unblur/blur the caller ViewController
      caller?.blur(alpha: 1 - self.view.center.y.map(from: originalY...UIScreen.main.bounds.height * 2,
                                                 to: 0...(caller?.getOriginalBlur() ?? 1)))
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
          self.errorView.frame.size.height = 300
          self.view.layoutSubviews()
        })
      }
    }else{
      UIView.animate(withDuration: 0.4, animations: {
        self.posterHeightConstraint.constant = 150
          self.errorView.frame.size.height = 150
        self.view.layoutSubviews()
      })
    }
    
  }
  
}

// MARK: extension for video handling

extension SingleMovieViewController {
  
  func dismissVideoPlayer() {
    self.videoPlayer?.moviePlayer.stop()
    self.videoPlayer?.removeFromParent()
    self.videoPlayer?.moviePlayer.view.removeFromSuperview()
  }
  
  func loadingTrailer(_ run: Bool) {
    if run {
      loadingView.setupWithSuperView(self.posterView)
      dismissVideoPlayer()
    } else {
      loadingView.removeFromSuperview()
    }
  }
  
  @IBAction func playTrailer() {
    loadingTrailer(true)
    self.interactor?.fetchTrailer(id: self.id)
  }
  
  @objc func onTrailerFinished() {
    logger.verbose("trailer finished")
    dismissVideoPlayer()
  }

}
