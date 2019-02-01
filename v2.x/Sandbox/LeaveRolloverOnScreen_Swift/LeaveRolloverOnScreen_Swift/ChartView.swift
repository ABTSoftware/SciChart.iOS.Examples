import UIKit
import SciChart

class CustomRollover : SCIRolloverModifier {
    override func onPanGesture(_ gesture: UIPanGestureRecognizer!, at view: UIView!) -> Bool {
        if (gesture.state != .ended) {
            return super.onPanGesture(gesture, at: view)
        }
        return true ;
    }
}

class ChartView: SCIChartSurface {
    
    let rollover = CustomRollover()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }

    fileprivate func completeConfiguration() {
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        for i in 0...10 {
            let yValue = Int(arc4random_uniform(10))
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(yValue))
        }
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        rSeries.dataSeries = dataSeries
        
        SCIUpdateSuspender.usingWithSuspendable(self) {
            self.xAxes.add(SCINumericAxis())
            self.yAxes.add(SCINumericAxis())
            self.renderableSeries.add(rSeries)
            self.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), self.rollover])
        }
        
        let button = UIButton(frame: CGRect(x: 100, y: 5, width: 200, height: 50))
        button.setTitle("Add/Remove Rollover", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        rollover.isEnabled = !rollover.isEnabled
        if (rollover.isEnabled) {
            self.chartModifiers.add(rollover)
        } else {
            self.chartModifiers.remove(rollover)
        }
    }
}
