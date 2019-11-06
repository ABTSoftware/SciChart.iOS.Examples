//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddPointsPerformanceChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class AddPointsPerformanceChartView: AddPointsPerformanceLayout {
    
    override func commonInit() {
        weak var wSelf = self
        self.append10K = { wSelf?.appendPoints(10000) }
        self.append100K = { wSelf?.appendPoints(100000) }
        self.append1Mln = { wSelf?.appendPoints(1000000) }
        self.clear = { wSelf?.clearSeries() }
    }
    
    override func initExample() {
        surface.xAxes.add(SCINumericAxis())
        surface.yAxes.add(SCINumericAxis())
        surface.chartModifiers.add(ExampleViewBase.createDefaultModifiers())
    }

    fileprivate func appendPoints(_ count: Int32) {
        let SCDDoubleSeries = SCDRandomWalkGenerator().setBias(randf(0.0, 1.0) / 100).getRandomWalkSeries(count)
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.append(x: SCDDoubleSeries.xValues, y: SCDDoubleSeries.yValues)
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeStyle = SCISolidPenStyle(color: UIColor.init(red: CGFloat(randf(0, 1)), green: CGFloat(randf(0, 1)), blue: CGFloat(randf(0, 1)), alpha: CGFloat(randf(0, 1))), thickness: 1)
        
        surface.renderableSeries.add(rSeries)
        surface.animateZoomExtents(0.5)
    }
    
    fileprivate func clearSeries() {
        surface.renderableSeries.clear()
    }
}
