//
//  ViewController.swift
//  HavingFunWithSciChart
//
//  Created by Yaroslav Pelyukh on 31/01/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class ViewController: UIViewController {
    
    var chartView: SCIChartSurfaceView?
    var chartSurface: SCIChartSurface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        chartView = SCIChartSurfaceView(frame: self.view.bounds)
        chartView?.translatesAutoresizingMaskIntoConstraints = true
        
        if let chartSurfaceView = chartView {
            self.view.addSubview(chartSurfaceView)
            
            chartSurface = SCIChartSurface(view: chartSurfaceView)
            
            chartSurface?.xAxes.add(SCINumericAxis())
            chartSurface?.yAxes.add(SCINumericAxis())
            
            chartSurface?.invalidateElement()
        }
    }
}
