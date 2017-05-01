//
//  SCSTableViewHeader.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 4/27/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

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
