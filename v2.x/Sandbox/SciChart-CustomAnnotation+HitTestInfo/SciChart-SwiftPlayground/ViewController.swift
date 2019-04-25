import UIKit
import SciChart

class ViewController: UIViewController {
    
    private lazy var chart: SCIChartSurface = {
        let tempChart = SCIChartSurface(frame: .zero)
        tempChart.renderSurface = SCIMetalRenderSurface(frame: .zero)
        return tempChart
    }()
    
    override func loadView() {
        view = chart
        completeConfiguration()
    }
    
    fileprivate func completeConfiguration() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(1.1), max: SCIGeneric(2.7))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let dataSeries = SCIXyDataSeries(xType: .int32, yType: .float)
        dataSeries.seriesName = "Green"
        fillRandomDoubles(series: dataSeries, count: 10, randomRange: 1..<100)
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        rSeries.dataSeries = dataSeries
        
        let ds2 = SCIXyDataSeries(xType: .int32, yType: .float)
        ds2.seriesName = "Red"
        fillRandomDoubles(series: ds2, count: 10, randomRange: 1..<50)
        let rs2 = SCIFastLineRenderableSeries()
        rs2.strokeStyle = SCISolidPenStyle(colorCode: UIColor.red.colorARGBCode(), withThickness: 1.0)
        rs2.dataSeries = ds2
        
        let ds3 = SCIXyDataSeries(xType: .int32, yType: .float)
        ds3.seriesName = "Blue"
        fillRandomDoubles(series: ds3, count: 20, randomRange: 1..<100)
        
        let rs3 = SCIFastLineRenderableSeries()
        rs3.strokeStyle = SCISolidPenStyle(colorCode: UIColor.blue.colorARGBCode(), withThickness: 1.0)
        rs3.dataSeries = ds3
        
        let staticLineAnnotation = StaticLineAnnotation()
        staticLineAnnotation.pointMarker = SCIEllipsePointMarker()
        staticLineAnnotation.onSelectedPointsChanged = {
            let selectedPointsInfo = staticLineAnnotation.selectedPointsSeriesInfo
            for current in selectedPointsInfo {
                print("\(current.renderableSeries()?.dataSeries.seriesName ?? "Unnamed series") selected x value: \(current.xValue().doubleData) y value: \(current.yValue().doubleData)")
            }
        }
        
        SCIUpdateSuspender.usingWithSuspendable(chart) {
            self.chart.xAxes.add(xAxis)
            self.chart.yAxes.add(yAxis)
            self.chart.renderableSeries.add(rSeries)
            self.chart.renderableSeries.add(rs2)
            self.chart.renderableSeries.add(rs3)
            self.chart.annotations.add(staticLineAnnotation)
            self.chart.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
        }
    }

    private func fillRandomDoubles(series: SCIXyDataSeries, count: Int, randomRange: Range<Double> = 1.0..<10.0) {
        for i in 0..<count {
            let randomY = Double.random(in: randomRange)
            series.appendX(SCIGeneric(i), y: SCIGeneric(randomY))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
