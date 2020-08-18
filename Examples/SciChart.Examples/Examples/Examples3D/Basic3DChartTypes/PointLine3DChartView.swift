//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PointLine3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class PointLine3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
        let pointMetaDataProvider = SCIPointMetadataProvider3D()

        for i in 0 ..< 100 {
            let x = 5 * sin(Double(i))
            let y = Double(i)
            let z = 5 * cos(Double(i))
            dataSeries.append(x: x, y: y, z: z)
            
            let metadata = SCIPointMetadata3D(vertexColor: SCDDataManager.randomColor(), andScale: SCDDataManager.randomScale())
            pointMetaDataProvider.metadata.add(metadata)
        }
        
        let pointMarker = SCISpherePointMarker3D()
        pointMarker.fillColor = 0xffff0000
        pointMarker.size = 5.0
        
        let rSeries = SCIPointLineRenderableSeries3D()
        rSeries.dataSeries = dataSeries
        rSeries.strokeThickness = 1.0
        rSeries.pointMarker = pointMarker
        rSeries.metadataProvider = pointMetaDataProvider
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
        }
    }
}
