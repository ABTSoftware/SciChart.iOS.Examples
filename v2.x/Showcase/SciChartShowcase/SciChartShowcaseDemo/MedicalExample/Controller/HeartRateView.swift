//
//  MedicalHeartRateView.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 27/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class HeartRateView: UIView {

    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var widthIconConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightIconConstraint: NSLayoutConstraint!
    
    func updateValue(value : Int) {
        heartRateLabel.text = String(value)
        heartBeatAnimation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configStyle()
    }
    
    private func configStyle() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(red: 217.0/255.0, green: 217.0/255.0, blue: 193.0/255.0, alpha: 1.0).cgColor
    }
    
    func heartBeatAnimation() {
        let contantImageSize = self.widthIconConstraint.constant;
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.heartIcon.alpha = 1.0
                        self.widthIconConstraint.constant += contantImageSize*0.1
                        self.heightIconConstraint.constant += contantImageSize*0.1
                        
                        
        }, completion: { (finished) -> Void in
            if (finished) {
                UIView.animate(withDuration: 0.4,
                               delay: 0.0,
                               usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,
                               options: UIViewAnimationOptions.curveEaseIn,
                               animations: { () -> Void in
                                self.heartIcon.alpha = 0.1
                                self.widthIconConstraint.constant -= contantImageSize*0.1
                                self.heightIconConstraint.constant -= contantImageSize*0.1
                }, completion: { (finished) -> Void in
                    
                })
            }
        })
    }
}
