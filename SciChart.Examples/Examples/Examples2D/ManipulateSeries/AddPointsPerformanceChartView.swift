//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddPointsPerformanceChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class AddPointsPerformanceChartView: SCDSingleChartWithTopPanelViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    private var panelItems: [ISCDToolbarItemModel] {
        return [
            SCDToolbarButton(title: "+10K", image: nil, andAction: { [weak self] in self?.appendPoints(10000) }),
            SCDToolbarButton(title: "+100K", image: nil, andAction: { [weak self] in self?.appendPoints(100000) }),
            SCDToolbarButton(title: "+1MLN", image: nil, andAction: { [weak self] in self?.appendPoints(1000000) }),
            SCDToolbarButton(title: "Clear", image: nil, andAction: { [weak self] in self?.surface.renderableSeries.clear() }),
        ]
    }
    
#if os(OSX)
    override func provideExampleSpecificToolbarItems() -> [ISCDToolbarItem] {
        return [SCDToolbarButtonsGroup(toolbarItems: panelItems)]
    }
#elseif os(iOS)
    override func providePanel() -> SCIView {
        return SCDButtonsTopPanel(toolbarItems: self.panelItems)
    }
#endif

    override func initExample() {
        surface.xAxes.add(SCINumericAxis())
        surface.yAxes.add(SCINumericAxis())
        surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
    }

    fileprivate func appendPoints(_ count: Int) {
        let SCDDoubleSeries = SCDRandomWalkGenerator().setBias(randf(0.0, 1.0) / 100).getRandomWalkSeries(count)
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.append(x: SCDDoubleSeries.xValues, y: SCDDoubleSeries.yValues)
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeStyle = SCISolidPenStyle(color: SCIColor.init(red: CGFloat(randf(0, 1)), green: CGFloat(randf(0, 1)), blue: CGFloat(randf(0, 1)), alpha: CGFloat(randf(0, 1))), thickness: 1)
        
        surface.renderableSeries.add(rSeries)
        surface.animateZoomExtents(withDuration: 0.5)
    }
    
    fileprivate func clearSeries() {
        surface.renderableSeries.clear()
    }
}
