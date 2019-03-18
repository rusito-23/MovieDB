//
//  Actions.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 18/03/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class ActionsCollectionView: UICollectionView {

  var actions: [Action] = [] {
    didSet {
      self.reloadData()
    }
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    customSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    customSetup()
  }
  
  private func customSetup() {
    self.delegate = self
    self.dataSource = self
  }
  
}

extension ActionsCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  
  // MARK: ActionCollection: DATA SOURCE
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.actions.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell", for: indexPath) as! ActionCollectionViewCell
    
    let action = self.actions[indexPath.row]
    cell.populate(action)
    
    return cell
  }
  
  // Center the collection view content
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    let cellWidth: CGFloat = flowLayout.itemSize.width
    let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
    let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
    var collectionWidth = collectionView.frame.size.width
    if #available(iOS 11.0, *) {
      collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
    }
    let totalWidth = cellWidth * cellCount + cellSpacing * (cellCount - 1)
    if totalWidth <= collectionWidth {
      let edgeInset = (collectionWidth - totalWidth) / 2
      return UIEdgeInsets(top: flowLayout.sectionInset.top, left: edgeInset, bottom: flowLayout.sectionInset.bottom, right: edgeInset)
    } else {
      return flowLayout.sectionInset
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let action = self.actions[indexPath.row]
    action.action()
  }

}
