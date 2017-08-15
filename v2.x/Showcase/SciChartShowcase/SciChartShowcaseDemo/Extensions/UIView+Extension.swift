//
//  UIView+Extension.swift
//
//  Created by Bishal Ghimire on 4/30/16.
//  Copyright © 2016 Bishal Ghimire. All rights reserved.
//

import UIKit

//
// Inspectable - Design and layout for View
// cornerRadius, borderWidth, borderColor
//

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
    
}

////
//// View for UILabel Accessory
////
//
//extension UIView {
//    
//    func rightValidAccessoryView() -> UIView {
//        let imgView = UIImageView(image: UIImage(named: "check_valid"))
//        imgView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        imgView.backgroundColor = UIColor.clearColor()
//        return imgView
//    }
//    
//    func rightInValidAccessoryView() -> UIView {
//        let imgView = UIImageView(image: UIImage(named: "check_invalid"))
//        imgView.frame = CGRect(x: self.cornerRadius, y: self.cornerRadius, width: 20, height: 20)
//        imgView.backgroundColor = UIColor.clearColor()
//        return imgView
//    }
//    
//}
