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
        lineDataSeries.seriesName = "Line Series"
        let scatterDataSeries = SCIXyDataSeries(xType: .int, yType: .double)
        scatterDataSeries.seriesName = "Scatter Series"
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
        
        let legendModifier = SCILegendModifier()
        legendModifier.orientation = .horizontal
        legendModifier.position = [.bottom, .centerHorizontal]
        legendModifier.margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        SCIUpdateSuspender.usingWith(self.surface) {
            self.surface.xAxes.add(items: SCINumericAxis())
            self.surface.yAxes.add(items: SCINumericAxis())
            self.surface.renderableSeries.add(items: lineSeries, scatterSeries)
            self.surface.chartModifiers.add(items: SCIPinchZoomModifier(), SCIZoomExtentsModifier())
            self.surface.chartModifiers.add(items: SCIRolloverModifier(), legendModifier)
        }
    }
}
