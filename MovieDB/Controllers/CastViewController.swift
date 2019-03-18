//
//  CastViewController.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

protocol CastDisplay {
  func displayCast(_ cast: [CastTO])
  func displayError(_ msg: String)
}

class CastViewController: UIViewController {
  
  var interactor: CastInteractor?

  // MARK: Outlets
  @IBOutlet weak var castTableView: UITableView!
  
  // MARK: Setup
  var movieID: Int?
  var cast: [CastTO]?

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
    return cast?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CastCell") as! CastCell
    
    return cell
  }

}


// MARK: protocol implementation

extension CastViewController: CastDisplay {
  
  func displayCast(_ cast: [CastTO]) {
    logger.debug("displayCASTT")
  }
  
  func displayError(_ msg: String) {
    logger.error(msg)
  }

}
