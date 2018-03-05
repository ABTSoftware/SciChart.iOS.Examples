//
//  CollumnDrillDownView.m
//  SciChartDemo
//
//  Created by Admin on 9/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ColumnDrillDownView.h"
#import <SciChart/SciChart.h>

#pragma mark Custom modifier

@interface ColumnHitTest : SCIGestureModifier

@property (nonatomic, copy) SCIActionBlock_Pint tapedAtIndex;
@property (nonatomic, copy) SCIActionBlock doubleTaped;

@end

@implementation ColumnHitTest {
    CGPoint _location; // position of tap gesture
    int _index; // index of data column
}

- (BOOL)onTapGesture:(UITapGestureRecognizer*)gesture At:(UIView*)view {
    CGPoint location = [gesture locationInView:view];
    id<SCIRenderSurfaceProtocol> rs = [self.parentSurface renderSurface];
    if (![rs isPointWithinBounds:location]) return NO;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        // save location of touch
        _location = location;
        id<SCIChartSurfaceProtocol> parent = self.parentSurface;
        SCIRenderableSeriesCollection * series = [parent renderableSeries];
        id<SCIRenderSurfaceProtocol> surface = [parent renderSurface];
        CGPoint actualLocation = [surface pointInChartFrame:_location];
        
        int count = (int)[series count];
        // check every renderable series for hit
        for (int i = 0; i < count; i++) {
            id<SCIRenderableSeriesProtocol> rSeries = [series itemAt:i];
            id<SCIRenderPassDataProtocol> data = [rSeries currentRenderPassData];
            id<SCIHitTestProviderProtocol> hitTest = [rSeries hitTestProvider]; // get hit test tools
            if (hitTest == nil) continue;
            // hit test verticaly: check if vertical projection through touch location crosses chart
            SCIHitTestInfo hitTestResult = [hitTest hitTestVerticalAtX:actualLocation.x Y:actualLocation.y Radius:5 onData:data];
            if (hitTestResult.match) { // if hit is registered on series
                // get values at closest point to hit test position
                _index = hitTestResult.index;
                if (_tapedAtIndex != nil) _tapedAtIndex(_index);
                break;
            }
        }
    }
    return YES;
}

- (BOOL)onDoubleTapGesture:(UITapGestureRecognizer *)gesture At:(UIView *)view {
    CGPoint location = [gesture locationInView:view];
    id<SCIRenderSurfaceProtocol> rs = [self.parentSurface renderSurface];
    if (![rs isPointWithinBounds:location]) return NO;
    if (_doubleTaped != nil) _doubleTaped();
    return YES;
}

@end

#pragma mark Palette provider

@interface ColumnDrillDownPalette : SCIPaletteProvider
@end

@implementation ColumnDrillDownPalette {
    NSMutableArray * _styles;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _styles = [NSMutableArray new];
    }
    return self;
}

- (void)addStyle:(id<SCIStyleProtocol>)style {
    [_styles addObject:style];
}

- (id<SCIStyleProtocol>)styleForX:(double)x Y:(double)y Index:(int)index {
    if (index > [_styles count]) return nil;
    return _styles[index];
}

@end

#pragma mark Chart surface

@implementation ColumnDrillDownView {
    SCIXyDataSeries * _totalData;
    
    SCIFastColumnRenderableSeries * _firstColumn;
    SCIFastColumnRenderableSeries * _secondColumn;
    SCIFastColumnRenderableSeries * _thirdColumn;
    SCIFastColumnRenderableSeries * _totalColumn;
    
    BOOL _isShowingTotal;
}

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _isShowingTotal = NO;
        
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:surface];
        
        NSDictionary * layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCICategoryNumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];

    _totalData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int32];

    _firstColumn = [SCIFastColumnRenderableSeries new];
    _firstColumn.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFF00FFFF finish:0xA000FFFF direction:SCILinearGradientDirection_Vertical];
    _firstColumn.strokeStyle = nil;
    _firstColumn.dataSeries = [self getDataSeries];
    
    _secondColumn = [SCIFastColumnRenderableSeries new];
    _secondColumn.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFF00FF00 finish:0xA000FF00 direction:SCILinearGradientDirection_Vertical];
    _secondColumn.strokeStyle = nil;
    _secondColumn.dataSeries = [self getDataSeries];
    
    _thirdColumn = [SCIFastColumnRenderableSeries new];
    _thirdColumn.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFFF0000 finish:0xA0FF0000 direction:SCILinearGradientDirection_Vertical];
    _thirdColumn.strokeStyle = nil;
    _thirdColumn.dataSeries = [self getDataSeries];
    
     ColumnDrillDownPalette * palette = [ColumnDrillDownPalette new];
     [palette addStyle:[_firstColumn.style copy]];
     [palette addStyle:[_secondColumn.style copy]];
     [palette addStyle:[_thirdColumn.style copy]];
     
    _totalColumn = [SCIFastColumnRenderableSeries new];
    _totalColumn.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFF505050 finish:0xA550005 direction:SCILinearGradientDirection_Vertical];
    _totalColumn.strokeStyle = nil;
    _totalColumn.dataSeries = _totalData;
    _totalColumn.paletteProvider = palette;
    
    ColumnHitTest * drillDownModifier = [ColumnHitTest new];
    __weak typeof(self) wSelf = self;
    drillDownModifier.doubleTaped = ^() { [wSelf showSeries:_totalColumn isTotal:YES]; };
    drillDownModifier.tapedAtIndex = ^(int index) { [wSelf showDetailedChartAt:index]; };
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], drillDownModifier]];
        
        SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
        [animation setRepeatable:YES];
        [_firstColumn addAnimation:animation];
        animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
        [animation setRepeatable:YES];
        [_secondColumn addAnimation:animation];
        animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
        [animation setRepeatable:YES];
        [_thirdColumn addAnimation:animation];
        animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
        [animation setRepeatable:YES];
        [_totalColumn addAnimation:animation];
        
        [self showSeries:_totalColumn isTotal:YES];
    }];
}

- (SCIXyDataSeries *)getDataSeries {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int32];
    
    int total = 0;
    int count = arc4random_uniform(5)+3;
    for (int i = 0; i < count; i++) {
        int value = arc4random_uniform(5+i)+1;
        total += value;
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric(value)];
    }
    [_totalData appendX:SCIGeneric(3) Y:SCIGeneric(total)];
    
    return dataSeries;
}

- (void)showDetailedChartAt:(int)index {
    if (!_isShowingTotal) return;
    if (index == 0) {
        [self showSeries:_firstColumn isTotal:NO];
    } else if (index == 1) {
        [self showSeries:_secondColumn isTotal:NO];
    } else if (index == 2) {
        [self showSeries:_thirdColumn isTotal:NO];
    }
}

- (void)showSeries:(id<SCIRenderableSeriesProtocol>)series isTotal:(BOOL)isTotal {
    _isShowingTotal = isTotal;
    [surface.renderableSeries clear];
    [surface.renderableSeries add:series];
    
    [surface.viewportManager zoomExtents];
}

@end
