//
//  DashboardExampleViewController.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 2/24/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit

class DashboardExampleViewController: BaseViewController {

    @IBOutlet weak var chartSurface: SCIChartSurface!
    
    let renderableSeries: SCIFastLineRenderableSeries = SCIFastLineRenderableSeries()
    let renderableSeries_2: SCIFastLineRenderableSeries = SCIFastLineRenderableSeries()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        let xAxis = SCINumericAxis()
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .never
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(0.4), max: SCIGeneric(0.96))
        chartSurface.yAxes.add(yAxis)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        renderableSeries_2.strokeStyle = SCISolidPenStyle(color: .strokeRSIColor(), withThickness: 1.0)
      
        DataManager.getHeartRateData {[unowned self] (dataSeries, error) in
            DataManager.getBloodPressureData(with: {[unowned self] (dataSeries_2, error_2) in
                self.renderableSeries.dataSeries = dataSeries
                self.chartSurface.renderableSeries.add(self.renderableSeries)
                
                self.renderableSeries_2.dataSeries = dataSeries_2
                self.chartSurface.renderableSeries.add(self.renderableSeries_2)
            
            })
        }
        

    }
    
}
