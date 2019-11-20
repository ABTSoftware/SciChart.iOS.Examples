import UIKit
import SciChart

class ViewController: UIViewController {
    
    private let pointsCount = 200
    private var timer: Timer!
    private let xValues = SCIDoubleValues()
    private let yValues = SCIDoubleValues()
    private let zValues = SCIDoubleValues()
    private let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
    
    private var surface: SCIChartSurface3D {
        return view as! SCIChartSurface3D
    }
    
    override func loadView() {
        view = SCIChartSurface3D()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0 ..< pointsCount {
            xValues.add(getGaussianRandomNumber(mean: 5, stdDev: 1.5))
            yValues.add(getGaussianRandomNumber(mean: 5, stdDev: 1.5))
            zValues.add(getGaussianRandomNumber(mean: 5, stdDev: 1.5))
        }
        dataSeries.append(x: xValues, y: yValues, z: zValues)
        
        let pointMarker = SCISpherePointMarker3D()
        pointMarker.fillColor = 0xFF32CD32;
        pointMarker.size = 10.0
        
        let rSeries = SCIScatterRenderableSeries3D()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = pointMarker
        
        let tooltipModifier = SCITooltipModifier3D()
        tooltipModifier.crosshairMode = .lines
        
        SCIUpdateSuspender.usingWith(self.surface) {
            self.surface.xAxis = SCINumericAxis3D()
            self.surface.yAxis = SCINumericAxis3D()
            self.surface.zAxis = SCINumericAxis3D()
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(items: SCIOrbitModifier3D(defaultNumberOfTouches: 2), SCIZoomExtentsModifier3D(), SCIPinchZoomModifier3D())
            self.surface.chartModifiers.add(tooltipModifier)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateData(_ timer: Timer) {
        for i in 0 ..< pointsCount {
            let xValue = xValues.getValueAt(i) + Double.random(in: 0...1) - 0.5
            let yValue = yValues.getValueAt(i) + Double.random(in: 0...1) - 0.5
            let zValue = zValues.getValueAt(i) + Double.random(in: 0...1) - 0.5
            
            xValues.set(xValue, at: i)
            yValues.set(yValue, at: i)
            zValues.set(zValue, at: i)
        }
        
        SCIUpdateSuspender.usingWith(surface) {
            self.dataSeries.update(x: self.xValues, y: self.yValues, z: self.zValues, at: 0)
        }
    }
    
    fileprivate func getGaussianRandomNumber(mean: Double, stdDev: Double) -> Double {
        let u1 = Double.random(in: 0...1)
        let u2 = Double.random(in: 0...1)
        let normal = sqrt(-2.0 * log(u1)) * sin(2.0 * .pi * u2)
        
        return mean * stdDev * normal
    }
}
