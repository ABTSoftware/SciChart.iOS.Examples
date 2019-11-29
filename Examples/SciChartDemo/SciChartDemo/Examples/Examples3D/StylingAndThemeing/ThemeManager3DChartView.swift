//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ThemeManager3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ThemeManager3DChartView: TopPanel3DChartLayout {
    
    override func commonInit() {
        let panel = SingleButtonPanel()
        panel.button?.setTitle("Select Theme", for: .normal)
        panel.button?.addTarget(self, action: #selector(changeTheme(_:)), for: .touchUpInside)
        
        self.panel = panel
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
        let pointMetaDataProvider = SCIPointMetadataProvider3D()

        for _ in 0 ..< 1250 {
            let x = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            let y = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            let z = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            dataSeries.append(x: x, y: y, z: z)
            
            let metadata = SCIPointMetadata3D(vertexColor: SCDDataManager.randomColor(), andScale: SCDDataManager.randomScale())
            pointMetaDataProvider.metadata.add(metadata)
        }
        
        let pointMarker = SCISpherePointMarker3D()
        pointMarker.fillColor = UIColor.red.colorARGBCode()
        pointMarker.size = 2.0
        
        let rs = SCIScatterRenderableSeries3D()
        rs.dataSeries = dataSeries
        rs.pointMarker = pointMarker
        rs.selectedVertexColor = 0xFF00FF00
        rs.metadataProvider = pointMetaDataProvider
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rs)
            self.surface.chartModifiers.add(ExampleViewBase.createDefault3DModifiers())
        }
    }
    
    @objc func changeTheme(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Theme", message: "", preferredStyle: .actionSheet)
        
        let themeNames = ["Black Steel", "Bright Spark", "Chrome", "Chart V4 Dark", "Electric", "Expression Dark", "Expression Light", "Oscilloscope"]
        let themeKeys = [SCIChart_BlackSteelStyleKey, SCIChart_Bright_SparkStyleKey, SCIChart_ChromeStyleKey, SCIChart_SciChartv4DarkStyleKey, SCIChart_ElectricStyleKey, SCIChart_ExpressionDarkStyleKey, SCIChart_ExpressionLightStyleKey, SCIChart_OscilloscopeStyleKey]
        
        for themeName: String in themeNames {
            let actionTheme = UIAlertAction(title: themeName, style: .default, handler: { (action: UIAlertAction) -> Void in
                let themeKey = themeKeys[themeNames.index(of: themeName)!]
                SCIThemeManager.applyTheme(to: self.surface, withThemeKey: themeKey)
                sender.setTitle(themeName, for: .normal)
            })
            alertController.addAction(actionTheme)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let controller = alertController.popoverPresentationController {
            controller.sourceView = self
            controller.sourceRect = sender.frame
        }

        self.window!.rootViewController!.presentedViewController!.present(alertController, animated: true, completion: nil)
    }    
}
