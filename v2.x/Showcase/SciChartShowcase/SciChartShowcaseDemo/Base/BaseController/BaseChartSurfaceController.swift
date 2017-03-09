//
//  BaseChartSurfaceController.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybenuik Mykola on 2/23/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart
import UIKit

open class BaseChartSurfaceController {
    
    weak var chartView : SCIChartSurfaceView!
    
    let chartSurface : SCIChartSurface

    init(_ view: SCIChartSurfaceView) {
        
        chartSurface = SCIChartSurface(view: view)
        chartView = view
        
    }
    
}

