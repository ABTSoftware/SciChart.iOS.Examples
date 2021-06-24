//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

// MARK: - Custom Point Marker

class CustomPointMarkerDrawer: ISCISpritePointMarkerDrawer {
    let image: SCIImage
    
    init(image: SCIImage) {
        self.image = image
    }
    
    func onDraw(_ bitmap: SCIBitmap, with penStyle: SCIPenStyle, andBrushStyle brushStyle: SCIBrushStyle) {
        bitmap.context.saveGState()
        let rect = CGRect(origin: .zero, size: CGSize(width: CGFloat(bitmap.width), height: CGFloat(bitmap.height)))
        bitmap.context.translateBy(x: 0.0, y: CGFloat(bitmap.context.height))
        bitmap.context.scaleBy(x: 1.0, y: -1.0)
// TODO: Consider add swift only extensions for swift builds
#if os(OSX)
        bitmap.context.draw(image.cgImage().takeRetainedValue(), in: rect)
#elseif os(iOS)
        bitmap.context.draw(image.cgImage!, in: rect)
#endif
        bitmap.context.restoreGState()
    }
}

// MARK: - Chart Initialization

class UsingPointMarkersChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds4 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds5 = SCIXyDataSeries(xType: .double, yType: .double)

        let dataSize = 15;
        for i in 0 ..< dataSize {
            ds1.append(x: i, y: randf(0.0, 1.0))
            ds2.append(x: i, y: 1 + randf(0.0, 1.0))
            ds3.append(x: i, y: 2.5 + randf(0.0, 1.0))
            ds4.append(x: i, y: 4 + randf(0.0, 1.0))
            ds5.append(x: i, y: 5.5 + randf(0.0, 1.0))
        }
        
        ds1.update(y: Double.nan, at: 7)
        ds2.update(y: Double.nan, at: 7)
        ds3.update(y: Double.nan, at: 7)
        ds4.update(y: Double.nan, at: 7)
        ds5.update(y: Double.nan, at: 7)
        
        let pointMarker1 = SCIEllipsePointMarker()
        pointMarker1.size = CGSize(width: 15, height: 15)
        pointMarker1.fillStyle = SCISolidBrushStyle(color: 0x990077ff);
        pointMarker1.strokeStyle = SCISolidPenStyle(color: 0xFFADD8E6, thickness:2.0);
        
        let pointMarker2 = SCISquarePointMarker()
        pointMarker2.size = CGSize(width: 20, height: 20)
        pointMarker2.fillStyle = SCISolidBrushStyle(color: 0x99ff0000);
        pointMarker2.strokeStyle = SCISolidPenStyle(color: 0xFFFF0000, thickness:2.0);
        
        let pointMarker3 = SCITrianglePointMarker()
        pointMarker3.size = CGSize(width: 20, height: 20)
        pointMarker3.fillStyle = SCISolidBrushStyle(color: 0xFFFFDD00);
        pointMarker3.strokeStyle = SCISolidPenStyle(color: 0xFFFF6600, thickness:2.0);
        
        let pointMarker4 = SCICrossPointMarker()
        pointMarker4.size = CGSize(width: 25, height: 25)
        pointMarker4.strokeStyle = SCISolidPenStyle(color:0xFFFF00FF, thickness:4.0);
        
        let pointMarker5 = SCISpritePointMarker(drawer: CustomPointMarkerDrawer(image: #imageLiteral(resourceName: "image.weather.storm")))
        pointMarker5.size = CGSize(width: 40, height: 40)

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds1, pointMarker: pointMarker1, color: 0xFFADD8E6))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds2, pointMarker: pointMarker2, color: 0xFFFF0000))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds3, pointMarker: pointMarker3, color: 0xFFFFFF00))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds4, pointMarker: pointMarker4, color: 0xFFFF00FF))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds5, pointMarker: pointMarker5, color: 0xFFF5DEB3))
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
        }
    }
    
    fileprivate func getRenderableSeriesWith(_ dataSeries: SCIXyDataSeries, pointMarker:ISCIPointMarker, color: UInt32) -> SCIFastLineRenderableSeries {
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(color: color, thickness: 2)
        rSeries.pointMarker = pointMarker
        rSeries.dataSeries = dataSeries
        
        SCIAnimations.fade(rSeries, duration: 2.0, andEasingFunction: SCICubicEase())
        
        return rSeries
    }
}
