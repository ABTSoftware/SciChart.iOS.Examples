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


@implementation FifoScrollingChartView{
    NSTimer * _timer;
    SCIXyDataSeries * ds1;
    SCIXyDataSeries * ds2;
    SCIXyDataSeries * ds3;
    
    double t;
    
    int FIFO_CAPACITY;
    double TIME_INTERVAL;
    double ONE_OVER_TIME_INTERVAL;
    double VISIBLE_RANGE_MAX;
    double GROW_BY;
}


@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        FifoScrollingPanel * panel = (FifoScrollingPanel*)[[[NSBundle mainBundle] loadNibNamed:@"FifoScrollingPanel" owner:self options:nil] firstObject];
        
        __weak typeof(self) wSelf = self;
        
        panel.playCallback = ^() { [wSelf playPressed]; };
        panel.pauseCallback = ^() { [wSelf pausePressed]; };
        panel.stopCallback = ^() { [wSelf stopPressed]; };
        
        [self addSubview:panel];
        [self addSubview:surface];
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *layout = @{@"SciChart":surface, @"Panel":panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow: newWindow];
    if(_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL/1000
                                                  target:self
                                                selector:@selector(updateData:)
                                                userInfo:nil
                                                 repeats:YES];
    } else {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void) playPressed{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL/1000
                                                  target:self
                                                selector:@selector(updateData:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

-(void) pausePressed{
    [_timer invalidate];
    _timer = nil;
}

-(void) stopPressed{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [ds1 clear];
    [ds2 clear];
    [ds3 clear];
    
    [surface invalidateElement];
}

-(void) updateData: (NSTimer*) timer{
    double y1 = 3.0 * sin(((2 * M_PI) * 1.4) * t) + [RandomUtil nextDouble] * 0.5;
    double y2 = 2.0 * cos(((2 * M_PI) * 0.8) * t) + [RandomUtil nextDouble] * 0.5;
    double y3 = 1.0 * sin(((2 * M_PI) * 2.2) * t) + [RandomUtil nextDouble] * 0.5;
    
    [ds1 appendX:SCIGeneric(t) Y:SCIGeneric(y1)];
    [ds2 appendX:SCIGeneric(t) Y:SCIGeneric(y2)];
    [ds3 appendX:SCIGeneric(t) Y:SCIGeneric(y3)];
    
    t += ONE_OVER_TIME_INTERVAL;
    
    id<SCIAxis2DProtocol> xaxis = [surface.xAxes itemAt:0];
    if (t > VISIBLE_RANGE_MAX) {
        [xaxis.visibleRange setMin:SCIGeneric(SCIGenericFloat(xaxis.visibleRange.min)+ONE_OVER_TIME_INTERVAL)];
        [xaxis.visibleRange setMax:SCIGeneric(SCIGenericFloat(xaxis.visibleRange.max)+ONE_OVER_TIME_INTERVAL)];
    }
    [surface invalidateElement];
}

-(void) initializeSurfaceData {
    
    
    
    t=0;
    
    FIFO_CAPACITY = 50;
    TIME_INTERVAL = 30.0;
    ONE_OVER_TIME_INTERVAL = 1.0/TIME_INTERVAL;
    VISIBLE_RANGE_MAX = FIFO_CAPACITY * ONE_OVER_TIME_INTERVAL;
    GROW_BY = VISIBLE_RANGE_MAX * 0.1;
    
    ds1 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [ds1 setFifoCapacity:FIFO_CAPACITY];
    ds2 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [ds2 setFifoCapacity:FIFO_CAPACITY];
    ds3 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [ds3 setFifoCapacity:FIFO_CAPACITY];
    
    [self addAxes];
    [self addModifiers];
    [self addSeries];
}

-(void) addAxes{
    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    [xAxis setAutoRange:SCIAutoRange_Never];
    [xAxis setVisibleRange:[[SCIDoubleRange alloc] initWithMin:SCIGeneric(-GROW_BY) Max:SCIGeneric(VISIBLE_RANGE_MAX+GROW_BY)]];
    [surface.xAxes add:xAxis];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    [yAxis setAutoRange:SCIAutoRange_Always];
    [surface.yAxes add:yAxis];
}

-(void) addModifiers{
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[pzm, zem, zpm]];
    surface.chartModifiers = gm;
}

-(void) addSeries{
    [self createLineRenderSeries:0xFF4083B7 :2.0 :ds1];
    [self createLineRenderSeries:0xFFFFA500 :2.0 :ds2];
    [self createLineRenderSeries:0xFFE13219 :2.0 :ds3];
}

-(void) createLineRenderSeries: (uint) color :(float) thickness :(id<SCIXyDataSeriesProtocol>) dataSeries{
    SCIFastLineRenderableSeries * lineRenderSeries = [SCIFastLineRenderableSeries new];
    lineRenderSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:color withThickness:thickness];
    [lineRenderSeries setDataSeries:dataSeries];
    
    [surface.renderableSeries add:lineRenderSeries];
}
@end
