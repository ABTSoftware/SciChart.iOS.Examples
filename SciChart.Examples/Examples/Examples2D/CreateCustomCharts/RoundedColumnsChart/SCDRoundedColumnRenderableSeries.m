//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDRoundedColumnRenderableSeries.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDRoundedColumnRenderableSeries.h"
#import <SciChart/SCIBaseColumnRenderableSeries+Protected.h>

@implementation SCDRoundedColumnRenderableSeries {
    SCIFloatValues *_rectsBuffer;
    SCIFloatValues *_topEllipseBuffer;
    SCIFloatValues *_bottomEllipseBuffer;
}

- (instancetype)init {
    id<ISCIHitProvider> hitProvider = [SCIColumnHitProvider new];
    self = [super initWithRenderPassData:[SCIColumnRenderPassData new] hitProvider:hitProvider nearestPointProvider:[SCINearestColumnPointProvider new]];
    if (self) {
        _rectsBuffer = [SCIFloatValues new];
        _topEllipseBuffer = [SCIFloatValues new];
        _bottomEllipseBuffer = [SCIFloatValues new];
    }
    return self;
}

- (void)disposeCachedData {
    [super disposeCachedData];
    
    [_rectsBuffer dispose];
    [_topEllipseBuffer dispose];
    [_bottomEllipseBuffer dispose];
}

- (void)internalDrawWithContext:(id<ISCIRenderContext2D>)renderContext assetManager:(id<ISCIAssetManager2D>)assetManager renderPassData:(id<ISCISeriesRenderPassData>)renderPassData {
    // Don't draw transparent series
    if (self.opacity == 0) return;
    
    SCIBrushStyle *fillStyle = self.fillBrushStyle;
    if (fillStyle == nil || !fillStyle.isVisible) return;
    
    SCIColumnRenderPassData *rpd = (SCIColumnRenderPassData *)renderPassData;
    [self p_SCD_updateDrawingBuffersWithData:rpd columnPixelWidth:rpd.columnPixelWidth andZeroLine:rpd.zeroLineCoord];
    
    id<ISCIBrush2D> brush = [assetManager brushWithStyle:fillStyle];
    id<ISCIPen2D> pen = [assetManager penWithStyle:SCIPenStyle.DEFAULT];
    
    [renderContext drawEllipsesWithPen:pen brush:brush points:_topEllipseBuffer.itemsArray startIndex:0 count:(int)_topEllipseBuffer.count];
    [renderContext drawEllipsesWithPen:pen brush:brush points:_bottomEllipseBuffer.itemsArray startIndex:0 count:(int)_bottomEllipseBuffer.count];
    [renderContext fillRectsWithBrush:brush points:_rectsBuffer.itemsArray startIndex:0 count:(int)_rectsBuffer.count];
}

- (void)p_SCD_updateDrawingBuffersWithData:(SCIColumnRenderPassData *)renderPassData columnPixelWidth:(float)columnPixelWidth andZeroLine:(float)zeroLine {
    float halfWidth = columnPixelWidth / 2;

    _rectsBuffer.count = renderPassData.pointsCount * 4;
    _topEllipseBuffer.count = renderPassData.pointsCount * 4;
    _bottomEllipseBuffer.count = renderPassData.pointsCount * 4;
    
    float *rectsArray = _rectsBuffer.itemsArray;
    float *topArray = _topEllipseBuffer.itemsArray;
    float *bottomArray = _bottomEllipseBuffer.itemsArray;
    
    float *xCoordsArray = renderPassData.xCoords.itemsArray;
    float *yCoordsArray = renderPassData.yCoords.itemsArray;
    for (NSInteger i = 0, count = renderPassData.pointsCount; i < count; i++) {
        float x = xCoordsArray[i];
        float y = yCoordsArray[i];
        
        topArray[i * 4 + 0] = x - halfWidth - 1;
        topArray[i * 4 + 1] = y - columnPixelWidth;
        topArray[i * 4 + 2] = x + halfWidth + 1;
        topArray[i * 4 + 3] = y;

        rectsArray[i * 4 + 0] = x - halfWidth;
        rectsArray[i * 4 + 1] = y - halfWidth;
        rectsArray[i * 4 + 2] = x + halfWidth;
        rectsArray[i * 4 + 3] = zeroLine + halfWidth;
        
        bottomArray[i * 4 + 0] = x - halfWidth - 1;
        bottomArray[i * 4 + 1] = zeroLine + columnPixelWidth;
        bottomArray[i * 4 + 2] = x + halfWidth + 1;
        bottomArray[i * 4 + 3] = zeroLine;
    }
}

@end
