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

@implementation RealTimeGhostTracesChartView{
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
        
        RealTimeGhostedTracesPanel * panel = (RealTimeGhostedTracesPanel*)[[[NSBundle mainBundle] loadNibNamed:@"RealTimeGhostedTracesPanel" owner:self options:nil] firstObject];
        
        __weak typeof(self) wSelf = self;
        panel.speedChanged = ^(UISlider* sender) { [wSelf speedChangedPressed:sender]; };
        
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

-(void) speedChangedPressed:(UISlider *) sender{
    [_timer invalidate];
    _timeInterval = sender.value/1000;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                              target:self
                                            selector:@selector(updateData:)
                                            userInfo:nil
                                             repeats:YES];
}

-(void) updateData: (NSTimer*) timer{
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    
    double randomAmplitude = _lastAmplitude + ([RandomUtil nextDouble] - 0.5);
    
    if (randomAmplitude<-2.0) {
        randomAmplitude = -2.0;
    }else if (randomAmplitude>2.0){
        randomAmplitude = 2.0;
    }
    
    DoubleSeries * doubleSeries = [DataManager getNoisySinewaveWithAmplitude:randomAmplitude Phase:_phase PointCount:1000 NoiseAmplitude:0.25];
    _lastAmplitude = randomAmplitude;
 
    [dataSeries appendRangeX:[doubleSeries xValues] Y:[doubleSeries yValues] Count:doubleSeries.size];
    [_circularArray addObject:dataSeries];
    
    if ([_circularArray count] > 11) {
        [_circularArray removeObjectAtIndex:0];
    }
    
    [self reassignRenderSeries];
}

-(void) reassignRenderSeries{
    NSUInteger size = _circularArray.count;
    
    // Always the latest dataseries
    if (size > 0){
        [[surface.renderableSeries itemAt:0] setDataSeries:_circularArray[size-1]];
    }
    if (size > 1){
        [[surface.renderableSeries itemAt:1] setDataSeries:_circularArray[size-2]];
    }
    if (size > 2){
        [[surface.renderableSeries itemAt:2] setDataSeries:_circularArray[size-3]];
    }
    if (size > 3){
        [[surface.renderableSeries itemAt:3] setDataSeries:_circularArray[size-4]];
    }
    if (size > 4){
        [[surface.renderableSeries itemAt:4] setDataSeries:_circularArray[size-5]];
    }
    if (size > 5){
        [[surface.renderableSeries itemAt:5] setDataSeries:_circularArray[size-6]];
    }
    if (size > 6){
        [[surface.renderableSeries itemAt:6] setDataSeries:_circularArray[size-7]];
    }
    if (size > 7){
        [[surface.renderableSeries itemAt:7] setDataSeries:_circularArray[size-8]];
    }
    if (size > 8){
        [[surface.renderableSeries itemAt:8] setDataSeries:_circularArray[size-9]];
    }
    
    // Always the oldest dataseries
    if (size > 9){
        [[surface.renderableSeries itemAt:9] setDataSeries:_circularArray[size-10]];
    }
}

-(void) initializeSurfaceData {
    _lastAmplitude = 1.0;
    _phase = 0.0;
    _timeInterval = 20.0/1000;
    _circularArray = [NSMutableArray new];
    
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
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[pzm, zem, zpm]];
    surface.chartModifiers = gm;
}

-(void) addSeries{
    uint limeGreen = 0xFF32CD32;
    
    [self addLineRenderableSeries:limeGreen :1.0];
    [self addLineRenderableSeries:limeGreen :0.9];
    [self addLineRenderableSeries:limeGreen :0.8];
    [self addLineRenderableSeries:limeGreen :0.7];
    [self addLineRenderableSeries:limeGreen :0.62];
    [self addLineRenderableSeries:limeGreen :0.55];
    [self addLineRenderableSeries:limeGreen :0.45];
    [self addLineRenderableSeries:limeGreen :0.35];
    [self addLineRenderableSeries:limeGreen :0.25];
    [self addLineRenderableSeries:limeGreen :0.15];
}

-(void) addLineRenderableSeries:(uint)color :(float)thickness{
    SCIFastLineRenderableSeries * lineRenerableSeries = [SCIFastLineRenderableSeries new];
    lineRenerableSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:color withThickness:thickness];
    
    [surface.renderableSeries add:lineRenerableSeries];
}

@end
