//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FanChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

struct VarPoint {
    var date = Date()
    var actual = Double.nan
    var varMax = Double.nan
    var var1 = Double.nan
    var var2 = Double.nan
    var var3 = Double.nan
    var var4 = Double.nan
    var varMin = Double.nan
}

class FanChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCIDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let actualDataSeries = SCIXyDataSeries(xType:.dateTime, yType:.double)
        let var3DataSeries = SCIXyyDataSeries(xType:.dateTime, yType:.double)
        let var2DataSeries = SCIXyyDataSeries(xType:.dateTime, yType:.double)
        let var1DataSeries = SCIXyyDataSeries(xType:.dateTime, yType:.double)
        
        self.generatingDataPoints(10) { (result: VarPoint) in
            actualDataSeries.appendX(SCIGeneric(result.date), y: SCIGeneric(result.actual))
            var3DataSeries.appendX(SCIGeneric(result.date), y1: SCIGeneric(result.varMax), y2: SCIGeneric(result.varMin))
            var2DataSeries.appendX(SCIGeneric(result.date), y1: SCIGeneric(result.var1), y2: SCIGeneric(result.var4))
            var1DataSeries.appendX(SCIGeneric(result.date), y1: SCIGeneric(result.var2), y2: SCIGeneric(result.var3))
        }
        
        let projectedVar3 = SCIFastBandRenderableSeries()
        projectedVar3.dataSeries = var3DataSeries
        projectedVar3.strokeStyle = SCISolidPenStyle(color: UIColor.clear, withThickness: 1.0)
        projectedVar3.strokeY1Style = SCISolidPenStyle(color: UIColor.clear, withThickness: 1.0)
        projectedVar3.fillY1BrushStyle = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))
        projectedVar3.fillBrushStyle = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))
        
        let projectedVar2 = SCIFastBandRenderableSeries()
        projectedVar2.dataSeries = var2DataSeries
        projectedVar2.strokeStyle = SCISolidPenStyle(color: UIColor.clear, withThickness: 1.0)
        projectedVar2.strokeY1Style = SCISolidPenStyle(color: UIColor.clear, withThickness: 1.0)
        projectedVar2.fillY1BrushStyle = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))
        projectedVar2.fillBrushStyle = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))

        let projectedVar1 = SCIFastBandRenderableSeries()
        projectedVar1.dataSeries = var1DataSeries
        projectedVar1.strokeStyle = SCISolidPenStyle(color: UIColor.clear, withThickness: 1.0)
        projectedVar1.strokeY1Style = SCISolidPenStyle(color: UIColor.clear, withThickness: 1.0)
        projectedVar1.fillY1BrushStyle = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))
        projectedVar1.fillBrushStyle = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = actualDataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(color: UIColor.red, withThickness: 1.0)
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(projectedVar3)
            self.surface.renderableSeries.add(projectedVar2)
            self.surface.renderableSeries.add(projectedVar1)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIZoomPanModifier(), SCIZoomExtentsModifier(), SCIPinchZoomModifier()])
            
            projectedVar3.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            projectedVar2.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            projectedVar1.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            lineSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
    
    // Create a table of Variance data. Each row in the table consists of
    //
    //  DateTime, Actual (Y-Value), Projected Min, Variance 1, 2, 3, 4 and Projected Maximum
    //
    //        DateTime    Actual     Min     Var1    Var2    Var3    Var4    Max
    //        Jan-11      y0        -        -        -        -        -        -
    //        Feb-11      y1        -        -        -        -        -        -
    //        Mar-11      y2        -        -        -        -        -        -
    //        Apr-11      y3        -        -        -        -        -        -
    //        May-11      y4        -        -        -        -        -        -
    //        Jun-11      y5        min0  var1_0  var2_0  var3_0  var4_0  max_0
    //        Jul-11      y6        min1  var1_1  var2_1  var3_1  var4_1  max_1
    //        Aug-11      y7        min2  var1_2  var2_2  var3_2  var4_2  max_2
    //        Dec-11      y8        min3  var1_3  var2_3  var3_3  var4_3  max_3
    //        Jan-12      y9        min4  var1_4  var2_4  var3_4  var4_4  max_4
    fileprivate func generatingDataPoints(_ count: Int, handler: (VarPoint) -> Void) {
        var dateTime = Date()

        let yValues = RandomWalkGenerator().getRandomWalkSeries(Int32(count)).getYArray()
        
        for i in 0..<count {
            let yValue = SCIGenericDouble((yValues?.value(at: Int32(i)))!)
            dateTime = dateTime.addingTimeInterval(3600*24)
            
            var dataPoint = VarPoint()
            dataPoint.date = dateTime
            dataPoint.actual = yValue
            if i > 4 {
                dataPoint.varMax = yValue + (Double(i) - 5) * 0.3
                dataPoint.var4 = yValue + (Double(i) - 5) * 0.2
                dataPoint.var3 = yValue + (Double(i) - 5) * 0.1
                dataPoint.var2 = yValue - (Double(i) - 5) * 0.1
                dataPoint.var1 = yValue - (Double(i) - 5) * 0.2
                dataPoint.varMin = yValue - (Double(i) - 5) * 0.3
            }
            handler(dataPoint)
        }
    }
}
