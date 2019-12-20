//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddRemoveSeriesChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class AddRemoveSeriesChartView: AddRemoveSeriesChartLayout {

    override func commonInit() {
        weak var wSelf = self
        self.addSeries = { wSelf?.add() }
        self.removeSeries = { wSelf?.remove() }
        self.clearSeries = { wSelf?.clear() }
    }
 
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        xAxis.visibleRange = SCIDoubleRange(min: 0.0, max: 150.0)
        xAxis.axisTitle = "X Axis"

        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        yAxis.axisTitle = "Y Axis"

        self.surface.xAxes.add(xAxis)
        self.surface.yAxes.add(yAxis)
        surface.chartModifiers.add(ExampleViewBase.createDefaultModifiers())
    }
    
    fileprivate func add() {
        SCIUpdateSuspender.usingWith(surface) {
            let randomDoubleSeries = SCDDataManager.getRandomDoubleSeries(withCount: 150)
            let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)
            dataSeries.append(x: randomDoubleSeries.xValues, y: randomDoubleSeries.yValues)

            let mountainRenderSeries = SCIFastMountainRenderableSeries()
            mountainRenderSeries.dataSeries = dataSeries
            mountainRenderSeries.areaStyle = SCISolidBrushStyle.init(color: UIColor.init(red: CGFloat(arc4random_uniform(255)), green: CGFloat(arc4random_uniform(255)), blue: CGFloat(arc4random_uniform(255)), alpha: 1.0))
            mountainRenderSeries.strokeStyle = SCISolidPenStyle(color: UIColor.init(red: CGFloat(arc4random_uniform(255)), green: CGFloat(arc4random_uniform(255)), blue: CGFloat(arc4random_uniform(255)), alpha: 1.0), thickness: 1.0)
            self.surface.renderableSeries.add(mountainRenderSeries)
        }
    }
    
    fileprivate func remove() {
        SCIUpdateSuspender.usingWith(surface) {
            if (self.surface.renderableSeries.count > 0) {
                self.surface.renderableSeries.remove(at: 0)
            }
        }
    }
    
    fileprivate func clear() {
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.renderableSeries.clear()
        }
    }
}
