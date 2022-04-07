//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SeriesTooltip3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

private let BlueColor: UInt32 = 0xFF0084CF
private let RedColor: UInt32 = 0xFFEE1110
private let SegmentsCount = 25
private let YAngle: Double = -65 * (.pi / 180)
private let CosYAngle: Double = cos(YAngle)
private let SinYAngle: Double = sin(YAngle)

class SeriesTooltip3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }

    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        xAxis.maxAutoTicks = 5
        xAxis.axisTitle = "X - Axis"
        
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.axisTitle = "Y - Axis"

        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        zAxis.axisTitle = "Z - Axis"

        let pointMetadataProvider = SCIPointMetadataProvider3D()
        let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)

        let RotationAngle: Double = 360.0 / 45.0
        var currentAngle: Double = 0.0
        
        for i in -SegmentsCount ..< SegmentsCount + 1 {
            appendPoint(dataSeries, x: -4, y: Double(i), currentAngle: currentAngle)
            appendPoint(dataSeries, x: 4, y: Double(i), currentAngle: currentAngle)
            
            pointMetadataProvider.metadata.add(SCIPointMetadata3D(vertexColor: BlueColor, andScale: 1))
            pointMetadataProvider.metadata.add(SCIPointMetadata3D(vertexColor: RedColor, andScale: 1))
            
            currentAngle = (currentAngle + RotationAngle).truncatingRemainder(dividingBy: 360.0)
        }
        
        let pointMarker = SCISpherePointMarker3D()
        pointMarker.size = 8.0
        
        let rSeries = SCIPointLineRenderableSeries3D()
        rSeries.dataSeries = dataSeries
        rSeries.strokeThickness = 4.0
        rSeries.pointMarker = pointMarker
        rSeries.isLineStrips = false
        rSeries.metadataProvider = pointMetadataProvider
        
        let tooltipModifier = SCITooltipModifier3D()
        tooltipModifier.receiveHandledEvents = true
        tooltipModifier.crosshairMode = .lines
        tooltipModifier.crosshairPlanesFill = SCIColor.fromARGBColorCode(0x33FF6600)

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(items: tooltipModifier, SCIPinchZoomModifier3D(), SCIZoomExtentsModifier3D(), SCIOrbitModifier3D(defaultNumberOfTouches: 2))
            
            self.surface.camera = SCICamera3D()
            self.surface.camera.position.assignX(-160, y: 190, z: -520)
            self.surface.camera.target.assignX(-45, y: 150, z: 0)
            self.surface.worldDimensions.assignX(600, y: 300, z: 180)
        }
    }
    
    private func appendPoint(_ ds: SCIXyzDataSeries3D, x: Double, y: Double, currentAngle: Double) {
        let radAngle = currentAngle * (.pi / 180)
        let temp = x * Double(cos(radAngle))
        
        let xValue = temp * CosYAngle - y * SinYAngle;
        let yValue = temp * SinYAngle + y * CosYAngle;
        let zValue = x * Double(sin(radAngle))
        
        ds.append(x: xValue, y: yValue, z: zValue)
    }
}
