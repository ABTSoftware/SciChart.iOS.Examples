//
//  DividerView.swift
//  SciChartShowcaseDemo
//
//  Created by Gkol on 7/29/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

class DividerView: UIView {
 
    @IBOutlet weak var dividerAbove: DividerView?
    @IBOutlet weak var dividerBelow: DividerView?
    @IBOutlet var relationConstraint : NSLayoutConstraint!
    var minViewHeight : CGFloat = 100.0

    private var originTopViewHeight: CGFloat = 0.0
    private var originBottomViewHeight: CGFloat = 0.0
    private var originRelationConstraintConstant: CGFloat = 0.0
    private var originRelationBelowConstraintConstant: CGFloat = 0.0
    private var originRelationAboveConstraintConstant: CGFloat = 0.0
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        
        let locationPan = sender.translation(in: nil)
        
        switch sender.state {
            
        case .began:
            
            if let below = dividerBelow {
                originRelationBelowConstraintConstant = below.relationConstraint.constant
            }
            if let above = dividerAbove {
                originRelationAboveConstraintConstant = above.relationConstraint.constant
            }
            
            if let topView = relationConstraint.firstItem as? UIView {
                originTopViewHeight = topView.frame.size.height
            }
            if let bottomView = relationConstraint.secondItem as? UIView {
                originBottomViewHeight = bottomView.frame.size.height
            }
            originRelationConstraintConstant = relationConstraint.constant
            break
        case .changed:
            if locationPan.y > 0  {
                if originBottomViewHeight - locationPan.y > minViewHeight {
                    relationConstraint.constant = originRelationConstraintConstant+locationPan.y*(relationConstraint.multiplier+1)
                    if let below = dividerBelow {
                        below.relationConstraint.constant = originRelationBelowConstraintConstant-locationPan.y
                    }
                    if let above = dividerAbove {
                        above.relationConstraint.constant = originRelationAboveConstraintConstant-locationPan.y*above.relationConstraint.multiplier
                    }
                }
                
            }
            else {
                if originTopViewHeight + locationPan.y > minViewHeight {
                    relationConstraint.constant = originRelationConstraintConstant+locationPan.y*(relationConstraint.multiplier+1)
                    if let below = dividerBelow {
                        below.relationConstraint.constant = originRelationBelowConstraintConstant-locationPan.y
                    }
                    if let above = dividerAbove {
                        above.relationConstraint.constant = originRelationAboveConstraintConstant-locationPan.y*above.relationConstraint.multiplier
                    }
                }
            }
            break
        default:
            break
            
        }

    }
    
}
