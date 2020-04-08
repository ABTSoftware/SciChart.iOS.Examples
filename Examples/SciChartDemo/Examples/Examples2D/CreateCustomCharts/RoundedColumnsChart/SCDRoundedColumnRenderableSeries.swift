//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDRoundedColumnRenderableSeries.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCIFastColumnRenderableSeries

class SCDRoundedColumnRenderableSeries: SCIFastColumnRenderableSeries {
    var topEllipsesBuffer = SCIFloatValues()
    var rectsBuffer = SCIFloatValues()
    var bottomEllipsesBuffer = SCIFloatValues()
    
    override init() {
        let hitProvider = SCIColumnHitProvider()
        super.init(renderPassData: SCIColumnRenderPassData(), hitProvider: hitProvider, nearestPointProvider: SCINearestColumnPointProvider())
    }
    
    override func disposeCachedData() {
        super.disposeCachedData()
        
        topEllipsesBuffer.dispose()
        rectsBuffer.dispose()
        bottomEllipsesBuffer.dispose()
    }
    
    override func internalDraw(with renderContext: ISCIRenderContext2D!, assetManager: ISCIAssetManager2D!, renderPassData: ISCISeriesRenderPassData!) {
        // Don't draw transparent series
        guard self.opacity != 0 else { return }
        guard let fillStyle = self.fillBrushStyle else { return }
        guard fillStyle.isVisible else { return }
        
        let rpd = renderPassData as! SCIColumnRenderPassData
        updateDrawingBuffersWithData(renderPassData: rpd, columnPixelWidth: rpd.columnPixelWidth, zeroLine: rpd.zeroLineCoord)
        
        let brush = assetManager.brush(with: fillStyle)
        renderContext.fillRects(with: brush, points: UnsafeMutablePointer<Float>(mutating: rectsBuffer.itemsArray), start: 0, count: Int32(rectsBuffer.count))
        renderContext.fillEllipses(with: brush, points: UnsafeMutablePointer<Float>(mutating: topEllipsesBuffer.itemsArray), start: 0, count: Int32(topEllipsesBuffer.count))
        renderContext.fillEllipses(with: brush, points: UnsafeMutablePointer<Float>(mutating: bottomEllipsesBuffer.itemsArray), start: 0, count: Int32(bottomEllipsesBuffer.count))
    }
    
    fileprivate func updateDrawingBuffersWithData(renderPassData: SCIColumnRenderPassData, columnPixelWidth: Float, zeroLine: Float) {
        let halfWidth = columnPixelWidth / 2;
        
        topEllipsesBuffer.count = renderPassData.pointsCount * 4
        rectsBuffer.count = renderPassData.pointsCount * 4
        bottomEllipsesBuffer.count = renderPassData.pointsCount * 4
        
        for i in 0 ..< renderPassData.pointsCount {
            let x = renderPassData.xCoords.getValueAt(i)
            let y = renderPassData.yCoords.getValueAt(i)
            
            topEllipsesBuffer.set(x - halfWidth, at: i * 4 + 0)
            topEllipsesBuffer.set(y, at: i * 4 + 1)
            topEllipsesBuffer.set(x + halfWidth, at: i * 4 + 2)
            topEllipsesBuffer.set(y - columnPixelWidth, at: i * 4 + 3)

            rectsBuffer.set(x - halfWidth, at: i * 4 + 0)
            rectsBuffer.set(y - halfWidth, at: i * 4 + 1)
            rectsBuffer.set(x + halfWidth, at: i * 4 + 2)
            rectsBuffer.set(zeroLine + halfWidth, at: i * 4 + 3)
            
            bottomEllipsesBuffer.set(x - halfWidth, at: i * 4 + 0)
            bottomEllipsesBuffer.set(zeroLine + columnPixelWidth, at: i * 4 + 1)
            bottomEllipsesBuffer.set(x + halfWidth, at: i * 4 + 2)
            bottomEllipsesBuffer.set(zeroLine, at: i * 4 + 3)
        }
    }
}
