//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSTableViewHeader.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation
import UIKit

class SCSTableViewHeader: UITableViewHeaderFooterView {
    
    static let reuseId = "SCSTableViewHeaderId"
    
    let titleLabel = UILabel(frame: CGRect(x: 25, y: 10, width: 0, height: 20))
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        titleLabel.frame = CGRect(x: 25, y: 10, width: frame.size.width, height: 20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor(red: 0.875, green: 0.878, blue: 0.886, alpha: 1.0)
        
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 10, width: 18, height: 20))
        imageView.image = UIImage(named: "RightArrow.png")
        
        addSubview(titleLabel)
        addSubview(imageView)
        
        contentView.backgroundColor = UIColor(red: 0.137, green: 0.141, blue: 0.149, alpha: 1.0)
        
    }
    
    func setupWithString(_ name: String) {
        titleLabel.text = name
        titleLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
