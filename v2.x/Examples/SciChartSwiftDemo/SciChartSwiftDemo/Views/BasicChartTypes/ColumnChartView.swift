//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ColumnChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ColumnsTripleColorPalette : SCIPaletteProvider {
    let style1 : SCIColumnSeriesStyle = SCIColumnSeriesStyle()
    let style2 : SCIColumnSeriesStyle = SCIColumnSeriesStyle()
    let style3 : SCIColumnSeriesStyle = SCIColumnSeriesStyle()
    
    override init() {
        super.init()
        
        style1.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFFa9d34f, finish: 0xFF93b944, direction: .vertical)
        style1.strokeStyle = SCISolidPenStyle(colorCode: 0xFF232323, withThickness: 0.4)
        
        style2.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFFfc9930, finish: 0xFFd17f28, direction: .vertical)
        style2.strokeStyle = SCISolidPenStyle(colorCode: 0xFF232323, withThickness: 0.4)
        
        style3.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFFd63b3f, finish: 0xFFbc3337, direction: .vertical)
        style3.strokeStyle = SCISolidPenStyle(colorCode: 0xFF232323, withThickness: 0.4)
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        let styleIndex : Int32 = index % 3;
        if (styleIndex == 0) {
            return style1;
        } else if (styleIndex == 1) {
            return style2;
        } else {
            return style3;
        }
    }
}

class ColumnChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
        
        let dataSeries = SCIXyDataSeries(xType: .int32, yType: .int32)
        let yValues = [50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60];
        for i in 0..<yValues.count {
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(yValues[i]))
        }
        
        let rSeries = SCIFastColumnRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.paletteProvider = ColumnsTripleColorPalette()
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIRolloverModifier()])
            
            rSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
