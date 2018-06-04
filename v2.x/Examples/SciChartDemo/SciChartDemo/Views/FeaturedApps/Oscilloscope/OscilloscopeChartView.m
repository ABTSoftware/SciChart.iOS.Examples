//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// OscilloscopeChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "OscilloscopeChartView.h"
#include "DataManager.h"

@implementation OscilloscopeChartView {
    DataSourceEnum _selectedSource;
    BOOL _isDigitalLine;
    
    SCIXyDataSeries * _dataSeries1;
    SCIXyDataSeries * _dataSeries2;
    
    SCIFastLineRenderableSeries * _rSeries;
    
    NSTimeInterval _lastTimeDraw;
    CADisplayLink * _displayLink;
    
    double _phase0;
    double _phase1;
    double _phaseIncrement;
    
    id<SCIAxis2DProtocol> _xAxis;
    id<SCIAxis2DProtocol> _yAxis;
}

- (void)commonInit {
    __weak typeof(self) wSelf = self;
    self.seriesTypeTouched = ^{ [wSelf changeSeriesType]; };
    self.rotateTouched = ^{ [wSelf rotateChart]; };
    self.flippedVerticallyTouched = ^{ [wSelf flipChartVertically]; };
    self.flippedHorizontallyTouched = ^{ [wSelf flipChartHorizontally]; };
}

- (void)initExample {
    _phaseIncrement = M_PI * 0.1;
    
    _xAxis = [SCINumericAxis new];
    _xAxis.autoRange = SCIAutoRange_Never;
    _xAxis.axisTitle = @"Time (ms)";
    _xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(2.5) Max:SCIGeneric(4.5)];
    
    _yAxis = [SCINumericAxis new];
    _yAxis.autoRange = SCIAutoRange_Never;
    _yAxis.axisTitle = @"Voltage (mV)";
    _yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(-12.5) Max:SCIGeneric(12.5)];
    
    _dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _dataSeries1.acceptUnsortedData = YES;
    _dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _dataSeries2.acceptUnsortedData = YES;
    
    _rSeries = [SCIFastLineRenderableSeries new];
    _rSeries.isDigitalLine = _isDigitalLine;
    
    [self.surface.xAxes add:_xAxis];
    [self.surface.yAxes add:_yAxis];
    [self.surface.renderableSeries add:_rSeries];
    
    [SCIThemeManager applyDefaultThemeToThemeable:self.surface];
}

- (void)updateOscilloscopeData:(CADisplayLink*)displayLink {
    _lastTimeDraw = _displayLink.timestamp;
    
    DoubleSeries * doubleSeries = [DoubleSeries new];
    if (_selectedSource == Lissajous) {
        [DataManager setLissajousCurve:doubleSeries alpha:0.12 beta:_phase1 delta:_phase0 count:2500];
        [_dataSeries1 clear];
        [_dataSeries1 appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
        _rSeries.dataSeries = _dataSeries1;
    } else {
        [DataManager setFourierSeries:doubleSeries amplitude:2.0 phaseShift:_phase0 count:1000];
        [_dataSeries2 clear];
        [_dataSeries2 appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
        _rSeries.dataSeries = _dataSeries2;
    }
    
    _phase0 += _phaseIncrement;
    _phase1 += _phaseIncrement * 0.005;
}

- (void)changeSeriesType {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Data Source" message:@"Select data source or make the line Digital" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"Fourier" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        _selectedSource = FourierSeries;
        [self.surface.xAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(2.5) Max:SCIGeneric(4.5)];
        [self.surface.yAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(-12.5) Max:SCIGeneric(12.5)];
    }];
    [alertController addAction:action];

    action = [UIAlertAction actionWithTitle:@"Lisajous" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        _selectedSource = Lissajous;
        [self.surface.xAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(-1.2) Max:SCIGeneric(1.2)];
        [self.surface.yAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(-1.2) Max:SCIGeneric(1.2)];
    }];
    [alertController addAction:action];
    
    action = [UIAlertAction actionWithTitle:@"Make line Digital" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        _isDigitalLine = !_isDigitalLine;
        _rSeries.isDigitalLine = _isDigitalLine;
    }];
    [alertController addAction:action];

    UIViewController * topVC = UIApplication.sharedApplication.delegate.window.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC presentViewController:alertController animated:YES completion:nil];
}

- (void)rotateChart {
    int xAlignment = self.surface.xAxes[0].axisAlignment;
    if (++xAlignment > 4) {
        xAlignment = 1;
    }
    self.surface.xAxes[0].axisAlignment = (SCIAxisAlignment)xAlignment;
    
    int yAlignment = self.surface.yAxes[0].axisAlignment;
    if (++yAlignment > 4) {
        yAlignment = 1;
    }
    self.surface.yAxes[0].axisAlignment = (SCIAxisAlignment)yAlignment;
}

- (void)flipChartVertically {
    BOOL flip = self.surface.yAxes[0].flipCoordinates;
    self.surface.yAxes[0].flipCoordinates = !flip;
}

- (void)flipChartHorizontally {
    BOOL flip = self.surface.xAxes[0].flipCoordinates;
    self.surface.xAxes[0].flipCoordinates = !flip;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if(_displayLink == nil) {
        _lastTimeDraw = 0.0;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateOscilloscopeData:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

@end
