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

class GenresViewController: UIView {
  
  var interactor: GenresInteractor?
  
  // MARK: outlets
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var genresTableView: UITableView!
  
  // MARK: setup
  var genres: [GenreTO] = []
  
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
    
    // TODO: add the view
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
