import UIKit
import SciChart

class ViewController: UIViewController {
    
    private var surface: SCIChartSurface {
        return view as! SCIChartSurface
    }
    
    override func loadView() {
        viewRespectsSystemMinimumLayoutMargins = false
        view = SCIChartSurface()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineDataSeries = SCIXyDataSeries(xType: .int, yType: .double)
        let scatterDataSeries = SCIXyDataSeries(xType: .int, yType: .double)
        for i in 0 ..< 200 {
            lineDataSeries.append(x: i, y: sin(Double(i) * 0.1))
            scatterDataSeries.append(x: i, y: cos(Double(i) * 0.1))
        }
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        
        let pointMarker = SCIEllipsePointMarker()
        pointMarker.fillStyle = SCISolidBrushStyle(color: 0xFF32CD32)
        pointMarker.size = CGSize(width: 10, height: 10)
        
        let scatterSeries = SCIXyScatterRenderableSeries()
        scatterSeries.dataSeries = scatterDataSeries
        scatterSeries.pointMarker = pointMarker
        
        SCIUpdateSuspender.usingWith(self.surface) {
            self.surface.xAxes.add(items: SCINumericAxis())
            self.surface.yAxes.add(items: SCINumericAxis())
            self.surface.renderableSeries.add(items: lineSeries, scatterSeries)
        }
    }
}
