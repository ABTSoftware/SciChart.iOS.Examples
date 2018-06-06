//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingCursorModifierChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class UsingCursorModifierChartView: SingleChartLayout {
    
    let PointsCount: Int32 = 500
    
    override func initExample() {
        let xAxis = SCINumericAxis();
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(3), max: SCIGeneric(6))
        
        let yAxis = SCINumericAxis();
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.05), max: SCIGeneric(0.05))
        yAxis.autoRange = .always
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        ds1.seriesName = "Green Series";
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        ds2.seriesName = "Red Series";
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        ds3.seriesName = "Gray Series";
        let ds4 = SCIXyDataSeries(xType: .double, yType: .double)
        ds4.seriesName = "Gold Series";
        
        let data1 = DataManager.getNoisySinewave(withAmplitude: 300, phase: 1.0, pointCount: PointsCount, noiseAmplitude: 0.25)
        let data2 = DataManager.getSinewaveWithAmplitude(100, phase: 2.0, pointCount: PointsCount)
        let data3 = DataManager.getSinewaveWithAmplitude(200, phase: 1.5, pointCount: PointsCount)
        let data4 = DataManager.getSinewaveWithAmplitude(50, phase: 0.1, pointCount: PointsCount)
        
        ds1.appendRangeX(data1!.xValues, y: data1!.yValues, count: data1!.size)
        ds2.appendRangeX(data2!.xValues, y: data2!.yValues, count: data2!.size)
        ds3.appendRangeX(data3!.xValues, y: data3!.yValues, count: data3!.size)
        ds4.appendRangeX(data4!.xValues, y: data4!.yValues, count: data4!.size)
        
        let rs1 = SCIFastLineRenderableSeries()
        rs1.dataSeries = ds1
        rs1.strokeStyle = SCISolidPenStyle(colorCode: 0xFF177B17, withThickness: 2)
        
        let rs2 = SCIFastLineRenderableSeries()
        rs2.dataSeries = ds2
        rs2.strokeStyle = SCISolidPenStyle(colorCode: 0xFFDD0909, withThickness: 2)
        
        let rs3 = SCIFastLineRenderableSeries()
        rs3.dataSeries = ds3
        rs3.strokeStyle = SCISolidPenStyle(colorCode: 0xFF808080, withThickness: 2)
        
        let rs4 = SCIFastLineRenderableSeries()
        rs4.dataSeries = ds4
        rs4.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFFD700, withThickness: 2)
        rs4.isVisible = false
        
        let cursorModifier = SCICursorModifier()
        cursorModifier.style.colorMode = .seriesColorToDataView
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rs1)
            self.surface.renderableSeries.add(rs2)
            self.surface.renderableSeries.add(rs3)
            self.surface.renderableSeries.add(rs4)
            self.surface.chartModifiers.add(cursorModifier)
            
            rs1.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            rs2.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            rs3.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            rs4.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
