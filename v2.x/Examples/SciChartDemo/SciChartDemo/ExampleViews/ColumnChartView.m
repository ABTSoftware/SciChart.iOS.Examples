//
//  ColumnChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 27.01.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ColumnChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@interface ColumnsTripleColorPalette : SCIPaletteProvider
@end

@implementation ColumnsTripleColorPalette {
    SCIColumnSeriesStyle * _style1;
    SCIColumnSeriesStyle * _style2;
    SCIColumnSeriesStyle * _style3;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _style1 = [SCIColumnSeriesStyle new];
        _style1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
        _style1.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFa9d34f finish:0xFF93b944 direction:SCILinearGradientDirection_Vertical];

        _style2 = [SCIColumnSeriesStyle new];
        _style2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
        _style2.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFfc9930 finish:0xFFd17f28 direction:SCILinearGradientDirection_Vertical];
        
        _style3 = [SCIColumnSeriesStyle new];
        _style3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
        _style3.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFd63b3f finish:0xFFbc3337 direction:SCILinearGradientDirection_Vertical];
    }
    return self;
}

- (id<SCIStyleProtocol>)styleForX:(double)x Y:(double)y Index:(int)index {
    int styleIndex = index % 3;
    if (styleIndex == 0) {
        return _style1;
    } else if (styleIndex == 1) {
        return _style2;
    } else {
        return _style3;
    }
}

@end

@implementation ColumnChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc]initWithFrame:frame];
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int32];
    int yValues[] = {50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60};
    for (int i = 0; i < sizeof(yValues)/sizeof(yValues[0]); i++) {
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric(yValues[i])];
    }
    
    SCIFastColumnRenderableSeries * rSeries = [SCIFastColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.paletteProvider = [ColumnsTripleColorPalette new];
    
    SCIWaveRenderableSeriesAnimation * animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [rSeries addAnimation:animation];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIRolloverModifier new]]];
    }];
}

@end
