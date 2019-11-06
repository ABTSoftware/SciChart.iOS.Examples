//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineLineRenderableSeries.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCIXyRenderableSeriesBase

class SplineLineRenderableSeries: SCIXyRenderableSeriesBase {
    lazy var isSplineEnabledProperty = SCISmartPropertyBool(listener: boolInvalidateElementListener, defaultValue: true)
    lazy var upSampleFactorProperty = SCISmartPropertyInt(listener: intInvalidateElementListener, defaultValue: 10)
    
    let splineXCoords = SCIFloatValues()
    let splineYCoords = SCIFloatValues()
    
    override init() {
        let hitProvider = SCICompositeHitProvider(provider1: SCIPointMarkerHitProvider(), provider2: SCILineHitProvider())
        super.init(renderPassData: SCILineRenderPassData(), hitProvider: hitProvider, nearestPointProvider: SCINearestXyPointProvider())
    }
    
    var isSplineEnabled: Bool {
        get { return isSplineEnabledProperty.value }
        set(value) { isSplineEnabledProperty.setStrongValue(value) }
    }
    
    var upSampleFactor : Int {
        get { return Int(upSampleFactorProperty.value) }
        set(value) { upSampleFactorProperty.setStrongValue(Int32(value)) }
    }
    
    override func disposeCachedData() {
        super.disposeCachedData()
        
        splineXCoords.dispose()
        splineYCoords.dispose()
    }

    override func internalDraw(with renderContext: ISCIRenderContext2D!, assetManager: ISCIAssetManager2D!, renderPassData: ISCISeriesRenderPassData!) {
        // Don't draw transparent series
        guard self.opacity == 0 else { return }
        guard let strokeStyle = self.strokeStyle else { return }
        guard strokeStyle.isVisible else { return }
        
        let rpd = renderPassData as! SCILineRenderPassData
        let linesStripDrawingContext = SCIDrawingContextFactory.linesStripDrawingContext
        
        let pen = assetManager.pen(with: strokeStyle, andOpacity: opacity)
        computeSplineSeries(splineXCoords: splineXCoords, splineYCoords: splineYCoords, renderPassData: rpd, isSplineEnabled: self.isSplineEnabled, upSampleFactor: self.upSampleFactor)
        
        let digitalLine = rpd.isDigitalLine
        let closeGaps = rpd.closeGaps
        
        let drawingManager = services.getServiceOfType(ISCISeriesDrawingManager.self) as! ISCISeriesDrawingManager
        drawingManager.beginDraw(with: renderContext, renderPassData: rpd)
        
        drawingManager.iterateLines(with: linesStripDrawingContext, pathColor: pen, xCoords: splineXCoords, yCoords: splineYCoords, isDigitalLine: digitalLine, closeGaps: closeGaps)
        
        drawingManager.endDraw()
        
        drawPointMarkers(with: renderContext, assetManager: assetManager, xCoords: rpd.xCoords, yCoords: rpd.yCoords)
    }
    
    fileprivate func computeSplineSeries(splineXCoords: SCIFloatValues, splineYCoords: SCIFloatValues, renderPassData: SCILineRenderPassData, isSplineEnabled: Bool, upSampleFactor: Int) {
        if (!isSplineEnabled) { return }
        
        let count = currentRenderPassData.pointsCount
        let splineCount = count * upSampleFactor
        
        splineXCoords.count = splineCount
        splineYCoords.count = splineCount
        
        let x = renderPassData.xCoords.itemsArray
        let y = renderPassData.yCoords.itemsArray
        
        var xs = splineXCoords.itemsArray
        let stepSize = (x[x.count - 1] - x[0]) / Float(splineCount - 1)
        
        // set spline xCoords
        for i in 0..<splineCount {
            xs[Int(i)] = x[0] + Float(i) * stepSize
        }
        
        let cubicSpline = CubicSpline()
        let ys = cubicSpline.fitAndEval(x: x, y: y, xs: xs, startSlope: Float.nan, endSlope: Float.nan)
        
        splineXCoords.clear()
        splineYCoords.clear()
        splineXCoords.add(values: xs)
        splineYCoords.add(values: ys.itemsArray)
    }
}
