//
//  TooltipCustomizationChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 8/31/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <SciChart/SciChart.h>
#import "TooltipCustomizationChartView.h"
#import "DataManager.h"

@implementation TooltipCustomizationChartView
@synthesize sciChartSurfaceView;
@synthesize surface;

- (void)addModifiers{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 1;
    
    UIColor *customBlueColor = [UIColor colorWithRed:100.f/255.f
                                               green:149.f/255.f
                                                blue:237.f/255.f
                                               alpha:1.f];
    
    UIColor *customOrangeColor = [UIColor colorWithRed:226.f/255.f
                                                 green:70.f/255.f
                                                  blue:12.f/255.f
                                                 alpha:1.f];
    
    SCITooltipModifier *tooltipModifier = [SCITooltipModifier new];
    tooltipModifier.style.numberFormatter = formatter;
    tooltipModifier.modifierName = @"Tooltip modifier";
    
    // Customization of tool tip
    tooltipModifier.style.tooltipSize = CGSizeMake(NAN, NAN);
    tooltipModifier.style.colorMode = SCITooltipColorMode_Default;
    tooltipModifier.style.tooltipColor = customBlueColor;
    tooltipModifier.style.tooltipOpacity = 0.8;
    
    SCITextFormattingStyle *textFormatting = [SCITextFormattingStyle new];
    textFormatting.fontSize = 14;
    textFormatting.fontName = @"Helvetica";
    textFormatting.color = [UIColor blackColor];
    tooltipModifier.style.dataStyle = textFormatting;
    
    tooltipModifier.style.tooltipBorderWidth = 1;
    tooltipModifier.style.tooltipBorderColor = customOrangeColor;
    
    //Customization of cursor
    //    tooltipModifier.style.cursorPen = [[SCISolidPenStyle alloc] initWithColor:customOrangeColor
    //                                                                  withThickness:0.5];
    SCIEllipsePointMarker *pointMarker = [SCIEllipsePointMarker new];
    pointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor grayColor] withThickness:0.5f];
    pointMarker.width = 10;
    pointMarker.height = 10;
    tooltipModifier.style.targetMarker = pointMarker;
    //    rolloverModifier.style.useSeriesColorForMarker = YES;
    //    tooltipModifier.style.axisVerticalTooltipColor = customRedColor;
    //    tooltipModifier.style.axisVerticalTextStyle = textFormatting;
    //    tooltipModifier.style.axisHorizontalTooltipColor = customRedColor;
    //    tooltipModifier.style.axisHorizontalTextStyle = textFormatting;
    
    [self.surface.chartModifiers add:tooltipModifier];
}

- (void)initializeSurfaceRenderableSeries{
    [self attachRenderebleSeriesWithYValue:1000
                                  andColor:[UIColor colorWithRed:100.f/255.f
                                                           green:149.f/255.f
                                                            blue:237.f/255.f
                                                           alpha:1.f]
                                seriesName:@"Curve A"
                                 isVisible:YES];
    
    [self attachRenderebleSeriesWithYValue:2000
                                  andColor:[UIColor colorWithRed:226.f/255.f
                                                           green:70.f/255.f
                                                            blue:12.f/255.f
                                                           alpha:1.f]
                                seriesName:@"Curve B"
                                 isVisible:YES];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
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
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

- (void)addAxes{
    SCISolidPenStyle * majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle * gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle * minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Helvetica"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"yAxis";
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [surface.xAxes add:axis];
}

- (void)attachRenderebleSeriesWithYValue:(double)yValue
                                andColor:(UIColor*)color
                              seriesName:(NSString*)seriesName
                               isVisible:(BOOL)isVisible {
    int dataCount = 500;
    
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    dataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIGenericType xData;
    xData.type = SCIDataType_Int32;
    SCIGenericType yData;
    yData.floatData = arc4random_uniform(100);
    yData.type = SCIDataType_Float;
    
    for (int i = 0; i < dataCount; i++) {
        xData.int32Data = i;
        float value = yData.floatData + randf(-5.0, 5.0);
        yData.floatData = value;
        [dataSeries appendX:xData Y:yData];
    }
    
    SCIFastLineRenderableSeries * rSeries = [[SCIFastLineRenderableSeries alloc] init];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:color withThickness:0.5];
    [rSeries setXAxisId: @"xAxis"];
    [rSeries setYAxisId: @"yAxis"];
    rSeries.dataSeries = dataSeries;
    
    [surface.renderableSeries add:rSeries];
    [surface invalidateElement];
}

@end
