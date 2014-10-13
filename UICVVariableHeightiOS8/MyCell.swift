//
//  MyCell.swift
//  UICVVariableHeightiOS8
//
//  Created by Alexis Gallagher on 2014-10-13.
//  Copyright (c) 2014 AlexisGallagher. All rights reserved.
//

import UIKit

class MyCell: UICollectionViewCell {
  
  let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

  class func classReuseIdentifier() -> NSString { return "MyCell" }
  
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
  
//  override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes!
//  {
//    var attrs:UICollectionViewLayoutAttributes = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
//
////    let newSize = self.preferredLayoutSizeFittingSize(attrs.size)
//    let newSize = self.preferredLayoutSizeFittingSize(CGSizeMake(200, attrs.size.height))
//    let newSizeString = NSStringFromCGSize(newSize)
//    NSLog(newSizeString)
//    attrs.size  = newSize
//    return attrs
//  }
  
  
  /*
  Computes the size the cell will need to to fit within targetSize.
  
  targetSize should be used to pass in a width.

  the returned size will have the same width, and the height which is
  calculated by Auto Layout so that the contents of the cell (i.e., text in the label)
  can fit within that width.

  */
  func preferredLayoutSizeFittingSize(targetSize:CGSize) -> CGSize {
    
    // save original frame and preferredMaxLayoutWidth
    let originalFrame = self.frame
    let originalPreferredMaxLayoutWidth = self.label.preferredMaxLayoutWidth
    
    // assert: targetSize.width has the required width of the cell
    
    // step1: set the cell.frame to use that width
    var frame = self.frame
    frame.size = targetSize
    self.frame = frame

    // step2: layout the cell
    self.setNeedsLayout()
    self.layoutIfNeeded()
    self.label.preferredMaxLayoutWidth = self.label.bounds.size.width
    
    // assert: the cell.label.bounds.size.width has now been set to the width required by the cell.bounds.size.width

    // step3: compute how tall the cell needs to be
    
    // this causes the cell to compute the height it needs, which it does by asking the 
    // label what height it needs to wrap within its current bounds (which we just set).
    // (note that the label is getting its wrapping width from its bounds, not preferredMaxLayoutWidth)
    let computedSize = self.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    NSLog(NSStringFromCGSize(computedSize))
    // assert: computedSize has the needed height for the cell

    // Apple: "Only consider the height for cells, because the contentView isn't anchored correctly sometimes."
    let newSize = CGSize(width:targetSize.width,height:computedSize.height)

    // restore old frame
    self.frame = originalFrame
    self.label.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth
    return newSize
  }
}
