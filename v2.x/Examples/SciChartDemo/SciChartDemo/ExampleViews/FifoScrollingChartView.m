//
//  FifoScrollingChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/1/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "FifoScrollingChartView.h"
#import "FifoScrollingPanel.h"
#import "DataManager.h"
#import "RandomUtil.h"

static int const FifoCapacicty = 50;
static double const TimeInterval = 30.0;
static double const OneOverTimeInterval = 1.0 / TimeInterval;
static double const VisibleRangeMax = FifoCapacicty * OneOverTimeInterval;
static double const GrowBy = VisibleRangeMax * 0.1;

@implementation FifoScrollingChartView {
    NSTimer * _timer;
    SCIXyDataSeries * _ds1;
    SCIXyDataSeries * _ds2;
    SCIXyDataSeries * _ds3;
    
    double _t;
    BOOL _isRunning;
}

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) wSelf = self;
        
        FifoScrollingPanel * panel = (FifoScrollingPanel*)[[NSBundle mainBundle] loadNibNamed:@"FifoScrollingPanel" owner:self options:nil].firstObject;
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        
        panel.playCallback = ^() { _isRunning = YES; };
        panel.pauseCallback = ^() { _isRunning = NO; };
        panel.stopCallback = ^() {
            _isRunning = NO;
            [wSelf resetChart];
        };
        
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
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Never;
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(-GrowBy) Max:SCIGeneric(VisibleRangeMax + GrowBy)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    
    _ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _ds1.fifoCapacity = FifoCapacicty;
    _ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _ds2.fifoCapacity = FifoCapacicty;
    _ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _ds3.fifoCapacity = FifoCapacicty;

    SCIFastLineRenderableSeries * rs1 = [SCIFastLineRenderableSeries new];
    rs1.dataSeries = _ds1;
    rs1.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF4083B7 withThickness:2];
    
    SCIFastLineRenderableSeries * rs2 = [SCIFastLineRenderableSeries new];
    rs2.dataSeries = _ds2;
    rs2.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFFFFA500 withThickness:2];
    
    SCIFastLineRenderableSeries * rs3 = [SCIFastLineRenderableSeries new];
    rs3.dataSeries = _ds3;
    rs3.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFFE13219 withThickness:2];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rs1];
        [surface.renderableSeries add:rs2];
        [surface.renderableSeries add:rs3];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval / 1000.0 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
    _isRunning = YES;
}

- (void)updateData:(NSTimer *)timer {
    if (!_isRunning) return;
    
    double y1 = 3.0 * sin(((2 * M_PI) * 1.4) * _t) + [RandomUtil nextDouble] * 0.5;
    double y2 = 2.0 * cos(((2 * M_PI) * 0.8) * _t) + [RandomUtil nextDouble] * 0.5;
    double y3 = 1.0 * sin(((2 * M_PI) * 2.2) * _t) + [RandomUtil nextDouble] * 0.5;
    
    [_ds1 appendX:SCIGeneric(_t) Y:SCIGeneric(y1)];
    [_ds2 appendX:SCIGeneric(_t) Y:SCIGeneric(y2)];
    [_ds3 appendX:SCIGeneric(_t) Y:SCIGeneric(y3)];
    
    _t += OneOverTimeInterval;

    id<SCIAxis2DProtocol> xAxis = [surface.xAxes itemAt:0];
    if (_t > VisibleRangeMax) {
        [xAxis.visibleRange setMinTo:SCIGeneric(SCIGenericDouble(xAxis.visibleRange.min) + OneOverTimeInterval) MaxTo:SCIGeneric(SCIGenericDouble(xAxis.visibleRange.max) + OneOverTimeInterval)];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)resetChart {
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [_ds1 clear];
        [_ds2 clear];
        [_ds3 clear];
    }];
}

@end
