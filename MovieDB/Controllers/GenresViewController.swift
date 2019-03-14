//
//  GenresViewController.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 13/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

protocol GenresDisplay {
  func display(_ genres: [GenreTO])
  func error(_ msg: String)
}

protocol GenresDelegate {
  func onVisibilityChanged(_ visible: Bool)
  func onGenreSelected(_ genreID: Int)
}

class GenresViewController: UIView {
  
  var interactor: GenresInteractor?
  var delegate: GenresDelegate?
  var blurry: Blurry?

  // MARK: outlets
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var genresTableView: UITableView!
  
  // MARK: setup
  var genres: [GenreTO] = []
  var isVisible = false
  var originalX: CGFloat?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    customSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    customSetup()
  }
  
  func customSetup() {
    interactor = injector.resolve(GenresInteractor.self, argument: self as GenresDisplay)
    
    loadBundle()
    loadCellNib()
    interactor?.findAll()
  }
  
  private func loadCellNib() {
    let nib = UINib.init(nibName: "GenreCell", bundle: nil)
    self.genresTableView.register(nib, forCellReuseIdentifier: "GenreCell")
  }
  
  private func loadBundle() {
    Bundle.main.loadNibNamed("GenresView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  @IBAction func onBackButton(_ sender: Any) {
    self.slide(show: false)
  }

}


extension GenresViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return genres.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell") as! GenreCell
    let genre = genres[indexPath.row]
    
    cell.populate(genre)
    return cell
  }

}


// MARK: setup with superView

extension GenresViewController {
  
  func setupWithSuperView(_ superView: UIView) {
    
    // fixed width
    self.frame.size.width = 250
    // same height as subview
    self.frame.size.height = superView.frame.height
    // hide view on the right of superView
    self.frame.origin.x = super.frame.origin.x + superView.frame.width
    originalX = self.frame.origin.x

    // add self on top of superView navigation bar
    UIApplication.shared.keyWindow?.addSubview(self)
  }
  
  func showHide() {
    slide(show: !self.isVisible)
  }
  
  func slide(show: Bool) {
    
    if show {
      self.blurry?.loadBlur(blur: 0.3)
      UIView.animate(withDuration: 0.4, animations: { [weak self] in
        guard let `self` = self else { return }
        // show
        self.frame.origin.x -= self.frame.width
        self.isVisible = true
        self.delegate?.onVisibilityChanged(self.isVisible)
        
        // change blurry
        if let `originalX` = self.originalX {
          self.blurry?.blur(alpha: self.center.x.map(from: 0...originalX,
                                                         to: 0...1))
        }
      })
    } else {
      UIView.animate(withDuration: 0.4, animations: { [weak self] in
        guard let `self` = self else { return }
        // hide
        self.frame.origin.x += self.frame.width
        self.isVisible = false
        
        // change blurry
        if let `originalX` = self.originalX {
          self.blurry?.blur(alpha: 1 - self.center.x.map(from: 0...originalX,
                                                     to: 0...1))
        }
      }, completion: { _ in
        self.delegate?.onVisibilityChanged(self.isVisible)
        self.blurry?.unLoadBlur()
      })
    }
  }
  
}


//  MARK: protocol implementation

extension GenresViewController: GenresDisplay {
  
  func display(_ genres: [GenreTO]) {
    self.genres = genres
    self.genresTableView.reloadData()
  }
  
  func error(_ msg: String) {
    logger.error(msg)
  }

}
