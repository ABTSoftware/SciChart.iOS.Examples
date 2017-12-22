//
//  ViewController.swift
//  CustomLegend
//
//  Created by Gkol on 12/22/17.
//  Copyright © 2017 Gkol. All rights reserved.
//

import UIKit
import SciChart

class CustomLegendViewCell: UIView, SCILegendItemViewProtocol {
    
    var checkActionHandler: SCILegendCheckAction?
    @IBOutlet weak var legendItemLabel: UILabel!
    
    static func nibName() -> String? {
        return "CustomLegendViewCell"
    }
    
    func setup(with item: SCILegendItem) {
        legendItemLabel.text = item.seriesName
    }
    
}

class ViewController: UIViewController {

    @IBOutlet weak var surface: SCIChartSurface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surface.xAxes.add(SCINumericAxis())
        surface.yAxes.add(SCINumericAxis())
        
        initializeSurfaceRenderableSeries()
        
        let legend = SCILegendModifier(position: [.top, .left], andOrientation: .vertical)
        legend?.cellClass = CustomLegendViewCell.self
        surface.chartModifiers.add(legend!)
        
    }
    
    func initializeSurfaceRenderableSeries() {
        self.attachRenderebleSeriesWithYValue(1000, andColor: UIColor.yellow, seriesName: "Curve A", isVisible: true)
        self.attachRenderebleSeriesWithYValue(2000, andColor: UIColor.green, seriesName: "Curve B", isVisible: true)
        self.attachRenderebleSeriesWithYValue(3000, andColor: UIColor.red, seriesName: "Curve C", isVisible: true)
        self.attachRenderebleSeriesWithYValue(4000, andColor: UIColor.blue, seriesName: "Curve D", isVisible: false)
    }
    
    func attachRenderebleSeriesWithYValue(_ yValue: Double, andColor color: UIColor, seriesName: String, isVisible: Bool) {
        let dataCount = 10
        let dataSeries1 = SCIXyDataSeries(xType: .float, yType: .float)
        var y = yValue
        var i = 1
        while i <= dataCount {
            let x = i
            y = yValue + y
            dataSeries1.appendX(SCIGeneric(x), y: SCIGeneric(y))
            i += 1
        }
        dataSeries1.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        dataSeries1.seriesName = seriesName
        let renderableSeries1 = SCIFastLineRenderableSeries()
        renderableSeries1.strokeStyle = SCISolidPenStyle(color: color, withThickness: 0.7)
        renderableSeries1.dataSeries = dataSeries1
        renderableSeries1.isVisible = isVisible
        renderableSeries1.addAnimation(SCIDrawLineRenderableSeriesAnimation(duration: 3, curveAnimation: SCIAnimationCurveEaseOut))
        surface.renderableSeries.add(renderableSeries1)
        
    }

}

