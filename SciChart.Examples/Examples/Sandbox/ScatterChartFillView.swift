//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ScatterChartFillView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ScatterChartFillView: SCDSingleChartViewController<SCIChartSurface> {
    
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
        
        let dataSize = 10;
        for i in 0 ..< dataSize {
            ds1.append(x: i, y: randf(0.0, 1.0))
            ds2.append(x: i, y: 1 + randf(0.0, 1.0))
            ds3.append(x: i, y: 1.8 + randf(0.0, 1.0))
            ds4.append(x: i, y: 2.5 + randf(0.0, 1.0))
            ds5.append(x: i, y: 3.5 + randf(0.0, 1.0))
        }
        
        let image = UIImage(named: "AppIcon")!
        let texture = SCIBitmap(size: CGSizeMakeScaled(image.size, image.scale))
        texture.context.draw(image.cgImage!, in: CGRect(origin: .zero, size: CGSize(width: CGFloat(texture.width), height: CGFloat(texture.height))))
        
        let stroke1 = SCISolidPenStyle(color: .blue, thickness: 2.0)
        let stroke2 = SCISolidPenStyle(color: .red, thickness: 2.0)
        let stroke3 = SCISolidPenStyle(colorCode: 0xffff6600, thickness: 2.0)
        let stroke4 = SCISolidPenStyle(color: .magenta, thickness: 4.0)
        let stroke5 = SCISolidPenStyle(color: .red, thickness: 4.0, strokeDashArray: [2, 3, 4, 5])
        
        let fill1 = SCISolidBrushStyle(colorCode: 0x990077ff)
        let fill2 = SCISolidBrushStyle(colorCode: 0x99ff7700)
        let fill3 = SCIRadialGradientBrushStyle(center: CGPoint(x: 0.5, y: 0.5), radius: 0.4, center: .red, edgeColor: .green)
        let fill5 = SCITextureBrushStyle(texture: texture)
        
        let pm1 = EllipsePointMarker(size: 50, strokeStyle: stroke1, fillStyle: fill1)
        let pm2 = EllipsePointMarker(size: 60, strokeStyle: stroke2, fillStyle: fill2)
        let pm3 = EllipsePointMarker(size: 60, strokeStyle: stroke3, fillStyle: fill3)
        let pm4 = EllipsePointMarker(size: 65, strokeStyle: stroke4)
        let pm5 = EllipsePointMarker(size: 75, strokeStyle: stroke5, fillStyle: fill5)
        
        let rSeries1 = getRenderableSeries(dataSeries: ds1, pointMarker: pm1, color: .blue)
        let rSeries2 = getRenderableSeries(dataSeries: ds2, pointMarker: pm2, color: .red)
        let rSeries3 = getRenderableSeries(dataSeries: ds3, pointMarker: pm3, color: .yellow)
        let rSeries4 = getRenderableSeries(dataSeries: ds4, pointMarker: pm4, color: .magenta)
        let rSeries5 = getRenderableSeries(dataSeries: ds5, pointMarker: pm5, color: .orange)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: rSeries1, rSeries2, rSeries3, rSeries4, rSeries5)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
        }
    }
    
    private func getRenderableSeries(dataSeries: ISCIDataSeries, pointMarker: ISCIPointMarker, color: UIColor) -> ISCIRenderableSeries {
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = pointMarker
        rSeries.strokeStyle = SCISolidPenStyle(color: color, thickness: 1.0)
        
        return rSeries
    }
}

class EllipsePointMarker: SCIDrawablePointMarker {
    
    init(size: CGFloat, strokeStyle: SCIPenStyle) {
        super.init()
        
        self.size = CGSize(width: size, height: size)
        self.strokeStyle = strokeStyle
    }
    
    convenience init(size: CGFloat, strokeStyle: SCIPenStyle, fillStyle: SCIBrushStyle) {
        self.init(size: size, strokeStyle: strokeStyle)
        
        self.fillStyle = fillStyle
    }
    
    override func internalDraw(with renderContext: ISCIRenderContext2D!, at point: CGPoint, withStroke pen: ISCIPen2D!, andFill brush: ISCIBrush2D!) {
        renderContext.drawEllipse(with: pen, brush: brush, andSize: self.size, at: point)
    }
}
