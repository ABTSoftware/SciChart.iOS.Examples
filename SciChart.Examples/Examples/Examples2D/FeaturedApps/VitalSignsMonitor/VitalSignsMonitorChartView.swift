//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// VitalSignsMonitorChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import RxSwift

class VitalSignsMonitorChartView: SCDVitalSignsLayoutViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    static let FIFO_CAPACITY = 7850
    
    private let ecgDataSeries = newDataSeries(FIFO_CAPACITY)
    private let ecgSweepDataSeries = newDataSeries(FIFO_CAPACITY)
    private let bloodPressureDataSeries = newDataSeries(FIFO_CAPACITY)
    private let bloodPressureSweepDataSeries = newDataSeries(FIFO_CAPACITY)
    private let bloodVolumeDataSeries = newDataSeries(FIFO_CAPACITY)
    private let bloodVolumeSweepDataSeries = newDataSeries(FIFO_CAPACITY)
    private let bloodOxygenationDataSeries = newDataSeries(FIFO_CAPACITY)
    private let bloodOxygenationSweepDataSeries = newDataSeries(FIFO_CAPACITY)
    private let lastEcgSweepDataSeries = newDataSeries(1)
    private let lastBloodPressureDataSeries = newDataSeries(1)
    private let lastBloodVolumeDataSeries = newDataSeries(1)
    private let lastBloodOxygenationSweepDataSeries = newDataSeries(1)
    
    private let indicatorsProvider = VitalSignsIndicatorsProvider()
    private var dataBatch: EcgDataBatch = EcgDataBatch()
    private var chartDisposable: Disposable?
    private var indicatorsDisposable: Disposable?
        
    deinit {
        chartDisposable?.dispose()
        indicatorsDisposable?.dispose()
    }
    
    override func initExample() {
        chartDisposable?.dispose()
        indicatorsDisposable?.dispose()

        setUpChart()
        setupIndicators()

        let dataProvider = DefaultVitalSignsDataProvider()
        chartDisposable = dataProvider
            .getData()
            .buffer(timeSpan: .milliseconds(16), count: Int.max, scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] ecgData in
                guard let self = self else { return }
                if ecgData.isEmpty { return }

                self.dataBatch.updateData(ecgData)
                SCIUpdateSuspender.usingWith(self.surface) {
                    self.updateDataSeries()
                }
            })
            .subscribe()
        
        updateIndicators(time: 0)
        
        indicatorsDisposable = Observable
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] in
                self?.updateIndicators(time: $0)
            })
            .subscribe()
    }
    
    private func setupIndicators() {
        let progressBackgroundColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        let bpBarStyle = SCDProgressBarStyle(isVertical: false, max: 10, spacing: 2, progressBackgroundColor: progressBackgroundColor, progressColor: SCIColor.fromARGBColorCode(0xFFFFFF00), barSize: 3)
        
        bpBar.setStyle(bpBarStyle)
        
        let svBarStyle = SCDProgressBarStyle(isVertical: true, max: 12, spacing: 2, progressBackgroundColor: .clear, progressColor: SCIColor.fromARGBColorCode(0xFFB0C4DE), barSize: 3)
        
        svBar1.setStyle(svBarStyle)
        svBar2.setStyle(svBarStyle)
    }
    
    private func updateIndicators(time: Int) {
        heartImageView.isHidden = time % 2 == 0

        if (time % 5 == 0) {
            indicatorsProvider.update();

            bpmValueLabel.text = indicatorsProvider.bpmValue
            bpValueLabel.text = indicatorsProvider.bpValue
            bpBar.setProgress(indicatorsProvider.bpbValue)

            bvValueLabel.text = indicatorsProvider.bvValue
            svBar1.setProgress(indicatorsProvider.bvBar1Value)
            svBar2.setProgress(indicatorsProvider.bvBar2Value)

            spoValueLabel.text = indicatorsProvider.spoValue
            spoClockValueLabel.text = indicatorsProvider.spoClockValue
        }
    }
    
    private func updateDataSeries() {
        let xValues = dataBatch.xValues;

        ecgDataSeries.append(x: xValues, y: dataBatch.ecgHeartRateValuesA)
        ecgSweepDataSeries.append(x: xValues, y: dataBatch.ecgHeartRateValuesB)

        bloodPressureDataSeries.append(x: xValues, y: dataBatch.bloodPressureValuesA)
        bloodPressureSweepDataSeries.append(x: xValues, y: dataBatch.bloodPressureValuesB)

        bloodOxygenationDataSeries.append(x: xValues, y: dataBatch.bloodOxygenationA)
        bloodOxygenationSweepDataSeries.append(x: xValues, y: dataBatch.bloodOxygenationB)

        bloodVolumeDataSeries.append(x: xValues, y: dataBatch.bloodVolumeValuesA)
        bloodVolumeSweepDataSeries.append(x: xValues, y: dataBatch.bloodVolumeValuesB)

        guard let lastVitalSignsData = dataBatch.lastVitalSignsData else {
            return
        }
        let xValue = lastVitalSignsData.xValue

        lastEcgSweepDataSeries.append(x: xValue, y: lastVitalSignsData.ecgHeartRate)
        lastBloodPressureDataSeries.append(x: xValue, y: lastVitalSignsData.bloodPressure)
        lastBloodOxygenationSweepDataSeries.append(x: xValue, y: lastVitalSignsData.bloodOxygenation)
        lastBloodVolumeDataSeries.append(x: xValue, y: lastVitalSignsData.bloodVolume)
    }
    
    private func setUpChart() {
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange(min: 0, max: 10)
        xAxis.autoRange = .never
        xAxis.drawMinorGridLines = false
        xAxis.drawMajorGridLines = false
        xAxis.isVisible = false
        
        let ecgId = "ecgId"
        let bloodPressureId = "bloodPressureId"
        let bloodVolumeId = "bloodVolumeId"
        let bloodOxygenationId = "bloodOxygenationId"
        
        let yAxisEcg: SCINumericAxis = generateYAxis(ecgId)
        let yAxisPressure: SCINumericAxis = generateYAxis(bloodPressureId)
        let yAxisVolume: SCINumericAxis = generateYAxis(bloodVolumeId)
        let yAxisOxygenation: SCINumericAxis = generateYAxis(bloodOxygenationId)
        
        let heartRateColor: UInt32 = 0xFF42B649
        let bloodPressureColor: UInt32 = 0xFFFFFF00
        let bloodVolumeColor: UInt32 = 0xFFB0C4DE
        let bloodOxygenation: UInt32 = 0xFF6495ED
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxisEcg)
            self.surface.yAxes.add(yAxisPressure)
            self.surface.yAxes.add(yAxisVolume)
            self.surface.yAxes.add(yAxisOxygenation)
            
            self.surface.renderableSeries.add(self.generateLineSeries(yAxisId: ecgId, dataSeries: self.ecgDataSeries, strokeStyle: SCISolidPenStyle(color: heartRateColor, thickness: 2)))
            self.surface.renderableSeries.add(self.generateLineSeries(yAxisId: ecgId, dataSeries: self.ecgSweepDataSeries, strokeStyle: SCISolidPenStyle(color: heartRateColor, thickness: 2)))
            self.surface.renderableSeries.add(self.generateScatterForLastAppendedPoint(yAxisId: ecgId, dataSeries: self.lastEcgSweepDataSeries))
            
            self.surface.renderableSeries.add(self.generateLineSeries(yAxisId: bloodPressureId, dataSeries: self.bloodPressureDataSeries, strokeStyle: SCISolidPenStyle(color: bloodPressureColor, thickness: 2)))
            self.surface.renderableSeries.add(self.generateLineSeries(yAxisId: bloodPressureId, dataSeries: self.bloodPressureSweepDataSeries, strokeStyle: SCISolidPenStyle(color: bloodPressureColor, thickness: 2)))
            self.surface.renderableSeries.add(self.generateScatterForLastAppendedPoint(yAxisId: bloodPressureId, dataSeries: self.lastBloodPressureDataSeries))

            self.surface.renderableSeries.add(self.generateLineSeries(yAxisId: bloodVolumeId, dataSeries: self.bloodVolumeDataSeries, strokeStyle: SCISolidPenStyle(color: bloodVolumeColor, thickness: 2)))
            self.surface.renderableSeries.add(self.generateLineSeries(yAxisId: bloodVolumeId, dataSeries: self.bloodVolumeSweepDataSeries, strokeStyle: SCISolidPenStyle(color: bloodVolumeColor, thickness: 2)))
            self.surface.renderableSeries.add(self.generateScatterForLastAppendedPoint(yAxisId: bloodVolumeId, dataSeries: self.lastBloodVolumeDataSeries))

            self.surface.renderableSeries.add(self.generateLineSeries(yAxisId: bloodOxygenationId, dataSeries: self.bloodOxygenationDataSeries, strokeStyle: SCISolidPenStyle(color: bloodOxygenation, thickness: 2)))
            self.surface.renderableSeries.add(self.generateLineSeries(yAxisId: bloodOxygenationId, dataSeries: self.bloodOxygenationSweepDataSeries, strokeStyle: SCISolidPenStyle(color: bloodOxygenation, thickness: 2)))
            self.surface.renderableSeries.add(self.generateScatterForLastAppendedPoint(yAxisId: bloodOxygenationId, dataSeries: self.lastBloodOxygenationSweepDataSeries))
            
            let layoutManager = SCIDefaultLayoutManager()
            layoutManager.rightOuterAxisLayoutStrategy = RightAlignedOuterVerticallyStackedYAxisLayoutStrategy()
            self.surface.layoutManager = layoutManager
        }
    }
    
    private func generateScatterForLastAppendedPoint(yAxisId: String, dataSeries: ISCIDataSeries) -> ISCIRenderableSeries {
        let pointMarker = SCIEllipsePointMarker()
        pointMarker.size = CGSize(width: 5, height: 5)
        pointMarker.strokeStyle = SCISolidPenStyle(color: .white, thickness: 1)
        pointMarker.fillStyle = SCISolidBrushStyle(color: .white)
        
        let scatterSeries = SCIXyScatterRenderableSeries()
        scatterSeries.dataSeries = dataSeries
        scatterSeries.yAxisId = yAxisId
        scatterSeries.pointMarker = pointMarker
        
        return scatterSeries
    }
    
    private func generateLineSeries(yAxisId: String, dataSeries: ISCIDataSeries, strokeStyle: SCIPenStyle) -> ISCIRenderableSeries {
        let series = SCIFastLineRenderableSeries()
        series.dataSeries = dataSeries
        series.yAxisId = yAxisId
        series.strokeStyle = strokeStyle
        
        // Uncomment to allow trace to dim when the trace is old giving an ECG effect
        // However this is slow in simulator (fast on device)
        // series.paletteProvider = SCDDimTracePaletteProvider()
        
        return series
    }
    
    private func generateYAxis(_ id: String) -> SCINumericAxis {
        let yAxis = SCINumericAxis()
        yAxis.axisId = id
        yAxis.growBy = SCIDoubleRange(min: 0.05, max: 0.05)
        yAxis.autoRange = .always
        yAxis.drawMajorBands = false
        yAxis.drawMinorGridLines = false
        yAxis.drawMajorGridLines = false
        yAxis.axisAlignment = .right
        yAxis.isVisible = false
        
        return yAxis
    }
    
    private static func newDataSeries(_ fifoCapacity: Int) -> SCIXyDataSeries {
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.fifoCapacity = fifoCapacity
        dataSeries.acceptsUnsortedData = true
        
        return dataSeries
    }
}
