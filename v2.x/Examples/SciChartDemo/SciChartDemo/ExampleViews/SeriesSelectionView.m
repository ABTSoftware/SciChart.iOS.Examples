//
//  LineChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "SeriesSelectionView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

static double const SeriesPointCount = 50;
static int const SeriesCount = 80;

@implementation SeriesSelectionView

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

-(void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> leftAxis = [SCINumericAxis new];
    leftAxis.axisId = @"yLeftAxis";
    leftAxis.axisAlignment = SCIAxisAlignment_Left;
    
    id<SCIAxis2DProtocol> rightAxis = [SCINumericAxis new];
    rightAxis.axisId = @"yRightAxis";
    rightAxis.axisAlignment = SCIAxisAlignment_Right;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:leftAxis];
        [surface.yAxes add:rightAxis];
        [surface.chartModifiers add:[SCISeriesSelectionModifier new]];
    
        UIColor * initialColor = [UIColor blueColor];
        for (int i = 0; i < SeriesCount; i++) {
            SCIAxisAlignment axisAlignment = i % 2 == 0 ? SCIAxisAlignment_Left : SCIAxisAlignment_Right;
            
            SCIXyDataSeries * dataSeries = [self generateDataSeries:axisAlignment andIndex:i];
            
            SCIEllipsePointMarker * pointMarker = [SCIEllipsePointMarker new];
            pointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFF00DC];
            pointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColor: [UIColor whiteColor] withThickness:1.0];
            pointMarker.height = 10;
            pointMarker.width = 10;
        
            SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
            rSeries.dataSeries = dataSeries;
            rSeries.yAxisId = axisAlignment == SCIAxisAlignment_Left ? @"yLeftAxis" : @"yRightAxis";
            rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:initialColor withThickness:1.0];
            rSeries.selectedStyle = rSeries.style;
            rSeries.selectedStyle.pointMarker = pointMarker;
            rSeries.hitTestProvider.hitTestMode = SCIHitTest_Interpolate;
            
            [surface.renderableSeries add:rSeries];
            
            CGFloat red, green, blue, alpha;
            [initialColor getRed:&red green:&green blue:&blue alpha:&alpha];
            
            CGFloat newR = red == 1.0 ? 1.0 : red + 0.0125;
            CGFloat newB = blue == 0.0 ? 0.0 : blue - 0.0125;
            initialColor = [[UIColor alloc] initWithRed:newR green:green blue:newB alpha:alpha];
            
            [rSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        }
    }];
}

- (SCIXyDataSeries *)generateDataSeries:(SCIAxisAlignment)axisAlignment andIndex:(int)index {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries.seriesName = [[NSString alloc]initWithFormat:@"Series %i", index];
    
    double gradient = axisAlignment == SCIAxisAlignment_Right ? index: -index;
    double start = axisAlignment == SCIAxisAlignment_Right ? 0.0 : 14000;
 
    DoubleSeries * straightLine = [DataManager getStraightLinesWithGradient:gradient yIntercept:start pointCount:SeriesPointCount];
    [dataSeries appendRangeX:straightLine.xValues Y:straightLine.yValues Count:straightLine.size];
    
    return dataSeries;
}

@end
