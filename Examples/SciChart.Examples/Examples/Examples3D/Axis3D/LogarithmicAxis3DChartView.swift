//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LogarithmicAxis3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class LogarithmicAxis3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    override func initExample() {
        
        let xAxis = SCILogarithmicNumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.drawMajorBands = false
        xAxis.textFormatting = "#.#e+0"
        xAxis.scientificNotation = .logarithmicBase
        
        let yAxis = SCILogarithmicNumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.drawMajorBands = false
        yAxis.textFormatting = "#.0"
        yAxis.scientificNotation = .none
        
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.5, max: 0.5)
        
        let count = 100
        let data = SCDDataManager.getExponentialCurve(withExponent: 1.8, count: 100)
        
        let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
        let pointMetaDataProvider = SCIPointMetadataProvider3D()
        
        for i in 0 ..< count {
            let x = data.xValues.getValueAt(i)
            let y = data.yValues.getValueAt(i)
            let z = SCDDataManager.getGaussianRandomNumber(15, stdDev: 1.5)
            dataSeries.append(x: x, y: y, z: z)
            
            let metadata = SCIPointMetadata3D(vertexColor: SCDDataManager.randomColor(), andScale: SCDDataManager.randomScale())
            pointMetaDataProvider.metadata.add(metadata)
        }
        
        let pointMarker = SCISpherePointMarker3D()
        pointMarker.size = 5.0
        
        let rSeries = SCIPointLineRenderableSeries3D()
        rSeries.dataSeries = dataSeries
        rSeries.strokeThickness = 2.0
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
