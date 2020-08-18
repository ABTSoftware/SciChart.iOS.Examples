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
#import <SciChart/SCIFastColumnRenderableSeries+Protected.h>

@implementation SCDRoundedColumnRenderableSeries {
    SCIFloatValues *_topEllipsesBuffer;
    SCIFloatValues *_rectsBuffer;
    SCIFloatValues *_bottomEllipsesBuffer;
}

- (instancetype)init {
    id<ISCIHitProvider> hitProvider = [SCIColumnHitProvider new];
    self = [super initWithRenderPassData:[SCIColumnRenderPassData new] hitProvider:hitProvider nearestPointProvider:[SCINearestColumnPointProvider new]];
    if (self) {
        _topEllipsesBuffer = [SCIFloatValues new];
        _rectsBuffer = [SCIFloatValues new];
        _bottomEllipsesBuffer = [SCIFloatValues new];
    }
    return self;
}

- (void)disposeCachedData {
    [super disposeCachedData];
    
    [_topEllipsesBuffer dispose];
    [_rectsBuffer dispose];
    [_bottomEllipsesBuffer dispose];
}

- (void)internalDrawWithContext:(id<ISCIRenderContext2D>)renderContext assetManager:(id<ISCIAssetManager2D>)assetManager renderPassData:(id<ISCISeriesRenderPassData>)renderPassData {
    // Don't draw transparent series
    if (self.opacity == 0) return;
    
    SCIBrushStyle *fillStyle = self.fillBrushStyle;
    if (fillStyle == nil || !fillStyle.isVisible) return;

    SCIColumnRenderPassData *rpd = (SCIColumnRenderPassData *)renderPassData;
    [self p_SCD_updateDrawingBuffersWithData:rpd columnPixelWidth:rpd.columnPixelWidth andZeroLine:rpd.zeroLineCoord];
    
    id<ISCIBrush2D> brush = [assetManager brushWithStyle:fillStyle];
    [renderContext fillRectsWithBrush:brush points:_rectsBuffer.itemsArray startIndex:0 count:(int)_rectsBuffer.count];
    [renderContext fillEllipsesWithBrush:brush points:_topEllipsesBuffer.itemsArray startIndex:0 count:(int)_topEllipsesBuffer.count];
    [renderContext fillEllipsesWithBrush:brush points:_bottomEllipsesBuffer.itemsArray startIndex:0 count:(int)_topEllipsesBuffer.count];
}

- (void)p_SCD_updateDrawingBuffersWithData:(SCIColumnRenderPassData *)renderPassData columnPixelWidth:(float)columnPixelWidth andZeroLine:(float)zeroLine {
    float halfWidth = columnPixelWidth / 2;

    _topEllipsesBuffer.count = renderPassData.pointsCount * 4;
    _rectsBuffer.count = renderPassData.pointsCount * 4;
    _bottomEllipsesBuffer.count = renderPassData.pointsCount * 4;
    
    float *topArray = _topEllipsesBuffer.itemsArray;
    float *rectsArray = _rectsBuffer.itemsArray;
    float *bottomArray = _bottomEllipsesBuffer.itemsArray;
    
    float *xCoordsArray = renderPassData.xCoords.itemsArray;
    float *yCoordsArray = renderPassData.yCoords.itemsArray;
    for (NSInteger i = 0, count = renderPassData.pointsCount; i < count; i++) {
        float x = xCoordsArray[i];
        float y = yCoordsArray[i];
        
        topArray[i * 4 + 0] = x - halfWidth;
        topArray[i * 4 + 1] = y;
        topArray[i * 4 + 2] = x + halfWidth;
        topArray[i * 4 + 3] = y - columnPixelWidth;
        
        rectsArray[i * 4 + 0] = x - halfWidth;
        rectsArray[i * 4 + 1] = y - halfWidth;
        rectsArray[i * 4 + 2] = x + halfWidth;
        rectsArray[i * 4 + 3] = zeroLine + halfWidth;
        
        bottomArray[i * 4 + 0] = x - halfWidth;
        bottomArray[i * 4 + 1] = zeroLine + columnPixelWidth;
        bottomArray[i * 4 + 2] = x + halfWidth;
        bottomArray[i * 4 + 3] = zeroLine;
    }
}

@end
