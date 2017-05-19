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
    
    SCIFastLineRenderableSeries * _renderSeries;
    
    NSTimeInterval _timeInterval;
    NSTimeInterval _lastTimeDraw;
    CADisplayLink *_displayLink;
    
    double _phase0;
    double _phase1;
    double _phaseIncrement;
    
    id<SCIAxis2DProtocol> _xAxis;
    id<SCIAxis2DProtocol> _yAxis;
}


@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]init];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        OscilloscopePanel * panel = (OscilloscopePanel*)[[[NSBundle mainBundle] loadNibNamed:@"OscilloscopePanel" owner:nil options:nil] firstObject];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) wSelf = self;
        
        //Subscribing to the control view events
        panel.seriesTypeTouched = ^(UIButton *sender) { [wSelf changeSeriesType:sender]; };
        panel.rotateTouched = ^(UIButton *sender) { [wSelf rotateChart:sender]; };
        panel.flippedVerticallyTouched = ^(UIButton *sender) { [wSelf flipVerticallyChart:sender]; };
        panel.flippedHorizontallyTouched = ^(UIButton *sender) { [wSelf flipHorizontallyChart:sender]; };
        
        [self addSubview:surface];
        [self addSubview:panel];
        
        NSDictionary *layout = @{@"SciChart1": surface, @"Panel": panel};
        
        //Adding constraints for views' layout
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        
        _phase0 = 0.0;
        _phaseIncrement = M_PI * 0.1;
    
        _isDigitalLine = false;
        _selectedSource = FourierSeries;
        
        [self initalizeSurfaceData];
    }
    return self;
}

-(void) changeSeriesType:(UIButton *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Data Source" message:@"Select data source or make the line Digital" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"Fourier" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        _selectedSource = FourierSeries;
        [[surface.xAxes itemAt:0]setVisibleRange:[[SCIDoubleRange alloc]initWithMin:SCIGeneric(2.5) Max:SCIGeneric(4.5)]];
        [[surface.yAxes itemAt:0]setVisibleRange:[[SCIDoubleRange alloc]initWithMin:SCIGeneric(-12.5) Max:SCIGeneric(12.5)]];
    }];
    [alertController addAction:action];

    action = [UIAlertAction actionWithTitle:@"Lisajous" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        _selectedSource = Lissajous;
        [[surface.xAxes itemAt:0]setVisibleRange:[[SCIDoubleRange alloc]initWithMin:SCIGeneric(-1.2) Max:SCIGeneric(1.2)]];
        [[surface.yAxes itemAt:0]setVisibleRange:[[SCIDoubleRange alloc]initWithMin:SCIGeneric(-1.2) Max:SCIGeneric(1.2)]];
    }];
    [alertController addAction:action];
    
    action = [UIAlertAction actionWithTitle:@"Make line Digital" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        _isDigitalLine = !_isDigitalLine;
        _renderSeries.style.isDigitalLine = _isDigitalLine;
    }];
    [alertController addAction:action];

    alertController.popoverPresentationController.sourceRect = sender.bounds;
    alertController.popoverPresentationController.sourceView = sender;
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController :alertController animated:YES completion:nil];
}

-(void) rotateChart:(UIButton *)sender{
    int xAlignment = [[surface.xAxes itemAt:0] axisAlignment];
    if (++xAlignment > 4) {
        xAlignment = 1;
    }
    [[surface.xAxes itemAt:0] setAxisAlignment:(SCIAxisAlignment)xAlignment];
    int yAlignment = [[surface.yAxes itemAt:0] axisAlignment];
    if (++yAlignment>4) {
        yAlignment = 1;
    }
    [[surface.yAxes itemAt:0] setAxisAlignment:(SCIAxisAlignment)yAlignment];
}

-(void) flipVerticallyChart:(UIButton *)sender{
    BOOL flip = [[surface.yAxes itemAt:0] flipCoordinates];
    [[surface.yAxes itemAt:0] setFlipCoordinates:!flip];
}

-(void) flipHorizontallyChart:(UIButton *)sender{
    BOOL flip = [[surface.xAxes itemAt:0] flipCoordinates];
    [[surface.xAxes itemAt:0] setFlipCoordinates:!flip];
}

- (UIViewController *)currentTopViewController{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow: newWindow];
    if(_displayLink == nil){
        _timeInterval = 0.2;
        _lastTimeDraw = 0.0;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateOscilloscopeData:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

-(void)initalizeSurfaceData{
    
    
    _dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [_dataSeries1 setAcceptUnsortedData:YES];
    _dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [_dataSeries2 setAcceptUnsortedData:YES];
    
    _xAxis = [[SCINumericAxis alloc] init];
    [_xAxis setAutoRange:SCIAutoRange_Never];
    [_xAxis setAxisTitle:@"Time (ms)"];
    [_xAxis setVisibleRange:[[SCIDoubleRange alloc] initWithMin:SCIGeneric(2.5) Max:SCIGeneric(4.5)]];
    [surface.xAxes add:_xAxis];
    
    _yAxis = [[SCINumericAxis alloc] init];
    [_yAxis setAutoRange:SCIAutoRange_Never];
    [_yAxis setAxisTitle:@"Voltage (mV)"];
    [_yAxis setVisibleRange:[[SCIDoubleRange alloc] initWithMin:SCIGeneric(-12.5) Max:SCIGeneric(12.5)]];
    [surface.yAxes add:_yAxis];
    
    _renderSeries = [SCIFastLineRenderableSeries new];
    _renderSeries.style.isDigitalLine = _isDigitalLine;
    
    [surface.renderableSeries add:_renderSeries];
}

-(void)updateOscilloscopeData:(CADisplayLink*)displayLink{
    _lastTimeDraw = _displayLink.timestamp;
    
    switch (_selectedSource) {
        case Lissajous:
            [_dataSeries1 clear];
            [DataManager setLissajousCurve:_dataSeries1 alpha:0.12 beta:_phase1 delta:_phase0 count:2500];
            [_renderSeries setDataSeries:_dataSeries1];
            break;
        case FourierSeries:
            [_dataSeries2 clear];
            [DataManager getFourierSeries:_dataSeries2 amplitude:2.0 phaseShift:_phase0 count:2000];
            [_renderSeries setDataSeries:_dataSeries2];
            break;
        default:
            break;
    }
    _phase0 += _phaseIncrement;
    _phase1 += _phaseIncrement * 0.005;
}

@end
