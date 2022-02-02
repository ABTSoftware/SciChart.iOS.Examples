//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2022. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnimatingLineChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation
import SciChart.Protected.SCIBaseRenderPassDataTransformation

class AnimatingLineChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    private var timer: Timer?
    private var isRunning = true
    private var currentXValue: Double = 0
    
    private let fifoCapacity = 20
    private let timeInterval: TimeInterval = 1
    private let animationDuration: TimeInterval = 0.5
    private let visibleRangeMax: Double = 10
    private let maxYValue: Double = 100
    
    private let rSeries = SCIFastLineRenderableSeries()
    private let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { false }
    
    override func provideExampleSpecificToolbarItems() -> [ISCDToolbarItem] {
        return [SCDToolbarButtonsGroup(toolbarItems: [
            SCDToolbarButton(title: "Start", image: SCIImage(named: "chart.play"), andAction: { [weak self] in self?.isRunning = true }),
            SCDToolbarButton(title: "Pause", image: SCIImage(named: "chart.pause"), andAction: { [weak self] in self?.isRunning = false }),
            SCDToolbarButton(title: "Stop", image: SCIImage(named: "chart.stop"), andAction: { [weak self] in
                self?.isRunning = false
                self?.resetChart()
            })
        ])]
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange(min: -1, max: Double(visibleRangeMax))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.visibleRange = SCIDoubleRange(min: 0, max: maxYValue)
        
        dataSeries.fifoCapacity = fifoCapacity
        
        rSeries.dataSeries = dataSeries
        rSeries.strokeStyle = SCISolidPenStyle(color: 0xFF4083B7, thickness: 6)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(self.rSeries)
        }
        
        addPointAnimated()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc func updateData() {
        if !isRunning { return }
            
        addPointAnimated()
    }
    
    private func addPointAnimated() {
        SCIUpdateSuspender.usingWith(surface) { [weak self] in
            guard let self = self else { return }
            
            self.dataSeries.append(x: self.currentXValue, y: SCDRandomUtil.nextDouble() * self.maxYValue)
        }
        
        SCIAnimations.animate(
            rSeries,
            with: AppendedPointTransformation(),
            duration: animationDuration,
            andEasingFunction: SCICubicEase()
        )
        
        currentXValue += timeInterval
        
        animateVisibleRangeIfNeeded()
    }
    
    private func animateVisibleRangeIfNeeded() {
        if currentXValue > visibleRangeMax {
            let xAxis = surface.xAxes.item(at: 0)
            let newRange = SCIDoubleRange(
                min: xAxis.visibleRange.minAsDouble + timeInterval,
                max: xAxis.visibleRange.maxAsDouble + timeInterval
            )
            xAxis.animateVisibleRange(to: newRange, withDuration: Float(animationDuration))
        }
    }
    
    private func resetChart() {
        SCIUpdateSuspender.usingWith(self.surface) {
            self.dataSeries.clear()
        }
        self.currentXValue = 0
        self.surface.xAxes.firstOrDefault()?.animateVisibleRange(
            to: SCIDoubleRange(min: -1, max: Double(self.visibleRangeMax)),
            withDuration: Float(self.animationDuration)
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    private class AppendedPointTransformation: SCIBaseRenderPassDataTransformation<SCILineRenderPassData> {
        private let originalXCoordinates = SCIFloatValues()
        private let originalYCoordinates = SCIFloatValues()
        
        init() {
            super.init(renderPassDataType: SCILineRenderPassData.self)
        }
        
        override func saveOriginalData() {
            guard let renderPassData = self.renderPassData, renderPassData.isValid else { return }
            
            SCITransformationHelpers.copyData(fromSource: renderPassData.xCoords, toDest: originalXCoordinates)
            SCITransformationHelpers.copyData(fromSource: renderPassData.yCoords, toDest: originalYCoordinates)
        }
        
        override func applyTransformation() {
            guard
                let renderPassData = self.renderPassData,
                    renderPassData.isValid,
                let xCalculator = renderPassData.xCoordinateCalculator,
                let yCalculator = renderPassData.yCoordinateCalculator
            else { return }
             
            let count = renderPassData.pointsCount
            
            let firstXStart = xCalculator.getCoordinate(0)
            let xStart = count <= 1 ? firstXStart : originalXCoordinates.getValueAt(count - 2)
            let xFinish = originalXCoordinates.getValueAt(count - 1)
            let additionalX = xStart + (xFinish - xStart) * currentTransformationValue
            renderPassData.xCoords.set(additionalX, at: count - 1)
            
            let firstYStart = yCalculator.getCoordinate(0)
            let yStart = count <= 1 ? firstYStart : originalYCoordinates.getValueAt(count - 2)
            let yFinish = originalYCoordinates.getValueAt(count - 1)
            let additionalY = yStart + (yFinish - yStart) * currentTransformationValue
            renderPassData.yCoords.set(additionalY, at: count - 1)
        }
        
        override func discardTransformation() {
            guard let renderPassData = self.renderPassData else { return }
            
            SCITransformationHelpers.copyData(fromSource: originalXCoordinates, toDest: renderPassData.xCoords)
            SCITransformationHelpers.copyData(fromSource: originalYCoordinates, toDest: renderPassData.yCoords)
        }
        
        override func onInternalRenderPassDataChanged() {
            applyTransformation()
        }
    }
}
