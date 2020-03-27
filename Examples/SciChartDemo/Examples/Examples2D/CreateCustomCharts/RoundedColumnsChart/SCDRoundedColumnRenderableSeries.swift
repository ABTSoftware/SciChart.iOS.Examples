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
    var topEllipsesBuffer = [Float]()
    var rectsBuffer = [Float]()
    var bottomEllipsesBuffer = [Float]()
    
    override init() {
        let hitProvider = SCIColumnHitProvider()
        super.init(renderPassData: SCIColumnRenderPassData(), hitProvider: hitProvider, nearestPointProvider: SCINearestColumnPointProvider())
    }
    
    override func internalDraw(with renderContext: ISCIRenderContext2D!, assetManager: ISCIAssetManager2D!, renderPassData: ISCISeriesRenderPassData!) {
        // Don't draw transparent series
        guard self.opacity != 0 else { return }
        guard let fillStyle = self.fillBrushStyle else { return }
        guard fillStyle.isVisible else { return }
        
        let rpd = renderPassData as! SCIColumnRenderPassData
        updateDrawingBuffersWithData(renderPassData: rpd, columnPixelWidth: rpd.columnPixelWidth, zeroLine: rpd.zeroLineCoord)
        
        let brush = assetManager.brush(with: fillStyle)
        renderContext.fillRects(with: brush, points: UnsafeMutablePointer<Float>(mutating: rectsBuffer), start: 0, count: Int32(rectsBuffer.count))
        renderContext.fillEllipses(with: brush, points: UnsafeMutablePointer<Float>(mutating: topEllipsesBuffer), start: 0, count: Int32(topEllipsesBuffer.count))
        renderContext.fillEllipses(with: brush, points: UnsafeMutablePointer<Float>(mutating: bottomEllipsesBuffer), start: 0, count: Int32(bottomEllipsesBuffer.count))
    }
    
    fileprivate func updateDrawingBuffersWithData(renderPassData: SCIColumnRenderPassData, columnPixelWidth: Float, zeroLine: Float) {
        let halfWidth = columnPixelWidth / 2;
        
        topEllipsesBuffer = Array(repeating: 0, count: renderPassData.pointsCount * 4)
        rectsBuffer = Array(repeating: 0, count: renderPassData.pointsCount * 4)
        bottomEllipsesBuffer = Array(repeating: 0, count: renderPassData.pointsCount * 4)
        
        for i in 0 ..< renderPassData.pointsCount {
            let x = renderPassData.xCoords.getValueAt(i)
            let y = renderPassData.yCoords.getValueAt(i)
            
            topEllipsesBuffer[i * 4 + 0] = x - halfWidth;
            topEllipsesBuffer[i * 4 + 1] = y;
            topEllipsesBuffer[i * 4 + 2] = x + halfWidth;
            topEllipsesBuffer[i * 4 + 3] = y - columnPixelWidth;

            rectsBuffer[i * 4 + 0] = x - halfWidth;
            rectsBuffer[i * 4 + 1] = y - halfWidth;
            rectsBuffer[i * 4 + 2] = x + halfWidth;
            rectsBuffer[i * 4 + 3] = zeroLine + halfWidth;
            
            bottomEllipsesBuffer[i * 4 + 0] = x - halfWidth;
            bottomEllipsesBuffer[i * 4 + 1] = zeroLine + columnPixelWidth;
            bottomEllipsesBuffer[i * 4 + 2] = x + halfWidth;
            bottomEllipsesBuffer[i * 4 + 3] = zeroLine;
        }
    }
}
