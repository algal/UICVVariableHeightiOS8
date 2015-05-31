//
//  MyCell.swift
//  UICVVariableHeightiOS8
//
//  Created by Alexis Gallagher on 2014-10-13.
//  Copyright (c) 2014 AlexisGallagher. All rights reserved.
//

import UIKit

class MyCell: UICollectionViewCell
{
  
  let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

  override class func requiresConstraintBasedLayout() -> Bool { return true }
  
  class var classReuseIdentifier : String { return "MyCell" }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.label.numberOfLines = 0
    
    self.label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(self.label)
    self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: nil, metrics: nil, views: ["label":self.label]))
    self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label]-|", options: nil, metrics: nil, views: ["label":self.label]))

    self.backgroundColor = UIColor.grayColor() // seeing gray => Apple bug.
    self.contentView.backgroundColor = UIColor.greenColor()
    self.label.backgroundColor = UIColor.yellowColor()
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  /*
  Computes the size the cell needs to be, if it must be a given width
  
  @param targetWidth width the cell must be

  the returned size will have the same width, and the height which is
  calculated by Auto Layout so that the contents of the cell (i.e., text in the label)
  can fit within that width.

  */
  func preferredLayoutSizeFittingWidth(targetWidth:CGFloat) -> CGSize {
    NSLog("MyCell.preferredLayoutSizeFittingSize(targetSize:):ENTRY: called with targetWidth=%@", NSNumber(float: Float(targetWidth)))
    // save original frame and preferredMaxLayoutWidth of the 
    let originalFrame = self.frame
    let originalPreferredMaxLayoutWidth = self.label.preferredMaxLayoutWidth
    
    // assert: targetSize.width has the required width of the cell
    
    // step1: set the cell.frame to use that width, and an excessive height
    var frame = self.frame
    frame.size = CGSize(width: targetWidth, height: 30000)
    self.frame = frame

    // step2: layout the cell's subviews, based on the required width and excessive height
    NSLog("MyCell.preferredLayoutSizeFittingWidth(targetWidth:): about to call layoutIfNeeded on the sizing cell")
    self.setNeedsLayout()
    self.layoutIfNeeded()
    self.label.preferredMaxLayoutWidth = self.label.bounds.size.width
    
    // assert: the cell.label.bounds.size.width has now been set to the width required by the cell.bounds.size.width

    // step3: compute how tall the cell needs to be
    
    // this causes the cell to compute the height it needs, which it does by asking the 
    // label what height it needs to wrap within its current bounds (which we just set).
    // (note that the label is getting its wrapping width from its bounds, not preferredMaxLayoutWidth)
    NSLog("MyCell.preferredLayoutSizeFittingSize(targetSize:): about to call systemLayoutSizeFittingSize on the sizing cell")
    let computedSize = self.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    // assert: computedSize has the needed height for the cell

    // Apple: "Only consider the height for cells, because the contentView isn't anchored correctly sometimes."
    let newSize = CGSize(width:targetWidth,height:computedSize.height)

    // restore old frame
    self.frame = originalFrame
    self.label.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth
    
    NSLog("MyCell.preferredLayoutSizeFittingSize(targetSize:): EXIT: returning size=%@",NSStringFromCGSize(newSize))
    return newSize
  }
}
