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
    double _lastAmplitude;
    double _phase;
    double _timeInterval;
    NSMutableArray * _circularArray;
}

@synthesize sciChartSurfaceView;
@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        FifoScrollingPanel * panel = (FifoScrollingPanel*)[[[NSBundle mainBundle] loadNibNamed:@"FifoScrollingPanel" owner:self options:nil] firstObject];
        
        __weak typeof(self) wSelf = self;
        
        panel.playCallback = ^() { [wSelf playPressed]; };
        panel.pauseCallback = ^() { [wSelf pausePressed]; };
        panel.stopCallback = ^() { [wSelf stopPressed]; };
        
        [self addSubview:panel];
        [self addSubview:sciChartSurfaceView];
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView, @"Panel":panel};
        
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
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
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
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                                  target:self
                                                selector:@selector(updateData:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

-(void) pausePressed{
    
}

-(void) stopPressed{
    
}

-(void) updateData: (NSTimer*) timer{
    
}

-(void) initializeSurfaceData {
    
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [self addAxes];
    [self addModifiers];
    [self addSeries];
}

-(void) addAxes{
    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    [xAxis setAutoRange:SCIAutoRange_Always];
    [surface.xAxes add:xAxis];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    [yAxis setAutoRange:SCIAutoRange_Never];
    [yAxis setVisibleRange:[[SCIDoubleRange alloc] initWithMin:SCIGeneric(-2.0) Max:SCIGeneric(2.0)]];
    [surface.yAxes add:yAxis];
}

-(void) addModifiers{
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[pzm, zem, zpm]];
    surface.chartModifier = gm;
}

-(void) addSeries{
}
@end
