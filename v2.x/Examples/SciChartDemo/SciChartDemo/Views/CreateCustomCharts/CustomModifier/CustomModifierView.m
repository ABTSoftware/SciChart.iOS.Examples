//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomModifierView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomModifierView.h"
#import <SciChart/SciChart.h>

@interface CustomModifier : SCIGestureModifier
@end

@implementation CustomModifier {
    SCIEllipsePointMarker * _marker; // marker to be displayed
    CGPoint _location; // position of tap gesture
    BOOL _visible; // if marker should be visible
    double _xValue; // x data value at point marker
    double _yValue; // y data value at point marker
    int _index; // index of data point at point marker position
    id<SCIRenderableSeriesProtocol> _rSeries; // renderable series to whicj point marker is bound
    __weak CustomModifierLayout * _customModifierLayout; // control panel for additional actions with modifier
}

- (instancetype)initWithControlPanel:(CustomModifierLayout *)customModifierLayout {
    self = [super init];
    if (self) {
        _customModifierLayout = customModifierLayout;
        
        __weak CustomModifier * wSelf = self;
        customModifierLayout.onNextClicked = ^(){ [wSelf moveMarker:+1]; };
        customModifierLayout.onPrevClicked = ^(){ [wSelf moveMarker:-1]; };
        customModifierLayout.onClearClicked = ^(){ [wSelf hideMarker]; };
        
        // create marker
        _marker = [SCIEllipsePointMarker new];
        _marker.fillStyle = [[SCISolidBrushStyle alloc] initWithColor:UIColor.redColor];
        _marker.strokeStyle = nil;
    }
    return self;
}

- (void)hideMarker {
    _visible = NO;
    // modifier context should be invalidated to trigger modifier redraw
    id<SCIChartSurfaceProtocol> parent = self.parentSurface;
    [parent.renderSurface.modifierContext invalidate];
}

- (void)moveMarker:(int)mod {
    if (!_visible) return;
    id<SCIChartSurfaceProtocol> parent = self.parentSurface;
    id<SCIRenderContext2DProtocol> context = parent.renderSurface.modifierContext;
    _index += mod;
    id<SCIRenderPassDataProtocol> data = [_rSeries currentRenderPassData];
    id<SCIDataSeriesProtocol> dataSeries = [data dataSeries];
    // check if index is out of data series range
    BOOL indexOutOfRange = _index < 0 || _index >= [dataSeries count];
    if (indexOutOfRange) {
        _visible = NO;
        [context invalidate];
        return;
    }
    // get data values from data series for new index
    _xValue = SCIGenericDouble([dataSeries.xValues valueAt:_index]);
    _yValue = SCIGenericDouble([dataSeries.yValues valueAt:_index]);
    if (isnan(_xValue) || isnan(_yValue)) {
        _visible = NO;
        [context invalidate];
        return;
    }
    // trigger redraw
    [context invalidate];
}

- (void)preapareDataForDrawing {
    _visible = NO;
    id<SCIChartSurfaceProtocol> parent = self.parentSurface;
    SCIRenderableSeriesCollection * series = parent.renderableSeries;
    id<SCIRenderSurfaceProtocol> surface = parent.renderSurface;
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
            _xValue = SCIGenericDouble(hitTestResult.xValue);
            _yValue = SCIGenericDouble(hitTestResult.yValue);
            _index = hitTestResult.index;
            if (isnan(_xValue) || isnan(_yValue)) continue;
            _visible = YES;
            _rSeries = rSeries;
            break;
        }
    }
}

- (BOOL)onTapGesture:(UITapGestureRecognizer*)gesture At:(UIView*)view {
    CGPoint location = [gesture locationInView:view];
    id<SCIRenderSurfaceProtocol> rs = self.parentSurface.renderSurface;
    if (![rs isPointWithinBounds:location]) return NO;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        // save location of touch
        _location = location;
        [self preapareDataForDrawing];
        // invalidate modifier context to trigger redrawing of modifier
        id<SCIChartSurfaceProtocol> parent = self.parentSurface;
        
        [parent.renderSurface.modifierContext invalidate];
    }
    return YES;
}

- (void)draw {
    if (!_visible) return;
    id<SCIChartSurfaceProtocol> parent = self.parentSurface;
    id<SCIRenderSurfaceProtocol> surface = [parent renderSurface];
    id<SCIRenderContext2DProtocol> context = [surface modifierContext];
    
    // get coordinate calculators and calculate coordinates on screen for data point
    id<SCIRenderPassDataProtocol> data = [_rSeries currentRenderPassData];
    id<SCICoordinateCalculatorProtocol> xCalc = [data xCoordinateCalculator];
    id<SCICoordinateCalculatorProtocol> yCalc = [data yCoordinateCalculator];
    double xCoord = [xCalc getCoordinateFrom:_xValue];
    double yCoord = [yCalc getCoordinateFrom:_yValue];
    
    [context save];
    // context needs proper area (in that case it is chart area)
    [context setDrawingArea:surface.chartFrame];
    
    // draw point marker
    [_marker drawToContext:context AtX:xCoord Y:yCoord];
    
    [context restore];
    
    // update control panel text
    _customModifierLayout.infoLabel.text = [NSString stringWithFormat:@"Index: %d X:%g Y:%g", _index, _xValue, _yValue];
}

@end

@implementation CustomModifierView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    int dataCount = 15;
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double x = time;
        double y = arc4random_uniform(20);
        [dataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }

    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    
    CustomModifier * customModifier = [[CustomModifier alloc] initWithControlPanel:self];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], customModifier]];
        
        [SCIThemeManager applyDefaultThemeToThemeable:self.surface];
    }];
}

@end
