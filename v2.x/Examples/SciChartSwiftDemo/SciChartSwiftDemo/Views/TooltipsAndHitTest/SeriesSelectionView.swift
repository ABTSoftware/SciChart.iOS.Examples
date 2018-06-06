//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SeriesSelectionView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SeriesSelectionView: SingleChartLayout {
    
    let SeriesPointCount: Int32 = 50
    let SeriesCount = 80

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        
        let leftAxis = SCINumericAxis()
        leftAxis.axisId = "yLeftAxis"
        leftAxis.axisAlignment = .left
        
        let rightAxis = SCINumericAxis()
        rightAxis.axisId = "yRightAxis"
        rightAxis.axisAlignment = .right
    
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(leftAxis)
            self.surface.yAxes.add(rightAxis)
            self.surface.chartModifiers.add(SCISeriesSelectionModifier())
            
            var initialColor = UIColor.blue
            for i in 0..<self.SeriesCount {
                let axisAlignment: SCIAxisAlignment = i % 2 == 0 ? .left: .right;
                
                let dataSeries = self.generateDataSeriesWith(axisAlignment, index: i)
                
                let pointMarker = SCIEllipsePointMarker()
                pointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFFF00DC)
                pointMarker.strokeStyle = SCISolidPenStyle(color: UIColor.white, withThickness: 1)
                pointMarker.height = 10
                pointMarker.width = 10
                
                let rSeries = SCIFastLineRenderableSeries()
                rSeries.dataSeries = dataSeries
                rSeries.yAxisId = axisAlignment == .left ? "yLeftAxis" : "yRightAxis"
                rSeries.strokeStyle = SCISolidPenStyle(color: initialColor, withThickness: 1)
                rSeries.selectedStyle = rSeries.style
                rSeries.selectedStyle.pointMarker = pointMarker
                rSeries.hitTestProvider().hitTestMode = .interpolate
                
                self.surface.renderableSeries.add(rSeries)
                
                var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
                initialColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                
                let newR = red == 1.0 ? 1.0 : red + 0.0125;
                let newB = blue == 0.0 ? 0.0 : blue - 0.0125;
                initialColor = UIColor(red: newR, green: green, blue: newB, alpha: alpha)
                
                rSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            }
        }
    }

    fileprivate func generateDataSeriesWith(_ axisAlignment: SCIAxisAlignment, index: Int) -> SCIXyDataSeries {
        let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)
        dataSeries.seriesName = String(format: "Series %i", index)
        
        let gradient = Double(axisAlignment == .right ? index: -index);
        let start = axisAlignment == .right ? 0.0 : 14000;
        
        let straightLine = (DataManager.getStraightLines(withGradient: gradient, yIntercept: start, pointCount: SeriesPointCount))!
        dataSeries.appendRangeX(straightLine.xValues, y: straightLine.yValues, count: straightLine.size)
        
        return dataSeries
    }
}
