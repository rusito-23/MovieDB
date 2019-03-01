//
//  CustomNavigationController.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 01/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit


class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    
    // show transparent background, with no separator
    self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationBar.shadowImage = UIImage()
  }
  
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    viewController.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic_arrow_back_white")
    viewController.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_arrow_back_white")
    
    let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    viewController.navigationItem.backBarButtonItem = item
  }

}
