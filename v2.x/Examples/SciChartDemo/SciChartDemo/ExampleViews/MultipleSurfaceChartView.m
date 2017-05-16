//
//  MultipleSurfaceView.m
//  SciChartDemo
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "MultipleSurfaceChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@interface MultipleSurfaceChartView () {
    SCIMultiSurfaceModifier *szem;
    SCIMultiSurfaceModifier *spzm;
    
    SCIMultiSurfaceModifier *sXDrag;
    SCIMultiSurfaceModifier *sYDrag;
    
    SCIMultiSurfaceModifier *sRollover;
    
    SCIAxisRangeSyncronization * rSync;
    SCIAxisAreaSizeSyncronization * sSync;
}

@property (nonatomic, weak) SCIChartSurfaceView * sciChartView1;
@property (nonatomic, weak) SCIChartSurfaceView * sciChartView2;

@property (nonatomic, strong) SCIChartSurface * surface1;
@property (nonatomic, strong) SCIChartSurface * surface2;

@end

@implementation MultipleSurfaceChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        _sciChartView1 = view;
        [_sciChartView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView1];
        
        view = [[SCIChartSurfaceView alloc]init];
        _sciChartView2 = (SCIChartSurfaceView*)view;
        [_sciChartView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView2];
        NSDictionary *layout = @{@"SciChart1":_sciChartView1, @"SciChart2":_sciChartView2};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart2]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart1(SciChart2)]-(0)-[SciChart2(SciChart1)]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self createMultiSurface];
        [self createSharedModifiers];
        [self initializeSurface: _surface1 withXaxisId:@"X1" withYaxisId:@"Y1"];
        [self initializeSurface: _surface2 withXaxisId:@"X2" withYaxisId:@"Y2"];
    }
    
    return self;
}

-(void) createSharedModifiers {
    rSync = [SCIAxisRangeSyncronization new];
    sSync = [SCIAxisAreaSizeSyncronization new];
    sSync.syncMode = SCIAxisSizeSync_Right;
    
    szem = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIZoomExtentsModifier class]];
    spzm = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIPinchZoomModifier class]];

    sXDrag = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIXAxisDragModifier class]];
    sYDrag = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIYAxisDragModifier class]];
    
    sRollover = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIRolloverModifier class]];
}

-(void) createMultiSurface {
    _surface1 = [[SCIChartSurface alloc] initWithView: _sciChartView1];
    [sSync attachSurface:_surface1];
    
    _surface2 = [[SCIChartSurface alloc] initWithView: _sciChartView2];
    [sSync attachSurface:_surface2];
}

-(void) initializeSurface: (SCIChartSurface*)surface withXaxisId:(NSString*)xID withYaxisId:(NSString*)yId{
    [self addAxesToSurface:surface withXaxisId:xID withYaxisId:yId];
    [self addModifiersToSurface:surface withXaxisId:xID withYaxisId:yId];
    [self addRenderableSeriesTo:surface withXid:xID andYid:yId];
    [self addRenderableSeriesTo:surface withXid:xID andYid:yId];
    
    [surface invalidateElement];
}

-(void) addRenderableSeriesTo:(SCIChartSurface*)surface withXid:(NSString*)xId andYid:(NSString*) yId{
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    
    for (int i=0; i<500; i++) {
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric(500.0 * sin(i*M_PI*0.1)/i)];
    }
    
    SCIFastLineRenderableSeries *lineRenderSeries = [[SCIFastLineRenderableSeries alloc]init];
    [lineRenderSeries setDataSeries:dataSeries];
    [lineRenderSeries setXAxisId:xId];
    [lineRenderSeries setYAxisId:yId];
    lineRenderSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColor:[UIColor greenColor] withThickness:1.0];
    
    [surface.renderableSeries add:lineRenderSeries];
}

-(void) addAxesToSurface:(SCIChartSurface*)surface withXaxisId:(NSString*)xID withYaxisId:(NSString*)yId{
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    axis.axisId = yId;
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = xID;
    [rSync attachAxis:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
}

-(void) addModifiersToSurface:(SCIChartSurface*)surface withXaxisId:(NSString*)xID withYaxisId:(NSString*)yId{
    
    SCIXAxisDragModifier * xDrag = [sXDrag modifierForSurface:_surface2];
    xDrag.axisId = xID;
    xDrag.dragMode = SCIAxisDragMode_Scale;
    xDrag.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDrag = [sYDrag modifierForSurface:_surface2];
    yDrag.axisId = yId;
    yDrag.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[sXDrag, sYDrag, pzm, szem, sRollover]];
    surface.chartModifiers = gm;

}

@end
