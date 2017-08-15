//
//  BaseViewController.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 2/24/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    
    weak var loadingView : UIVisualEffectView?
    weak var activityIndicator : UIActivityIndicatorView?
    
    
    func startLoading() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        blurView.contentView.addSubview(indicator)
        
        
        blurView.frame = CGRect(origin: CGPoint() , size: view.frame.size)
        
        view.addSubview(blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = true
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        indicator.center = blurView.center
        indicator.translatesAutoresizingMaskIntoConstraints = true
        indicator.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        indicator.startAnimating()
        loadingView = blurView
        activityIndicator = indicator
        
    }
    
    func stopLoading() {
        
        if let indicator = activityIndicator {
            indicator.stopAnimating()
        }
        
        if let blurView = loadingView {
            blurView.removeFromSuperview()
        }
        
    }
    
    
}
