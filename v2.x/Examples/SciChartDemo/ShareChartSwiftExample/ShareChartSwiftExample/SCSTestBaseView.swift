//
//  SCSTestBaseView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 1/3/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit

class SCSTestBaseView: UIView, SCSSpeedTestProtocol {

    var delegate: SCSDrawingProtocolDelegate?
    var chartProviderName: String = "SciChart"

    // MARK: SpeedTestProtocol
    
    func run(_ testParameters: SCSTestParameters) {

    }
    
    func updateChart() {
        
    }
    
    func stop() {
        if let delegate = delegate {
            delegate.processCompleted()
        }
    }
    
}
