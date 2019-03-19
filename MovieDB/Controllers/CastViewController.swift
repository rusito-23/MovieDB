//
//  CastViewController.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

protocol CastDisplay {
  func displayCast(_ cast: [Casts.ViewModel])
  func displayError(_ msg: String)
}

class CastViewController: UIViewController {
  
  var interactor: CastInteractor?

  // MARK: Outlets
  @IBOutlet weak var castTableView: UITableView!
  
  // MARK: Setup
  var movieID: Int?
  var cast: [Casts.ViewModel] = []

  // MARK: lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    interactor = injector.resolve(CastInteractor.self, argument: self as CastDisplay)
    interactor?.findAll(for: movieID)
  }
  
}

// MARK: table control

extension CastViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cast.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CastCell") as! CastCell
    let character = cast[indexPath.row]
    cell.populate(with: character)
    return cell
  }

}


// MARK: protocol implementation

extension CastViewController: CastDisplay {
  
  func displayCast(_ cast: [Casts.ViewModel]) {
    logger.debug(cast)
    self.cast = cast
    self.castTableView.reloadData()
  }
  
  func displayError(_ msg: String) {
    logger.error(msg)
  }

}
