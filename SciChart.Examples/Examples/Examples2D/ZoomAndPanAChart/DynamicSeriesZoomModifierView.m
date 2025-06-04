//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2021. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DynamicSeriesZoomModifierView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "DynamicSeriesZoomModifierView.h"

static double const TimeInterval = 0.05;

@implementation DynamicSeriesZoomModifierView {
    NSTimer *_timer;
    SCIXyDataSeries *_ds1;
    SCIXyDataSeries *_ds2;
    SCIXyDataSeries *_ds3;
    
    double _t;
    
    id<ISCIAxis> xAxis;
    id<ISCIAxis> yAxis;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    xAxis.axisTitle = @"Time (Seconds)";
    xAxis.textFormatting = @"0.0";
    
    yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.axisTitle = @"Amplitude (Volts)";
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.textFormatting = @"0.00";
    yAxis.cursorTextFormatting = @"0.00";
    
    _ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _ds1.seriesName = @"Orange Series";
    _ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _ds2.seriesName = @"Blue Series";
    _ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _ds3.seriesName = @"Green Series";

    SCIFastLineRenderableSeries *rSeries1 = [SCIFastLineRenderableSeries new];
    rSeries1.dataSeries = _ds1;
    rSeries1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFe97064 thickness:2];
    
    SCIFastLineRenderableSeries *rSeries2 = [SCIFastLineRenderableSeries new];
    rSeries2.dataSeries = _ds2;
    rSeries2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF47bde6 thickness:2];
    
    SCIFastLineRenderableSeries *rSeries3 = [SCIFastLineRenderableSeries new];
    rSeries3.dataSeries = _ds3;
    rSeries3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:2];
    
    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.margins = (SCIEdgeInsets){.left = 10, .top = 60, .right = 16, .bottom = 16};
    
    /// To hide value modifier when zooming
    SCIDefaultSeriesValueMarkerFactory *factory = [[SCIDefaultSeriesValueMarkerFactory alloc] initWithPredicate:^BOOL(id series) {
        return self.surface.zoomState == SCIZoomState_AtExtents;
    }];

    /// Create seriesValueModifier with this factory
    SCISeriesValueModifier *seriesValueModifier = [[SCISeriesValueModifier alloc] initWithMarkerFactory:factory];
    
    SCIZoomPanModifier *zoomPanModifier = [SCIZoomPanModifier new];
    zoomPanModifier.direction = SCIDirection2D_XDirection;
    [zoomPanModifier setPanZoomDelegate:self];
    
    SCIPinchZoomModifier *zoomPinchModifier = [SCIPinchZoomModifier new];
    [zoomPinchModifier setPinchZoomDelegate:self];
    
    SCIZoomExtentsModifier *zoomExtentsModifier = [SCIZoomExtentsModifier new];
    [zoomExtentsModifier setZoomExtentsDelegate:self];
    
    SCITextAnnotation *annotation = [SCITextAnnotation new];
    annotation.text = @"Pinch to Zoom In/Out.\nPan horizontally to adjust the x-axis range.\nDouble tap to Zoom Extents.";
    annotation.fontStyle = [[SCIFontStyle alloc] initWithFontSize:14 andTextColor:SCIColor.whiteColor];
    annotation.x1 = @(0.4);
    annotation.y1 = @(0);
    annotation.coordinateMode = SCIAnnotationCoordinateMode_Relative;
    annotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
    annotation.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:self->xAxis];
        [self.surface.yAxes add:self->yAxis];
        [self.surface.renderableSeries add:rSeries1];
        [self.surface.renderableSeries add:rSeries2];
        [self.surface.renderableSeries add:rSeries3];
        [self.surface.annotations add:annotation];
        [self.surface.chartModifiers addAll: seriesValueModifier, zoomPanModifier, zoomPinchModifier, zoomExtentsModifier, legendModifier, nil];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
#if TARGET_OS_OSX
    if (_timer) {
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
#endif
}

- (void)updateData:(NSTimer *)timer {
    double y1 = 3.0 * sin(((2 * M_PI) * 1.4) * _t * 0.02);
    double y2 = 2.0 * cos(((2 * M_PI) * 0.8) * _t * 0.02);
    double y3 = 1.0 * sin(((2 * M_PI) * 2.2) * _t * 0.02);
    
    [_ds1 appendX:@(_t) y:@(y1)];
    [_ds2 appendX:@(_t) y:@(y2)];
    [_ds3 appendX:@(_t) y:@(y3)];
    
    _t += TimeInterval;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

//MARK: - Delegate methos for Gestures
- (void)onZoomPanGestureBeganWithArgs:(SCIGestureModifierEventArgs * _Nonnull)args {
    NSLog(@"onPinchZoomGestureBegan");
    
    /// Stop automatically changing the X and Y ranges as soon as the user starts pinching the chart.
    yAxis.autoRange = SCIAutoRange_Never;
    xAxis.autoRange = SCIAutoRange_Never;
}

- (void)onPinchZoomGestureBeganWithArgs:(SCIGestureModifierEventArgs * _Nonnull)args { 
    NSLog(@"onZoomPanGestureBegan");
    
    /// Stop automatically changing the X and Y ranges as soon as the user starts panning the chart.
    yAxis.autoRange = SCIAutoRange_Never;
    xAxis.autoRange = SCIAutoRange_Never;
}

- (void)performZoomExtentsCompleted { 
    NSLog(@"performZoomExtentsCompleted");
    
    /// Start automatically changing the X and Y ranges as soon as the user reset the chart.
    yAxis.autoRange = SCIAutoRange_Always;
    xAxis.autoRange = SCIAutoRange_Always;
}

@end
