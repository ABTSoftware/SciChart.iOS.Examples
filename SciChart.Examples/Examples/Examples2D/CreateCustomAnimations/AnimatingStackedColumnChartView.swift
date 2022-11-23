//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnimatingStackedColumnChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCIBaseRenderPassDataTransformation
import SciChart

class AnimatingStackedColumnChartView: SCDSingleChartWithTopPanelViewController<SCIChartSurface> {
    private var timer: Timer?
    private var isRunning = true
    private let timeInterval: TimeInterval = 1
    
    private let animationDuration: TimeInterval = 0.5
    private let xValuesCount = 12
    private let maxYValue: Double = 50
    
    private let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
    private let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
    
    private let rSeries1 = SCIStackedColumnRenderableSeries()
    private let rSeries2 = SCIStackedColumnRenderableSeries()
    
    private lazy var animator1: SCIValueAnimator = createAnimator(series: rSeries1)
    private lazy var animator2: SCIValueAnimator = createAnimator(series: rSeries2)
    
    private lazy var refreshDataButton: SCDToolbarButton = {
        SCDToolbarButton(title: "Refresh data", image: nil, andAction: { [weak self] in
            guard let self = self else { return }
            
            if self.isRunning {
                self.timer?.invalidate()
                self.refreshData()
                self.timer = self.createTimer()
            } else {
                self.refreshData()
            }
        })
    }()
    
    override func provideExampleSpecificToolbarItems() -> [ISCDToolbarItem] {
        var items: [ISCDToolbarItem] = [SCDToolbarButtonsGroup(toolbarItems: [
            SCDToolbarButton(title: "Start", image: SCIImage(named: "chart.play"), andAction: { [weak self] in self?.isRunning = true }),
            SCDToolbarButton(title: "Pause", image: SCIImage(named: "chart.pause"), andAction: { [weak self] in self?.isRunning = false })
        ])]
        
#if os(OSX)
        items.insert(refreshDataButton, at: 0)
#endif
        return items
    }
    
#if os(iOS)
    override func providePanel() -> SCIView {
        return refreshDataButton.createView()
    }
#endif
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { false }
    
    override func initExample() {
        configureRenderableSeries(rSeries: rSeries1, dataSeries: dataSeries1, fillColor: 0xff47bde6)
        configureRenderableSeries(rSeries: rSeries2, dataSeries: dataSeries2, fillColor: 0xffe8c667)
        
        fillWithInitialData()
                
        let columnCollection = SCIVerticallyStackedColumnsCollection()
        columnCollection.add(rSeries1)
        columnCollection.add(rSeries2)
        
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.visibleRange = SCIDoubleRange(min: 0, max: maxYValue * 2)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(columnCollection)
        }
        
        timer = createTimer()
    }
    
    private func configureRenderableSeries(
        rSeries: SCIStackedColumnRenderableSeries,
        dataSeries: SCIXyDataSeries,
        fillColor: UInt32
    ) {
        rSeries.dataSeries = dataSeries
        rSeries.fillBrushStyle = SCISolidBrushStyle(color: fillColor)
        rSeries.strokeStyle = SCISolidPenStyle(color: fillColor, thickness: 1.0)
    }
    
    private func fillWithInitialData() {
        SCIUpdateSuspender.usingWith(surface) { [weak self] in
            guard let self = self else { return }
        
            for i in 0..<self.xValuesCount {
                self.dataSeries1.append(x: i, y: self.getRandomYValue())
                self.dataSeries2.append(x: i, y: self.getRandomYValue())
            }
        }
        
        refreshData()
    }
    
    private func createTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc private func updateData() {
        if !isRunning { return }
        
        refreshData()
    }
    
    private func refreshData() {
        animator1.cancel()
        animator2.cancel()
        
        SCIUpdateSuspender.usingWith(surface) { [weak self] in
            guard let self = self else { return }
            
            for i in 0..<self.xValuesCount {
                self.dataSeries1.update(y: self.getRandomYValue(), at: i)
                self.dataSeries2.update(y: self.getRandomYValue(), at: i)
            }
        }
        
        animator1.start(withDuration: animationDuration)
        animator2.start(withDuration: animationDuration)
    }
    
    private func getRandomYValue() -> Double {
        SCDRandomUtil.nextDouble() * maxYValue
    }
    
    private func createAnimator(series: ISCIRenderableSeries) -> SCIValueAnimator {
        let animator = SCIAnimations.createAnimator(for: series, with: UpdatedPointTransformation())
        animator.easingFunction = SCICubicEase()
        
        return animator
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    private class UpdatedPointTransformation: SCIBaseRenderPassDataTransformation<SCIStackedColumnRenderPassData> {
        private let startYCoordinates = SCIFloatValues()
        private let startPrevSeriesYCoordinates = SCIFloatValues()

        private let originalYCoordinates = SCIFloatValues()
        private let originalPrevSeriesYCoordinates = SCIFloatValues()
        
        init() {
            super.init(renderPassDataType: SCIStackedColumnRenderPassData.self)
        }
        
        override func saveOriginalData() {
            guard
                let renderPassData = self.renderPassData,
                renderPassData.isValid
            else { return }
            
            SCITransformationHelpers.copyData(fromSource: renderPassData.yCoords, toDest: originalYCoordinates)
            SCITransformationHelpers.copyData(fromSource: renderPassData.prevSeriesYCoords, toDest: originalPrevSeriesYCoordinates)
        }
        
        override func applyTransformation() {
            guard
                let renderPassData = self.renderPassData,
                    renderPassData.isValid
            else { return }
            
            let count = renderPassData.pointsCount
            
            if startPrevSeriesYCoordinates.count != count ||
                startYCoordinates.count != count ||
                originalYCoordinates.count != count ||
                originalPrevSeriesYCoordinates.count != count {
                return
            }

            for i in 0..<count {
                let startYCoord = startYCoordinates.getValueAt(i)
                let originalYCoordinate = originalYCoordinates.getValueAt(i)
                let additionalY = startYCoord + (originalYCoordinate - startYCoord) * currentTransformationValue
                
                let startPrevSeriesYCoords = startPrevSeriesYCoordinates.getValueAt(i)
                let originalPrevSeriesYCoordinate = originalPrevSeriesYCoordinates.getValueAt(i)
                let additionalPrevSeriesY = startPrevSeriesYCoords + (originalPrevSeriesYCoordinate - startPrevSeriesYCoords) * currentTransformationValue

                renderPassData.yCoords.set(additionalY, at: i)
                renderPassData.prevSeriesYCoords.set(additionalPrevSeriesY, at: i)
            }
        }
        
        override func discardTransformation() {
            guard let renderPassData = self.renderPassData else { return }
            
            SCITransformationHelpers.copyData(fromSource: originalYCoordinates, toDest: renderPassData.yCoords)
            SCITransformationHelpers.copyData(fromSource: originalPrevSeriesYCoordinates, toDest: renderPassData.prevSeriesYCoords)
        }
        
        override func onInternalRenderPassDataChanged() {
            applyTransformation()
        }
        
        override func onAnimationEnd() {
            super.onAnimationEnd()
            
            SCITransformationHelpers.copyData(fromSource: originalYCoordinates, toDest: startYCoordinates)
            SCITransformationHelpers.copyData(fromSource: originalPrevSeriesYCoordinates, toDest: startPrevSeriesYCoordinates)
        }
    }
}
