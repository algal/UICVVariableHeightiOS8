//
//  ViewController.swift
//  UICVVariableHeightiOS8
//
//  Created by Alexis Gallagher on 2014-10-13.
//  Copyright (c) 2014 AlexisGallagher. All rights reserved.
//

import UIKit

//let items = [
//  "Pharetra Dapibus Ornare Sollicitudin Risus",
////  "Ultricies Pellentesque",
////  "Integer posuere erat a ante venenatis dapibus posuere velit aliquet.",
////  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper nulla non metus auctor fringilla. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.",
////  "ciao bello",
//]
//
let itemsAll = Model().dataArray.map({ $0.body })
let items = [itemsAll[0]]

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
  private let sizingCell:MyCell = MyCell(frame: CGRectMake(0, 0, 50, 50))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView?.registerClass(MyCell.self, forCellWithReuseIdentifier: MyCell.classReuseIdentifier)
  }
  
  // MARK: - UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MyCell.classReuseIdentifier, forIndexPath: indexPath) as! MyCell
    cell.label.text = items[indexPath.row]
    
//    cell.frame = CGRect(origin: cell.frame.origin, size: CGSize(width: collectionView.bounds.size.width, height: 50))
    return cell
  }

  // MARK: - UICollectionViewDelegateFlowLayout
  
  /*
  In its capacity as the UICollectionViewDelegateFlowLayout, the view controller
  supplies sizes for cells.
  
  But we want the cells to be responsible for handling their own layout and sizing.
  
  So we ask a cell to compute the sizing for us.
  
  Since sizing depends on content, we actually need to populate a cell with content before we can
  ask it to compute its size.
  
  Since this is a delegate layout method, it is not given a real cell to configure. It's only
  supposed to be supplying sizes. So how do we get the cell to use for calculating the size?
  
  We use a "sizing cell", a cell that is never displayed, and that we hold onto only for the purposes
  of doing layout calculations. 
  
  PROS: this lets us keep layout configurations in cell code, using AL.
  CONS: this means we are performing layout calculations twice per cell.
  
  */
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
  {
    NSLog("ENTRY: collectionView(collectionView:layout:sizeForItemAtIndexPath) called for indexPath=%@",indexPath.description)
    // NOTE: here is where we say we want cells to use the width of the collection view
    let requiredWidth = collectionView.bounds.size.width

    // NOTE: here is where we ask our sizing cell to compute what height it needs
    self.sizingCell.label.text = items[indexPath.row]
    let adequateSize = self.sizingCell.preferredLayoutSizeFittingWidth(requiredWidth)
    NSLog("EXIT: collectionView(collectionView:layout:sizeForItemAtIndexPath) returning size = %@",NSStringFromCGSize(adequateSize))
    return adequateSize
  }
}

