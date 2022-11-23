//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DateAxis3DView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DateAxis3DView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    let Temperatures = [
        // day 1
        [
            8, 8, 7, 7, 6, 6, 6, 6,
            6, 6, 6, 7, 7, 7, 8, 9,
            9, 10, 10, 10, 10, 10, 9, 9
        ],
        // day 2
        [
            9, 7, 7, 7, 6, 6, 6, 6,
            7, 7, 8, 9, 9, 12, 15, 16,
            16, 16, 17, 16, 15, 13, 12, 11,
        ],
        // day 3
        [
            11, 10, 9, 11, 7, 7, 7, 9,
            11, 13, 15, 16, 17, 18, 17, 18,
            19, 19, 18, 10, 10, 11, 10, 10
        ],
        // day 4
        [
            11, 10, 11, 10, 11, 10, 10, 11,
            11, 13, 13, 13, 15, 15, 15, 16,
            17, 18, 17, 17, 15, 13, 12, 11
        ],
        // day 5
        [
            13, 14, 12, 12, 11, 12, 12, 12,
            13, 15, 17, 18, 20, 21, 21, 22,
            22, 21, 20, 19, 17, 16, 15, 16
        ],
        // day 6
        [
            16, 16, 16, 15, 14, 14, 14, 12,
            13, 13, 14, 14, 13, 15, 15, 15,
            15, 15, 14, 15, 15, 14, 14, 14
        ],
        // day 7
        [
            14, 15, 14, 13, 14, 13, 13, 14,
            14, 16, 18, 17, 16, 18, 20, 19,
            16, 16, 16, 16, 15, 14, 13, 12
        ]
    ]
    
    override func initExample() {
        let xAxis = SCIDateAxis3D()
        xAxis.subDayTextFormatting = "HH:mm"
        xAxis.maxAutoTicks = 8
        
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        
        let zAxis = SCIDateAxis3D()
        xAxis.textFormatting = "dd MMM"
        xAxis.maxAutoTicks = 8

        let daysCount = 7
        let measurementsCount = 24
        
        let ds = SCIWaterfallDataSeries3D(xType: .date, yType: .double, zType: .date, xSize: measurementsCount, zSize: daysCount)
        ds.set(startX: NSDate(year: 2019, month: 5, day: 1).toDate())
        ds.set(stepX: Date(timeIntervalSince1970: SCIDateIntervalUtil.fromMinutes(30)))
        ds.set(startZ: NSDate(year: 2019, month: 5, day: 1).toDate())
        ds.set(stepZ: Date(timeIntervalSince1970: SCIDateIntervalUtil.fromDays(1)))
        
        for z in 0 ..< daysCount {
            let temperatures = Temperatures[z]
            for x in 0 ..< measurementsCount {
                ds.update(y: temperatures[x], atX: x, z: z)
            }
        }
        
        let palette = SCIGradientColorPalette(
            colors: [0xFFc43360, 0xFFbf7436, 0xFFe8c667, 0xFFb4efdb, 0xFF68bcae],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0]
        )
        
        let rSeries = SCIWaterfallRenderableSeries3D()
        rSeries.dataSeries = ds
        rSeries.stroke = 0xFF274b92
        rSeries.strokeThickness = 1.0
        rSeries.sliceThickness = 2.0
        rSeries.yColorMapping = palette
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
        }
    }
}
