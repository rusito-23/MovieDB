//
//  FloatingMenu.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 21/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

enum MenuOption: String {
  case OPTION0
  case OPTION1
  case OPTION2
}

class FloatingMenu: UIView {

  //  MARK: Outlets
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var showButton: FloatingButton!
  
  @IBOutlet weak var menuOptionContainer: UIView!
  @IBOutlet weak var menuOption0: FloatingButton!
  @IBOutlet weak var menuOption1: FloatingButton!
  @IBOutlet weak var menuOption2: FloatingButton!
  
  var delegate: FloatingMenuDelegate?
  
  //   MARK: setup
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    customSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    customSetup()
  }
  
  private func customSetup() {
    loadBundle()
    self.menuOptionContainer.isHidden = true
  }
  
  private func loadBundle() {
    Bundle.main.loadNibNamed("FloatingMenu", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  //  MARK: IBActions

  @IBAction func onShowButton(_ sender: Any) {
    hideUnhide(view: self.menuOptionContainer)
  }
  
  @IBAction func onMenuOption(_ sender: Any) {
    hideUnhide(view: self.menuOptionContainer)

    guard let delegate = self.delegate else {
      return
    }
    
    let button = sender as! FloatingButton
    var option: MenuOption = .OPTION0
    
    if button == self.menuOption0 {
      option = .OPTION0
    } else if button == self.menuOption1 {
      option = .OPTION1
    } else if button == self.menuOption2 {
      option = .OPTION2
    }
    
    delegate.onMenuOption(option)
  }
  
  //  MARK: UI logic
  
  func hideUnhide(view: UIView) {
    if view.isHidden {
      view.fadeIn()
    } else {
      view.fadeOut()
    }
  }
}

protocol FloatingMenuDelegate {
  func onMenuOption(_ option: MenuOption)
}
