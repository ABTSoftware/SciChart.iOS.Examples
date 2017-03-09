//
//  MedicalHeartRateView.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 27/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class MedicalHeartRateView: UIView {

    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var heartIcon: UIImageView!
    
    func updateValue(value : Int) {
        heartRateLabel.text = String(value)
        heartBeatAnimation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func heartBeatAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 5,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.heartIcon.alpha = 1.0
                        self.superview?.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            UIView.animate(withDuration: 0.3,
                           delay: 0.1,
                           usingSpringWithDamping: 0.5, initialSpringVelocity: 5,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.heartIcon.alpha = 0.1
                            self.superview?.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                
            })
        })
    }
}
