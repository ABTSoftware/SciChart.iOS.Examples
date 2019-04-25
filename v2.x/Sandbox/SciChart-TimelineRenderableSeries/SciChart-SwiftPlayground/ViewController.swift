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
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)//, zType: .double)
        dataSeries.appendX(SCIGeneric(0), y: SCIGeneric(6))
        dataSeries.appendX(SCIGeneric(6), y: SCIGeneric(4))
        dataSeries.appendX(SCIGeneric(10), y: SCIGeneric(10))
        
        let renderSeries = TimelineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        
        chart.xAxes.add(SCINumericAxis())
        chart.yAxes.add(SCINumericAxis())
        chart.renderableSeries.add(renderSeries)
        chart.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIZoomExtentsModifier(), SCIPinchZoomModifier(), SCIZoomPanModifier()])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
