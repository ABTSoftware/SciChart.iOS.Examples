//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingPointMarkersChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class UsingPointMarkersChartView: SingleChartLayout {

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds4 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds5 = SCIXyDataSeries(xType: .double, yType: .double)

        let dataSize = 15;
        for i in 0..<dataSize {
            ds1.appendX(SCIGeneric(i), y: SCIGeneric(randf(0.0, 1.0)))
            ds2.appendX(SCIGeneric(i), y: SCIGeneric(1 + randf(0.0, 1.0)))
            ds3.appendX(SCIGeneric(i), y: SCIGeneric(2.5 + randf(0.0, 1.0)))
            ds4.appendX(SCIGeneric(i), y: SCIGeneric(4 + randf(0.0, 1.0)))
            ds5.appendX(SCIGeneric(i), y: SCIGeneric(5.5 + randf(0.0, 1.0)))
        }
        
        ds1.update(at: 7, x: SCIGeneric(Double.nan))
        ds2.update(at: 7, x: SCIGeneric(Double.nan))
        ds3.update(at: 7, x: SCIGeneric(Double.nan))
        ds4.update(at: 7, x: SCIGeneric(Double.nan))
        ds5.update(at: 7, x: SCIGeneric(Double.nan))
        
        let pointMarker1 = SCIEllipsePointMarker()
        pointMarker1.width = 15
        pointMarker1.height = 15
        pointMarker1.fillStyle = SCISolidBrushStyle(colorCode: 0x990077ff);
        pointMarker1.strokeStyle = SCISolidPenStyle(colorCode:0xFFADD8E6, withThickness:2.0);
        
        let pointMarker2 = SCISquarePointMarker()
        pointMarker2.width = 20
        pointMarker2.height = 20
        pointMarker2.fillStyle = SCISolidBrushStyle(colorCode: 0x99ff0000);
        pointMarker2.strokeStyle = SCISolidPenStyle(colorCode:0xFFFF0000, withThickness:2.0);
        
        let pointMarker3 = SCITrianglePointMarker()
        pointMarker3.width = 20
        pointMarker3.height = 20
        pointMarker3.fillStyle = SCISolidBrushStyle(colorCode: 0xFFFFDD00);
        pointMarker3.strokeStyle = SCISolidPenStyle(colorCode:0xFFFF6600, withThickness:2.0);
        
        let pointMarker4 = SCICrossPointMarker()
        pointMarker4.width = 25
        pointMarker4.height = 25
        pointMarker4.strokeStyle = SCISolidPenStyle(colorCode:0xFFFF00FF, withThickness:4.0);
        
        let pointMarker5 = SCISpritePointMarker()
        pointMarker5.width = 40
        pointMarker5.height = 40
        pointMarker5.textureBrush = SCITextureBrushStyle(texture: SCITextureOpenGL(image: UIImage.init(named: "Weather_Storm")))

        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds1, pointMarker: pointMarker1, color: 0xFFADD8E6))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds2, pointMarker: pointMarker2, color: 0xFFFF0000))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds3, pointMarker: pointMarker3, color: 0xFFFFFF00))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds4, pointMarker: pointMarker4, color: 0xFFFF00FF))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds5, pointMarker: pointMarker5, color: 0xFFF5DEB3))
            
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier()])
        }
    }
    
    fileprivate func getRenderableSeriesWith(_ dataSeries: SCIXyDataSeries, pointMarker:SCIPointMarkerProtocol, color: UInt32) -> SCIFastLineRenderableSeries {
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.strokeStyle = SCISolidPenStyle(colorCode: color, withThickness: 2)
        renderSeries.pointMarker = pointMarker
        renderSeries.dataSeries = dataSeries
        
        renderSeries.addAnimation(SCIFadeRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
        
        return renderSeries
    }
}
