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
    let cornerRadius: CGFloat = 20
    var rectsBuffer = SCIFloatValues()
    
    override init() {
        let hitProvider = SCIColumnHitProvider()
        super.init(renderPassData: SCIColumnRenderPassData(), hitProvider: hitProvider, nearestPointProvider: SCINearestColumnPointProvider())
    }
    
    override func disposeCachedData() {
        super.disposeCachedData()
        
        rectsBuffer.dispose()
    }
    
    override func internalDraw(with renderContext: ISCIRenderContext2D!, assetManager: ISCIAssetManager2D!, renderPassData: ISCISeriesRenderPassData!) {
        // Don't draw transparent series
        guard self.opacity != 0 else { return }
        guard let fillStyle = self.fillBrushStyle else { return }
        guard fillStyle.isVisible else { return }
        
        let rpd = renderPassData as! SCIColumnRenderPassData
        updateDrawingBuffersWithData(renderPassData: rpd, columnPixelWidth: rpd.columnPixelWidth, zeroLine: rpd.zeroLineCoord)
        
        let brush = assetManager.brush(with: fillStyle)
        rectsBuffer.withUnsafePointer { bufferPointer in
            renderContext.drawRoundedRects(bufferPointer, start: 0, count: Int32(rectsBuffer.count), with: nil, andBrush: brush, topRadius: cornerRadius, bottomRadius: cornerRadius)
        }
    }

    fileprivate func updateDrawingBuffersWithData(renderPassData: SCIColumnRenderPassData, columnPixelWidth: Float, zeroLine: Float) {
        let halfWidth = columnPixelWidth / 2;

        rectsBuffer.count = renderPassData.pointsCount * 4

        for i in 0 ..< renderPassData.pointsCount {
            let x = renderPassData.xCoords.getValueAt(i)
            let y = renderPassData.yCoords.getValueAt(i)

            rectsBuffer.set(x - halfWidth, at: i * 4 + 0)
            rectsBuffer.set(y, at: i * 4 + 1)
            rectsBuffer.set(x + halfWidth, at: i * 4 + 2)
            rectsBuffer.set(zeroLine, at: i * 4 + 3)
        }
    }
}
