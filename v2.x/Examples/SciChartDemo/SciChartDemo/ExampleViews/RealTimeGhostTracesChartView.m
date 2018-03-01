//
//  RealTimeChostTracesChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/30/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "RealTimeGhostTracesChartView.h"
#import "RealTimeGhostedTracesPanel.h"
#import "DataManager.h"
#import "RandomUtil.h"

@implementation RealTimeGhostTracesChartView {
    NSTimer * _timer;

    double _lastAmplitude;
    double _phase;
}

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) wSelf = self;
        
        RealTimeGhostedTracesPanel * panel = (RealTimeGhostedTracesPanel *)[[NSBundle mainBundle] loadNibNamed:@"RealTimeGhostedTracesPanel" owner:self options:nil].firstObject;
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        panel.speedChanged = ^(UISlider* sender) { [wSelf onSpeedChanged:sender]; };
        
        [self addSubview:panel];
        [self addSubview:surface];
        
        NSDictionary * layout = @{@"SciChart":surface, @"Panel":panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    _lastAmplitude = 1.0;
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Never;
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(-2.0) Max:SCIGeneric(2.0)];
    
    [surface.xAxes add:xAxis];
    [surface.yAxes add:yAxis];
    
    uint limeGreen = 0xFF32CD32;
    
    [self addLineRenderableSeries:limeGreen opacity:1.0];
    [self addLineRenderableSeries:limeGreen opacity:0.9];
    [self addLineRenderableSeries:limeGreen opacity:0.8];
    [self addLineRenderableSeries:limeGreen opacity:0.7];
    [self addLineRenderableSeries:limeGreen opacity:0.62];
    [self addLineRenderableSeries:limeGreen opacity:0.55];
    [self addLineRenderableSeries:limeGreen opacity:0.45];
    [self addLineRenderableSeries:limeGreen opacity:0.35];
    [self addLineRenderableSeries:limeGreen opacity:0.25];
    [self addLineRenderableSeries:limeGreen opacity:0.15];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow: newWindow];
    
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)onSpeedChanged:(UISlider *) sender {
    if (sender.value > 0) {
        if (_timer != nil) {
            [_timer invalidate];
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:sender.value / 1000.0 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
    }
}

- (void)updateData:(NSTimer *)timer {
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];

        double randomAmplitude = _lastAmplitude + ([RandomUtil nextDouble] - 0.5);
        if (randomAmplitude < -2.0) {
            randomAmplitude = -2.0;
        } else if (randomAmplitude > 2.0) {
            randomAmplitude = 2.0;
        }
        
        DoubleSeries * noisySinewave = [DataManager getNoisySinewaveWithAmplitude:randomAmplitude Phase:_phase PointCount:1000 NoiseAmplitude:0.25];
        _lastAmplitude = randomAmplitude;
    
        [dataSeries appendRangeX:noisySinewave.xValues Y:noisySinewave.yValues Count:noisySinewave.size];
        
        [self reassignRenderSeriesWithDataSeries:dataSeries];
    }];
}

- (void)reassignRenderSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries {
    SCIRenderableSeriesCollection * rs = surface.renderableSeries;
    
    // shift old dataSeries
    [rs itemAt:9].dataSeries = [rs itemAt:8].dataSeries;
    [rs itemAt:8].dataSeries = [rs itemAt:7].dataSeries;
    [rs itemAt:7].dataSeries = [rs itemAt:6].dataSeries;
    [rs itemAt:6].dataSeries = [rs itemAt:5].dataSeries;
    [rs itemAt:5].dataSeries = [rs itemAt:4].dataSeries;
    [rs itemAt:4].dataSeries = [rs itemAt:3].dataSeries;
    [rs itemAt:3].dataSeries = [rs itemAt:2].dataSeries;
    [rs itemAt:2].dataSeries = [rs itemAt:1].dataSeries;
    [rs itemAt:1].dataSeries = [rs itemAt:0].dataSeries;
    
    // use new dataSeries to draw first renderableSeries
    [rs itemAt:0].dataSeries = dataSeries;
}

- (void)addLineRenderableSeries:(uint)color opacity:(float)opacity {
    SCIFastLineRenderableSeries * lineRenerableSeries = [SCIFastLineRenderableSeries new];
    lineRenerableSeries.opacity = opacity;
    lineRenerableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:1];
    
    [surface.renderableSeries add:lineRenerableSeries];
}

@end
