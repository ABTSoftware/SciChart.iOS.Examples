//
//  UsingPointMarkersChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 3/30/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "UsingPointMarkersChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation UsingPointMarkersChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

- (void)generateRenderableSeries {
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIXyDataSeries * ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIXyDataSeries * ds5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    
    int dataSize = 15;
    
    for(int i=0; i<dataSize; i++){
        [ds1 appendX:SCIGeneric(i) Y:SCIGeneric(randf(0.0, 1.0))];
        [ds2 appendX:SCIGeneric(i) Y:SCIGeneric(1 + randf(0.0, 1.0))];
        [ds3 appendX:SCIGeneric(i) Y:SCIGeneric(2.5 + randf(0.0, 1.0))];
        [ds4 appendX:SCIGeneric(i) Y:SCIGeneric(4 + randf(0.0, 1.0))];
        [ds5 appendX:SCIGeneric(i) Y:SCIGeneric(5.5 + randf(0.0, 1.0))];
    }
    
    SCIEllipsePointMarker *pointMarker1 = [[SCIEllipsePointMarker alloc]init];
    [pointMarker1 setWidth:15];
    [pointMarker1 setHeight:15];
    [pointMarker1 setFillStyle:[[SCISolidBrushStyle alloc]initWithColorCode:0x990077ff]];
    [pointMarker1 setStrokeStyle: [[SCISolidPenStyle alloc]initWithColorCode:0xFFADD8E6 withThickness:2.0]];
    
    SCISquarePointMarker *pointMarker2 = [[SCISquarePointMarker alloc]init];
    [pointMarker2 setWidth:20];
    [pointMarker2 setHeight:20];
    [pointMarker2 setFillStyle:[[SCISolidBrushStyle alloc]initWithColorCode:0x99ff0000]];
    [pointMarker2 setStrokeStyle:[[SCISolidPenStyle alloc]initWithColorCode:0xFFFF0000 withThickness:2.0]];
    
    SCITrianglePointMarker *pointMarker3 = [[SCITrianglePointMarker alloc]init];
    [pointMarker3 setWidth:20];
    [pointMarker3 setHeight:20];
    [pointMarker3 setFillStyle:[[SCISolidBrushStyle alloc]initWithColorCode:0xFFFFDD00]];
    [pointMarker3 setStrokeStyle:[[SCISolidPenStyle alloc]initWithColorCode:0xFFFF6600 withThickness:2.0]];
    
    SCICrossPointMarker *pointMarker4 = [[SCICrossPointMarker alloc]init];
    [pointMarker4 setWidth:25];
    [pointMarker4 setHeight:25];
    [pointMarker4 setStrokeStyle:[[SCISolidPenStyle alloc]initWithColorCode:0xFFFF00FF withThickness:4.0]];
    
    SCISpritePointMarker *pointMarker5 = [[SCISpritePointMarker alloc]init];
    [pointMarker5 setWidth:40];
    [pointMarker5 setHeight:40];
    [pointMarker5 setTextureBrush:[[SCITextureBrushStyle alloc]initWithTexture:[[SCITextureOpenGL alloc]initWithImage:[UIImage imageNamed:@"Weather_Storm"]]]];
    
    [surface.renderableSeries add:[self p_generateRenderableSeriesWithDataSeries:ds1 andPointMarker:pointMarker1 andSeriesPen:[[SCISolidPenStyle alloc]initWithColorCode:0xFFADD8E6 withThickness:2.0]]];
    [surface.renderableSeries add:[self p_generateRenderableSeriesWithDataSeries:ds2 andPointMarker:pointMarker2 andSeriesPen:[[SCISolidPenStyle alloc]initWithColorCode:0xFFFF0000 withThickness:2.0]]];
    [surface.renderableSeries add:[self p_generateRenderableSeriesWithDataSeries:ds3 andPointMarker:pointMarker3 andSeriesPen:[[SCISolidPenStyle alloc]initWithColorCode:0xFFFFFF00 withThickness:2.0]]];
    [surface.renderableSeries add:[self p_generateRenderableSeriesWithDataSeries:ds4 andPointMarker:pointMarker4 andSeriesPen:[[SCISolidPenStyle alloc]initWithColorCode:0xFFFF00FF withThickness:2.0]]];
    [surface.renderableSeries add:[self p_generateRenderableSeriesWithDataSeries:ds5 andPointMarker:pointMarker5 andSeriesPen:[[SCISolidPenStyle alloc]initWithColorCode:0xFFF5DEB3 withThickness:2.0]]];
    
    [surface invalidateElement];
}

- (SCIFastLineRenderableSeries*)p_generateRenderableSeriesWithDataSeries:(SCIXyDataSeries*)dataSeries andPointMarker:(id<SCIPointMarkerProtocol>)pointMarker andSeriesPen:(id<SCIPenStyleProtocol>)pen{
    SCIFastLineRenderableSeries * renderableSeries = [[SCIFastLineRenderableSeries alloc] init];
    [renderableSeries.style setLinePen:pen];
    [renderableSeries.style setDrawPointMarkers:YES];
    [renderableSeries.style setPointMarker:pointMarker];
    [renderableSeries setDataSeries:dataSeries];
    
    return renderableSeries;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCIDateTimeAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifier = gm;
    
    [self generateRenderableSeries];
}

@end
