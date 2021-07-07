//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LidarPointCloud.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class LidarPointCloud: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    let LIDARTQ38sw = "tq3080_DSM_2M.asc"
    
    let colorMap = SCIColorMap(colors: [SCIColor.fromARGBColorCode(0xFF1E90FF), SCIColor.fromARGBColorCode(0xFF32CD32), .orange, .red, .purple], andStops: [0, 0.2, 0.5, 0.7, 1])
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.axisTitle = "X Distance (metres)"
        xAxis.textFormatting = "0m"
        
        let yAxis = SCINumericAxis3D()
        yAxis.axisTitle = "Y Distance (metres)"
        yAxis.textFormatting = "0m"
        yAxis.visibleRange = SCIDoubleRange(min: 0, max: 50)
        
        let zAxis = SCINumericAxis3D()
        zAxis.axisTitle = "Height (metres)"
        zAxis.textFormatting = "0m"
        
        let scatterSeries = SCIScatterRenderableSeries3D()
        scatterSeries.pointMarker = SCIPixelPointMarker3D()
        
        let surfaceMeshSeries = SCISurfaceMeshRenderableSeries3D()
        surfaceMeshSeries.drawMeshAs = .solidWithContours
        surfaceMeshSeries.meshColorPalette = SCIGradientColorPalette(
            colors: [0xFF1E90FF, 0xFF32CD32, SCIColor.orange.colorARGBCode(), SCIColor.purple.colorARGBCode()],
            stops: [0.0, 0.2, 0.5, 0.7, 1.0]
        )
        surfaceMeshSeries.meshPaletteMode = .heightMapInterpolated
        surfaceMeshSeries.contourStroke = 0xFFF0FFFF
        surfaceMeshSeries.contourStrokeThickness = 2
        surfaceMeshSeries.minimum = 0
        surfaceMeshSeries.maximum = 50
        surfaceMeshSeries.opacity = 0.5
        
        if let lidarData = SCDDataManager.ascData(fromFile: LIDARTQ38sw) {
            scatterSeries.dataSeries = lidarData.createXyzDataSeries()
            scatterSeries.metadataProvider = lidarData.createMetadataProvider(with: colorMap, withinMin: 0, andMax: 50)
            
            surfaceMeshSeries.dataSeries = lidarData.createUniformGridDataSeries()
        }
        
        let zoomExtentsModifier = SCIZoomExtentsModifier3D()
        zoomExtentsModifier.resetPosition = SCIVector3(x: 800, y: 1000, z: 800)
        zoomExtentsModifier.resetTarget = SCIVector3(x: 0, y: 25, z: 0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(items: scatterSeries, surfaceMeshSeries)
            self.surface.chartModifiers.add(items: SCIOrbitModifier3D(), zoomExtentsModifier, SCIPinchZoomModifier3D())
            
            self.surface.camera.position.assignX(800, y: 1000, z: 800)
            self.surface.worldDimensions.assignX(1000, y: 200, z: 1000)
        }
    }
}
