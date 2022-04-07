//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SimpleWaterfall3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SimpleWaterfall3DChartView: SCDWaterfall3DChartViewControllerBase {
    
    let PointsPerSlice = 128;
    let SliceCount = 20;
    let radixTransform = SCDRadix2FFT(size: 128)
    
    override func initExample() {
        let ds = SCIWaterfallDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: PointsPerSlice, zSize: SliceCount)
        ds.set(startX: 10.0)
        ds.set(startZ: 1.0)
        
        fill(dataSeries: ds)
        
        rSeries = SCIWaterfallRenderableSeries3D()
        rSeries.dataSeries = ds
        setupColorPalettes()
        setupPointMarker()
        setupSliceThickness()
        rSeries.metadataProvider = SCIDefaultSelectableMetadataProvider3D()
        rSeries.opacity = 0.8;
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = SCINumericAxis3D()
            self.surface.yAxis = SCINumericAxis3D()
            self.surface.zAxis = SCINumericAxis3D()
            self.surface.zAxis.autoRange = .always
            
            self.surface.renderableSeries.add(self.rSeries)
            self.surface.chartModifiers.add(items: SCDExampleBaseViewController.createDefaultModifiers3D(), SCIVertexSelectionModifier3D())
        }
    }
    
    func fill(dataSeries: SCIWaterfallDataSeries3D) {
        let count = PointsPerSlice * 2;
        
        let re = UnsafeMutablePointer<Double>.allocate(capacity: count)
        let im = UnsafeMutablePointer<Double>.allocate(capacity: count)
        defer {
            re.deallocate()
            im.deallocate()
        }
        
        for sliceIndex in 0 ..< SliceCount {
            for i in 0 ..< count {
                re[i] = 2.0 * sin(Double.pi * Double(i) / 10.0) +
                    5.0 * sin(Double.pi * Double(i) / 5.0) +
                    2.0 * Double.random(in: 0.0 ... 1.0)
                im[i] = -10.0;
            }
            
            radixTransform.run(withReals: re, imaginaries: im)
            let scaleCoef = pow(1.5, Double(sliceIndex) * 0.3) / pow(1.5, Double(SliceCount) * 0.3)
            
            for pointIndex in 0 ..< PointsPerSlice {
                let reValue = re[pointIndex]
                let imValue = im[pointIndex]
                
                let mag = sqrt(reValue * reValue + imValue * imValue)
                var yVal = Double(Int.random(in: 0 ..< 10) + 10) * log10(mag / Double(PointsPerSlice))
                
                yVal = (yVal < -25 || yVal > -5)
                    ? (yVal < -25) ? -25.0 : Double(Int.random(in: 0 ..< 9) - 6)
                    : yVal
                
                dataSeries.update(y: -yVal * scaleCoef, atX: pointIndex, z: sliceIndex)
            }
        }
    }
}
