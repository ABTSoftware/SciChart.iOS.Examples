//
//  OscilloscopeChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/6/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "OscilloscopeChartView.h"
#import <SciChart/SciChart.h>
#include <math.h>
#include "DataManager.h"
#include "OscilloscopePanel.h"

@implementation OscilloscopeChartView{
    DataSourceEnum _selectedSource;
    BOOL _isDigitalLine;
    
    SCIXyDataSeries * _dataSeries1;
    SCIXyDataSeries * _dataSeries2;
    
    SCIFastLineRenderableSeries * _rSeries;
    
    NSTimeInterval _timeInterval;
    NSTimeInterval _lastTimeDraw;
    CADisplayLink * _displayLink;
    
    double _phase0;
    double _phase1;
    double _phaseIncrement;
    
    id<SCIAxis2DProtocol> _xAxis;
    id<SCIAxis2DProtocol> _yAxis;
}

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        OscilloscopePanel * panel = (OscilloscopePanel *)[[NSBundle mainBundle] loadNibNamed:@"OscilloscopePanel" owner:nil options:nil]. firstObject;
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) wSelf = self;
        
        panel.seriesTypeTouched = ^(UIButton *sender) { [wSelf changeSeriesType:sender]; };
        panel.rotateTouched = ^(UIButton *sender) { [wSelf rotateChart:sender]; };
        panel.flippedVerticallyTouched = ^(UIButton *sender) { [wSelf flipVerticallyChart:sender]; };
        panel.flippedHorizontallyTouched = ^(UIButton *sender) { [wSelf flipHorizontallyChart:sender]; };
        
        [self addSubview:surface];
        [self addSubview:panel];
        
        NSDictionary *layout = @{@"SciChart1": surface, @"Panel": panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        
        _phaseIncrement = M_PI * 0.1;
        _selectedSource = FourierSeries;
        
        [self initalizeSurfaceData];
    }
    return self;
}

-(void) changeSeriesType:(UIButton *)sender{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Data Source" message:@"Select data source or make the line Digital" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"Fourier" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        _selectedSource = FourierSeries;
        [surface.xAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(2.5) Max:SCIGeneric(4.5)];
        [surface.yAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(-12.5) Max:SCIGeneric(12.5)];
    }];
    [alertController addAction:action];

    action = [UIAlertAction actionWithTitle:@"Lisajous" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        _selectedSource = Lissajous;
        [surface.xAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(-1.2) Max:SCIGeneric(1.2)];
        [surface.yAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(-1.2) Max:SCIGeneric(1.2)];
    }];
    [alertController addAction:action];
    
    action = [UIAlertAction actionWithTitle:@"Make line Digital" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        _isDigitalLine = !_isDigitalLine;
        _rSeries.isDigitalLine = _isDigitalLine;
    }];
    [alertController addAction:action];

    alertController.popoverPresentationController.sourceRect = sender.bounds;
    alertController.popoverPresentationController.sourceView = sender;
    
    [[self currentTopViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)rotateChart:(UIButton *)sender {
    int xAlignment = [surface.xAxes itemAt:0].axisAlignment;
    if (++xAlignment > 4) {
        xAlignment = 1;
    }
    [surface.xAxes itemAt:0].axisAlignment = (SCIAxisAlignment)xAlignment;
    int yAlignment = [surface.yAxes itemAt:0].axisAlignment;
    if (++yAlignment > 4) {
        yAlignment = 1;
    }
    [surface.yAxes itemAt:0].axisAlignment = (SCIAxisAlignment)yAlignment;
}

- (void)flipVerticallyChart:(UIButton *)sender {
    BOOL flip = [surface.yAxes itemAt:0].flipCoordinates;
    [surface.yAxes itemAt:0].flipCoordinates = !flip;
}

- (void) flipHorizontallyChart:(UIButton *)sender {
    BOOL flip = [surface.xAxes itemAt:0].flipCoordinates;
    [surface.xAxes itemAt:0].flipCoordinates = !flip;
}

- (UIViewController *)currentTopViewController {
    UIViewController * topVC = UIApplication.sharedApplication.delegate.window.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if(_displayLink == nil) {
        _timeInterval = 0.2;
        _lastTimeDraw = 0.0;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateOscilloscopeData:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)initalizeSurfaceData {
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
    
    [surface.xAxes add:_xAxis];
    [surface.yAxes add:_yAxis];
    [surface.renderableSeries add:_rSeries];
    
    [SCIThemeManager applyDefaultThemeToThemeable:surface];
}

- (void)updateOscilloscopeData:(CADisplayLink*)displayLink {
    _lastTimeDraw = _displayLink.timestamp;
    
    DoubleSeries * doubleSeries = [DoubleSeries new];
    if (_selectedSource == Lissajous) {
        [DataManager setLissajousCurve:doubleSeries alpha:0.12 beta:_phase1 delta:_phase0 count:2500];
        [_dataSeries1 clear];
        [_dataSeries1 appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
        [_rSeries setDataSeries:_dataSeries1];
    } else {
        [DataManager setFourierSeries:doubleSeries amplitude:2.0 phaseShift:_phase0 count:1000];
        [_dataSeries2 clear];
        [_dataSeries2 appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
        [_rSeries setDataSeries:_dataSeries2];
    }
    
    _phase0 += _phaseIncrement;
    _phase1 += _phaseIncrement * 0.005;
}

@end
