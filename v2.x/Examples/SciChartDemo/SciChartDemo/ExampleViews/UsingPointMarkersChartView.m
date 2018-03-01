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

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:surface];
        NSDictionary * layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    int dataSize = 15;
    for(int i=0; i < dataSize; i++){
        [ds1 appendX:SCIGeneric(i) Y:SCIGeneric(randf(0.0, 1.0))];
        [ds2 appendX:SCIGeneric(i) Y:SCIGeneric(1 + randf(0.0, 1.0))];
        [ds3 appendX:SCIGeneric(i) Y:SCIGeneric(2.5 + randf(0.0, 1.0))];
        [ds4 appendX:SCIGeneric(i) Y:SCIGeneric(4 + randf(0.0, 1.0))];
        [ds5 appendX:SCIGeneric(i) Y:SCIGeneric(5.5 + randf(0.0, 1.0))];
    }
    
    [ds1 updateAt:7 Y:SCIGeneric(NAN)];
    [ds2 updateAt:7 Y:SCIGeneric(NAN)];
    [ds3 updateAt:7 Y:SCIGeneric(NAN)];
    [ds4 updateAt:7 Y:SCIGeneric(NAN)];
    [ds5 updateAt:7 Y:SCIGeneric(NAN)];
    
    SCIEllipsePointMarker * pointMarker1 = [SCIEllipsePointMarker new];
    pointMarker1.width = 15;
    pointMarker1.height = 15;
    pointMarker1.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x990077ff];
    pointMarker1.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFFADD8E6 withThickness:2.0];
    
    SCISquarePointMarker * pointMarker2 = [SCISquarePointMarker new];
    pointMarker2.width = 20;
    pointMarker2.height = 20;
    pointMarker2.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x99ff0000];
    pointMarker2.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFFFF0000 withThickness:2.0];
    
    SCITrianglePointMarker * pointMarker3 = [SCITrianglePointMarker new];
    pointMarker3.width = 20;
    pointMarker3.height = 20;
    pointMarker3.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0xFFFFDD00];
    pointMarker3.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFFFF6600 withThickness:2.0];
    
    SCICrossPointMarker * pointMarker4 = [SCICrossPointMarker new];
    pointMarker4.width = 25;
    pointMarker4.height = 25;
    pointMarker4.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFFFF00FF withThickness:4.0];
    
    SCISpritePointMarker * pointMarker5 = [SCISpritePointMarker new];
    pointMarker5.width = 40;
    pointMarker5.height = 40;
    pointMarker5.textureBrush = [[SCITextureBrushStyle alloc] initWithTexture:[[SCITextureOpenGL alloc] initWithImage:[UIImage imageNamed:@"Weather_Storm"]]];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds1 pointMarker:pointMarker1 color:0xFFADD8E6]];
        [surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds2 pointMarker:pointMarker2 color:0xFFFF0000]];
        [surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds3 pointMarker:pointMarker3 color:0xFFFFFF00]];
        [surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds4 pointMarker:pointMarker4 color:0xFFFF00FF]];
        [surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds5 pointMarker:pointMarker5 color:0xFFF5DEB3]];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
    }];
}

- (SCIFastLineRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries pointMarker:(id<SCIPointMarkerProtocol>)pointMarker color:(uint)color {
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:2.0];
    rSeries.pointMarker = pointMarker;
    rSeries.dataSeries = dataSeries;
    
    SCIFadeRenderableSeriesAnimation * animation = [[SCIFadeRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic];
    [animation startAfterDelay:0.3];
    [rSeries addAnimation:animation];
    
    return rSeries;
}

@end
