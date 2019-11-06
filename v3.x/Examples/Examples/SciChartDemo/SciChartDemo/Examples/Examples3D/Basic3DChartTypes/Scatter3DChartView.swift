//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// Scatter3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class Scatter3DChartView: SingleChartLayout3D {
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
        for _ in 0 ..< 200 {
            let x = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            let y = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            let z = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            dataSeries.append(x: x, y: y, z: z)
        }
        
        let pointMarker = SCISpherePointMarker3D()
        pointMarker.fillColor = UIColor.red.colorARGBCode()
        pointMarker.size = 10.0
        
        let rs = SCIScatterRenderableSeries3D()
        rs.dataSeries = dataSeries
        rs.pointMarker = pointMarker
        rs.selectedVertexColor = 0xFF00FF00
        rs.metadataProvider = SCIDefaultSelectableMetadataProvider3D(seriesType: SCIScatterRenderableSeries3D.self)
       
        let orbitModifier = SCIOrbitModifier3D()
        orbitModifier.gestureRecognizer?.minimumNumberOfTouches = 2
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rs)
            self.surface.chartModifiers.add(ExampleViewBase.createDefault3DModifiers())
        }
    }
}
