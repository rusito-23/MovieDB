//
//  ViewController.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func exploreMovies(_ sender: Any) {
    self.performSegue(withIdentifier: "MoviesListSegue", sender: nil)
  }
  
}

