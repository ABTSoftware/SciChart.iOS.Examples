//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingRolloverModifierChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class UsingRolloverModifierChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.2), max: SCIGeneric(0.2))
        
        let ds1 = SCIXyDataSeries(xType: .int32, yType: .double)
        ds1.seriesName = "Sinewave A"
        let ds2 = SCIXyDataSeries(xType: .int32, yType: .double)
        ds2.seriesName = "Sinewave B"
        let ds3 = SCIXyDataSeries(xType: .int32, yType: .double)
        ds3.seriesName = "Sinewave C"

        let count = 100
        let k = 2 * .pi / 30.0
        for i in 0..<count {
            let phi = k * Double(i)
            ds1.appendX(SCIGeneric(i), y: SCIGeneric((1.0 + Double(i) / Double(count)) * sin(phi)))
            ds2.appendX(SCIGeneric(i), y: SCIGeneric((0.5 + Double(i) / Double(count)) * sin(phi)))
            ds3.appendX(SCIGeneric(i), y: SCIGeneric(Double(i) / Double(count) * sin(phi)))
        }
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFd7ffd6)
        ellipsePointMarker.height = 7
        ellipsePointMarker.width = 7
        
        let rs1 = SCIFastLineRenderableSeries()
        rs1.dataSeries = ds1
        rs1.pointMarker = ellipsePointMarker
        rs1.strokeStyle = SCISolidPenStyle(colorCode: 0xFFa1b9d7, withThickness: 1)

        let rs2 = SCIFastLineRenderableSeries()
        rs2.dataSeries = ds2
        rs2.pointMarker = ellipsePointMarker
        rs2.strokeStyle = SCISolidPenStyle(colorCode: 0xFF0b5400, withThickness: 1)
        
        let rs3 = SCIFastLineRenderableSeries()
        rs3.dataSeries = ds3
        rs3.strokeStyle = SCISolidPenStyle(colorCode: 0xFF386ea6, withThickness: 1)

        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rs1)
            self.surface.renderableSeries.add(rs2)
            self.surface.renderableSeries.add(rs3)
            self.surface.chartModifiers.add(SCIRolloverModifier())
            
            rs1.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            rs2.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            rs3.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
