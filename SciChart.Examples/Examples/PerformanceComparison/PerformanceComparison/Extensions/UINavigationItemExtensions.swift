// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UINavigationItemExtensions.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit

// Might be not the best solution, but it works though
extension UINavigationItem {
    @objc func setTwoLineTitle(lineOne: String, lineTwo: String) {
        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
        let subtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]
        
        let title: NSMutableAttributedString = NSMutableAttributedString(string: lineOne, attributes: titleParameters)
        let subtitle: NSAttributedString = NSAttributedString(string: lineTwo, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: title.size().width, height: CGFloat(44)))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        titleView = titleLabel
    }
}
