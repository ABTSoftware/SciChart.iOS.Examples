//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomSeriesTooltip3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCISeriesTooltip3DBase
import SciChart.Protected.SCISeriesInfo3DProviderBase

private class CustomSeriesInfo3DProvider: SCIDefaultXyzSeriesInfo3DProvider {
    private class CustomXyzSerieesTooltip3D: SCIXyzSeriesTooltip3D {
        override func internalUpdate(_ seriesInfo: SCISeriesInfo3D) {
            var tootlipText = "This is Custom Tooltip \n"
            tootlipText += "Vertex id: \((seriesInfo as? SCIXyzSeriesInfo3D)?.vertexId ?? 0)\n"
            tootlipText += "X: \(seriesInfo.formattedXValue.rawString)\n"
            tootlipText += "Y: \(seriesInfo.formattedYValue.rawString)\n"
            tootlipText += "Z: \(seriesInfo.formattedZValue.rawString)"
            text = tootlipText
            setSeriesColor(seriesInfo.seriesColor.colorARGBCode())
        }
    }
    
    override func getSeriesTooltipInternal(seriesInfo: SCISeriesInfo3D, modifierType: AnyClass) -> ISCISeriesTooltip3D {
        if modifierType == SCITooltipModifier3D.self {
            return CustomXyzSerieesTooltip3D(seriesInfo: seriesInfo)
        } else {
            return super.getSeriesTooltipInternal(seriesInfo: seriesInfo, modifierType: modifierType)
        }
    }
}

class CustomSeriesTooltip3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        xAxis.visibleRange = SCIDoubleRange(min: -1.1, max: 1.1)
        
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        yAxis.visibleRange = SCIDoubleRange(min: -1.1, max: 1.1)
        
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        zAxis.visibleRange = SCIDoubleRange(min: -1.1, max: 1.1)
        
        let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
        for _ in 0 ..< 500 {
            let m1: Double = SCDDataManager.randomBool() == true ? -1.0 : 1.0
            let m2: Double = SCDDataManager.randomBool() == true ? -1.0 : 1.0
            
            let x1 = SCDRandomUtil.nextDouble() * m1
            let x2 = SCDRandomUtil.nextDouble() * m2
            
            let temp = 1.0 - x1 * x1 - x2 * x2
            
            let x = 2.0 * x1 * sqrt(temp)
            let y = 2.0 * x2 * sqrt(temp)
            let z = 1.0 - 2.0 * (x1 * x1 + x2 * x2)
            dataSeries.append(x: x, y: y, z: z)
        }
        
        let pointMarker = SCISpherePointMarker3D()
        pointMarker.size = 7.0
        pointMarker.fillColor = 0x88FFFFFF
        
        let rSeries = SCIScatterRenderableSeries3D()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = pointMarker
        rSeries.seriesInfoProvider = CustomSeriesInfo3DProvider()
        
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
        }
    }
}
