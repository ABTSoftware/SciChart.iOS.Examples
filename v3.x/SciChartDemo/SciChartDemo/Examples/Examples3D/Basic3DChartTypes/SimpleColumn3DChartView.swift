//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SimpleColumn3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class SimpleColumn3DChartView: SingleChartLayout3D {
    
    private let Count: Int = 15;
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
        let pointMetaDataProvider = SCIPointMetadataProvider3D()
        
        for i in 1 ..< Count {
            for j in 1..<Count {
                if (i != j) && (i % 3) == 0 && (j % 3) == 0 {
                    let y = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
                    dataSeries.append(x: i, y: y, z: j)

                    let metadata = SCIPointMetadata3D(vertexColor: SCDDataManager.randomColor(), andScale: SCDDataManager.randomScale())
                    pointMetaDataProvider.metadata.add(metadata)
                }
            }
        }
        
        let rs = SCIColumnRenderableSeries3D()
        rs.dataSeries = dataSeries
        rs.metadataProvider = pointMetaDataProvider
        rs.columnFixedSize = 20.0

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rs)
            self.surface.chartModifiers.add(ExampleViewBase.createDefault3DModifiers())
        }
    }
}
