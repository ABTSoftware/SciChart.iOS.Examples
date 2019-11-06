//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UniformImpulse3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class UniformImpulse3DChartView: SingleChartLayout3D {
    
    private let Count = 15;
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.visibleRange = SCIDoubleRange(min: 0.0, max: 0.5)
        
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let ds = SCIUniformGridDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: Count, zSize: Count)
        for x in 0 ..< Count {
            for z in 0 ..< Count {
                let y = sin(Double(x) * 0.25) / Double((z + 1) * 2)
                ds.update(y: y, atX: x, z: z)
            }
        }

        let pointMarker = SCISpherePointMarker3D()
        pointMarker.fillColor = 0xFF1E90FF
        pointMarker.size = 5.0
    
        let rs = SCIImpulseRenderableSeries3D()
        rs.dataSeries = ds
        rs.stroke = 0xFF1E90FF
        rs.strokeThickness = 2.0
        rs.pointMarker = pointMarker
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rs)
            self.surface.chartModifiers.add(ExampleViewBase.createDefault3DModifiers())
        }
    }
}
