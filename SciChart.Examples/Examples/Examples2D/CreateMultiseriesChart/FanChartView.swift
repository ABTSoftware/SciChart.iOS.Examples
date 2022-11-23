//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
    var date: Date
    var actual: Double
    var varMax: Double
    var var1: Double
    var var2: Double
    var var3: Double
    var var4: Double
    var varMin: Double
}

class FanChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xAxis = SCIDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let actualDataSeries = SCIXyDataSeries(xType:.date, yType:.double)
        let var3DataSeries = SCIXyyDataSeries(xType:.date, yType:.double)
        let var2DataSeries = SCIXyyDataSeries(xType:.date, yType:.double)
        let var1DataSeries = SCIXyyDataSeries(xType:.date, yType:.double)
        
        self.generatingDataPoints(10) { (result: VarPoint) in
            actualDataSeries.append(x: result.date, y: result.actual)
            var3DataSeries.append(x: result.date, y: result.varMin, y1: result.varMax)
            var2DataSeries.append(x: result.date, y: result.var1, y1: result.var4)
            var1DataSeries.append(x: result.date, y: result.var2, y1: result.var3)
        }
        
        let projectedVar3 = SCIFastBandRenderableSeries()
        projectedVar3.dataSeries = var3DataSeries
        projectedVar3.strokeStyle = SCISolidPenStyle(color: .clear, thickness: 1.0)
        projectedVar3.strokeY1Style = SCISolidPenStyle(color: .clear, thickness: 1.0)
        
        let projectedVar2 = SCIFastBandRenderableSeries()
        projectedVar2.dataSeries = var2DataSeries
        projectedVar2.strokeStyle = SCISolidPenStyle(color: .clear, thickness: 1.0)
        projectedVar2.strokeY1Style = SCISolidPenStyle(color: .clear, thickness: 1.0)
        
        let projectedVar1 = SCIFastBandRenderableSeries()
        projectedVar1.dataSeries = var1DataSeries
        projectedVar1.strokeStyle = SCISolidPenStyle(color: .clear, thickness: 1.0)
        projectedVar1.strokeY1Style = SCISolidPenStyle(color: .clear, thickness: 1.0)
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = actualDataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(color: 0xFFc43360, thickness: 1.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: projectedVar3, projectedVar2, projectedVar1, lineSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())

            SCIAnimations.wave(projectedVar3, duration: 3.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(projectedVar2, duration: 3.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(projectedVar1, duration: 3.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(lineSeries, duration: 3.0, andEasingFunction: SCICubicEase())
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
        
        let yValues = SCDRandomWalkGenerator().getRandomWalkSeries(count).yValues
        
        for i in 0 ..< count {
            let yValue = yValues.getValueAt(i)
            dateTime = dateTime.addingTimeInterval(3600 * 24)
            
            var varMax = Double.nan
            var var4 = Double.nan
            var var3 = Double.nan
            var var2 = Double.nan
            var var1 = Double.nan
            var varMin = Double.nan
            
            if i > 4 {
                varMax = yValue + (Double(i) - 5) * 0.3
                var4 = yValue + (Double(i) - 5) * 0.2
                var3 = yValue + (Double(i) - 5) * 0.1
                var2 = yValue - (Double(i) - 5) * 0.1
                var1 = yValue - (Double(i) - 5) * 0.2
                varMin = yValue - (Double(i) - 5) * 0.3
            }
            handler(VarPoint(date: dateTime, actual: yValue, varMax: varMax, var1: var1, var2: var2, var3: var3, var4: var4, varMin: varMin))
        }
    }
}
