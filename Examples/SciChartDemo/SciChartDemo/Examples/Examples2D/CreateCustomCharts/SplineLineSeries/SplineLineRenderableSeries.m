//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineLineRenderableSeries.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SplineLineRenderableSeries.h"
#import <SciChart/SCIXyRenderableSeriesBase+Protected.h>
#import "TriDiagonalMatrixF.h"
#import "CubicSpline.h"

@interface SplineLineRenderableSeries ()

@property (strong, nonatomic) SCISmartPropertyBool *isSplineEnabledProperty;
@property (strong, nonatomic) SCISmartPropertyInt *upSampleFactorProperty;

@end

@implementation SplineLineRenderableSeries {
    SCIFloatValues *_splineXCoords;
    SCIFloatValues *_splineYCoords;
}

- (instancetype)init {
    id<ISCIHitProvider> hitProvider = [[SCICompositeHitProvider alloc] initWithProvider1:[SCIPointMarkerHitProvider new] provider2:[SCILineHitProvider new]];
    self = [super initWithRenderPassData:[SCILineRenderPassData new] hitProvider:hitProvider nearestPointProvider:[SCINearestXyPointProvider new]];
    if (self) {
        _splineXCoords = [SCIFloatValues new];
        _splineYCoords = [SCIFloatValues new];
        
        _isSplineEnabledProperty = [[SCISmartPropertyBool alloc] initWithListener:self.boolInvalidateElementListener defaultValue:YES];
        _upSampleFactorProperty = [[SCISmartPropertyInt alloc] initWithListener:self.intInvalidateElementListener defaultValue:10];
    }
    return self;
}

- (BOOL)isSplineEnabled {
    return _isSplineEnabledProperty.value;
}

- (void)setIsSplineEnabled:(BOOL)isSplineEnabled {
    [_isSplineEnabledProperty setStrongValue:isSplineEnabled];
}

- (int)upSampleFactor {
    return _upSampleFactorProperty.value;
}

- (void)setUpSampleFactor:(int)upSampleFactor {
    [_upSampleFactorProperty setStrongValue:upSampleFactor];
}

- (void)disposeCachedData {
    [super disposeCachedData];
    
    [_splineXCoords dispose];
    [_splineYCoords dispose];
}

- (void)internalDrawWithContext:(id<ISCIRenderContext2D>)renderContext assetManager:(id<ISCIAssetManager2D>)assetManager renderPassData:(id<ISCISeriesRenderPassData>)renderPassData {
    // Don't draw transparent series
    float opacity = self.opacity;
    if (opacity == 0) return;
    
    SCIPenStyle *strokeStyle = self.strokeStyle;
    if (strokeStyle == nil || !strokeStyle.isVisible) return;
    
    SCILineRenderPassData *rpd = (SCILineRenderPassData *)renderPassData;
    id<ISCIDrawingContext> linesStripDrawingContext = SCIDrawingContextFactory.linesStripDrawingContext;
    
    id<ISCIPen2D> pen = [assetManager penWithStyle:strokeStyle andOpacity:opacity];
    [self computeSplineSeriesWithX:_splineXCoords y:_splineYCoords renderPassData:rpd isSplineEnabled:self.isSplineEnabled upSampleFactor:self.upSampleFactor];
    
    BOOL digitalLine = rpd.isDigitalLine;
    BOOL closeGaps = rpd.closeGaps;

    id<ISCISeriesDrawingManager> drawingManager = [self.services getServiceOfType:@protocol(ISCISeriesDrawingManager)];
    [drawingManager beginDrawWithContext:renderContext renderPassData:rpd];

    [drawingManager iterateLinesWith:linesStripDrawingContext pathColor:pen xCoords:_splineXCoords yCoords:_splineYCoords isDigitalLine:digitalLine closeGaps:closeGaps];

    [drawingManager endDraw];
    
    [self drawPointMarkersWithContext:renderContext assetManager:assetManager xCoords:rpd.xCoords yCoords:rpd.yCoords];
}

- (void)computeSplineSeriesWithX:(SCIFloatValues *)splineXCoords y:(SCIFloatValues *)splineYCoords renderPassData:(SCILineRenderPassData *)renderPassData isSplineEnabled:(BOOL)isSplineEnabled upSampleFactor:(int)upSampleFactor {
    if (!isSplineEnabled) return;
    
    // Spline enabled
    NSInteger count = self.currentRenderPassData.pointsCount;
    NSInteger splineCount = count * upSampleFactor;
    
    splineXCoords.count = splineCount;
    splineYCoords.count = splineCount;
    
    SCIFloatValues *xs = [[SCIFloatValues alloc] initWithCapacity:splineCount];
    float *xData = renderPassData.xCoords.itemsArray;
    float stepSize = (xData[count - 1] - xData[0]) / (splineCount - 1);
    
    // set spline xCoords
    for (int i = 0; i < splineCount; i++) {
        float value = xData[0] + i * stepSize;
        [xs add:value];
    }
    
    CubicSpline *cubicSpline = [CubicSpline new];
    SCIFloatValues *ys = [cubicSpline fitAndEvalX:renderPassData.xCoords y:renderPassData.yCoords xS:xs startSlope:NAN endSlope:NAN];
    
    [splineXCoords clear];
    [splineYCoords clear];
    [splineXCoords addValues:xs.itemsArray count:xs.count];
    [splineYCoords addValues:ys.itemsArray count:ys.count];
}

@end
