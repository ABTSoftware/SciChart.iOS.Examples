import UIKit
import SciChart

class ViewController: UIViewController {
    
    private var surface: SCIChartSurface3D {
        return view as! SCIChartSurface3D
    }
    
    override func loadView() {
        view = SCIChartSurface3D()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
        for _ in 0 ..< 200 {
            let x = getGaussianRandomNumber(mean: 5, stdDev: 1.5)
            let y = getGaussianRandomNumber(mean: 5, stdDev: 1.5)
            let z = getGaussianRandomNumber(mean: 5, stdDev: 1.5)
            dataSeries.append(x: x, y: y, z: z)
        }
        
        let pointMarker = SCISpherePointMarker3D()
        pointMarker.fillColor = 0xFF32CD32;
        pointMarker.size = 10.0
        
        let rSeries = SCIScatterRenderableSeries3D()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = pointMarker
        
        SCIUpdateSuspender.usingWith(self.surface) {
            self.surface.xAxis = SCINumericAxis3D()
            self.surface.yAxis = SCINumericAxis3D()
            self.surface.zAxis = SCINumericAxis3D()
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(items: SCIOrbitModifier3D(), SCIZoomExtentsModifier3D(), SCIPinchZoomModifier3D())
        }
    }
    
    fileprivate func getGaussianRandomNumber(mean: Double, stdDev: Double) -> Double {
        let u1 = Double.random(in: 0...1)
        let u2 = Double.random(in: 0...1)
        let normal = sqrt(-2.0 * log(u1)) * sin(2.0 * .pi * u2)
        
        return mean * stdDev * normal
    }
}
