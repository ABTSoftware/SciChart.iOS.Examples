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

const CGFloat cornerRadius = 20;

@implementation SCDRoundedColumnRenderableSeries {
    SCIFloatValues *_rectsBuffer;
}

- (instancetype)init {
    id<ISCIHitProvider> hitProvider = [SCIColumnHitProvider new];
    self = [super initWithRenderPassData:[SCIColumnRenderPassData new] hitProvider:hitProvider nearestPointProvider:[SCINearestColumnPointProvider new]];
    if (self) {
        _rectsBuffer = [SCIFloatValues new];
    }
    return self;
}

- (void)disposeCachedData {
    [super disposeCachedData];
    
    [_rectsBuffer dispose];
}

- (void)internalDrawWithContext:(id<ISCIRenderContext2D>)renderContext assetManager:(id<ISCIAssetManager2D>)assetManager renderPassData:(id<ISCISeriesRenderPassData>)renderPassData {
    // Don't draw transparent series
    if (self.opacity == 0) return;
    
    SCIBrushStyle *fillStyle = self.fillBrushStyle;
    if (fillStyle == nil || !fillStyle.isVisible) return;

    SCIColumnRenderPassData *rpd = (SCIColumnRenderPassData *)renderPassData;
    [self p_SCD_updateDrawingBuffersWithData:rpd columnPixelWidth:rpd.columnPixelWidth andZeroLine:rpd.zeroLineCoord];
    
    id<ISCIBrush2D> brush = [assetManager brushWithStyle:fillStyle];
    [renderContext drawRoundedRects:_rectsBuffer.itemsArray startIndex:0 count:(int)_rectsBuffer.count withPen:nil andBrush:brush topRadius:cornerRadius bottomRadius:cornerRadius];
}

- (void)p_SCD_updateDrawingBuffersWithData:(SCIColumnRenderPassData *)renderPassData columnPixelWidth:(float)columnPixelWidth andZeroLine:(float)zeroLine {
    float halfWidth = columnPixelWidth / 2;

    _rectsBuffer.count = renderPassData.pointsCount * 4;
    
    float *rectsArray = _rectsBuffer.itemsArray;
    
    float *xCoordsArray = renderPassData.xCoords.itemsArray;
    float *yCoordsArray = renderPassData.yCoords.itemsArray;
    for (NSInteger i = 0, count = renderPassData.pointsCount; i < count; i++) {
        float x = xCoordsArray[i];
        float y = yCoordsArray[i];

        rectsArray[i * 4 + 0] = x - halfWidth;
        rectsArray[i * 4 + 1] = y;
        rectsArray[i * 4 + 2] = x + halfWidth;
        rectsArray[i * 4 + 3] = zeroLine;
    }
}

@end
