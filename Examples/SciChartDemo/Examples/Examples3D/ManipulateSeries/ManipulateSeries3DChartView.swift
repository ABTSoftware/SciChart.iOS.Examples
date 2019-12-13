//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ManipulateSeries3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ManipulateSeries3DChartView: TopPanel3DChartLayout {
    
    private let MaxSeriesCount = 15
    private let MaxPointsCount = 15

    override func commonInit() {
        let panel = AddRemoveSeriesPanel()
        panel.addSeriesButton?.addTarget(self, action: #selector(onAddSeries(_:)), for: .touchUpInside)
        panel.removeSeriesButton?.addTarget(self, action: #selector(onRemoveSeries(_:)), for: .touchUpInside)
        panel.clearButton?.addTarget(self, action: #selector(onClear(_:)), for: .touchUpInside)
        
        self.panel = panel
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        zAxis.autoRange = .always
        
        let legendModifier = SCILegendModifier3D()
        legendModifier.showSeriesMarkers = false
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.chartModifiers.add(items: ExampleViewBase.createDefault3DModifiers(), legendModifier)
        }
    }
    
    @objc func onAddSeries(_ sender: UIButton) {
        let seriesCollection = surface.renderableSeries
        guard surface.renderableSeries.count < MaxPointsCount else { return }
        
        let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
        let pointMetaDataProvider = SCIPointMetadataProvider3D()
        
        for _ in 0 ..< MaxPointsCount {
            let x = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            let y = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            let z = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            dataSeries.append(x: x, y: y, z: z)
            
            let metadata = SCIPointMetadata3D(vertexColor: SCDDataManager.randomColor(), andScale: SCDDataManager.randomScale())
            pointMetaDataProvider.metadata.add(metadata)
        }
        
        let rs = SCIScatterRenderableSeries3D()
        rs.dataSeries = dataSeries
        rs.metadataProvider = pointMetaDataProvider
        rs.pointMarker = SCIEllipsePointMarker3D()

        let randValue = arc4random_uniform(5)
        switch randValue {
        case 0:
            rs.pointMarker = SCIEllipsePointMarker3D()
        case 1...2:
            rs.pointMarker = SCIPyramidPointMarker3D()
        case 3...4:
            rs.pointMarker = SCISpherePointMarker3D()
        default:
            break;
        }
        
        SCIUpdateSuspender.usingWith(surface) {
            seriesCollection.add(rs)
        }
        
        let index = seriesCollection.index(of: rs)
        dataSeries.seriesName = "Series \(index)"
    }
    
    @objc func onRemoveSeries(_ sender: UIButton) {
        if !surface.renderableSeries.isEmpty {
            SCIUpdateSuspender.usingWith(surface) {
                self.surface.renderableSeries.remove(at: 0)
            }
        }
    }
    
    @objc func onClear(_ sender: UIButton) {
        if !surface.renderableSeries.isEmpty {
            SCIUpdateSuspender.usingWith(surface) {
                self.surface.renderableSeries.clear()
            }
        }
    }
}
