//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CursorCustomizationChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <SciChart/SciChart.h>
#import "CursorCustomizationChartView.h"
#import "DataManager.h"
#import "RandomWalkGenerator.h"

static int const PointsCount = 200;

@interface CustomCursorView : SCIXySeriesDataView

@property (weak, nonatomic) IBOutlet UILabel * seriesName;

@end

@implementation CustomCursorView

+ (SCITooltipDataView *)createInstance {
    CustomCursorView * view = [NSBundle.mainBundle loadNibNamed:@"CustomCursorView" owner:nil options:nil].firstObject;
    view.translatesAutoresizingMaskIntoConstraints = false;
    
    return view;
}

- (void)setData:(SCISeriesInfo *)data {
    SCIXySeriesInfo * seriesInfo = (SCIXySeriesInfo *)data;
    
    _seriesName.text = [NSString stringWithFormat:@"%@ - X: %@; Y: %@", seriesInfo.seriesName, [seriesInfo formatXCursorValue:seriesInfo.xValue], [seriesInfo formatYCursorValue:seriesInfo.yValue]];
}

@end

@interface CustomCursorSeriesInfo : SCIXySeriesInfo
@end

@implementation CustomCursorSeriesInfo
- (CustomCursorView *)createDataSeriesView {
    CustomCursorView * view = (CustomCursorView *)[CustomCursorView createInstance];
    [view setData:self];
    
    return view;
}
@end

@interface CustomCursorLineSeries : SCIFastLineRenderableSeries
@end

@implementation CustomCursorLineSeries
- (SCISeriesInfo *)toSeriesInfoWithHitTest:(SCIHitTestInfo)info {
    return [[CustomCursorSeriesInfo alloc] initWithSeries:self HitTest:info];
}
@end

@implementation CursorCustomizationChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    
    RandomWalkGenerator * randomWalkGenerator = [RandomWalkGenerator new];
    DoubleSeries * data1 = [randomWalkGenerator getRandomWalkSeries:PointsCount];
    [randomWalkGenerator reset];
    DoubleSeries * data2 = [randomWalkGenerator getRandomWalkSeries:PointsCount];
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds1.seriesName = @"Series #1";
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds2.seriesName = @"Series #2";
    
    [ds1 appendRangeX:data1.xValues Y:data1.yValues Count:data1.size];
    [ds2 appendRangeX:data2.xValues Y:data2.yValues Count:data2.size];
    
    SCIFastLineRenderableSeries * line1 = [CustomCursorLineSeries new];
    line1.dataSeries = ds1;
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xff6495ed withThickness:2];
    
    SCIFastLineRenderableSeries * line2 = [CustomCursorLineSeries new];
    line2.dataSeries = ds2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xffe2460c withThickness:2];
    
    SCICursorModifier * cursorModifier = [SCICursorModifier new];
    cursorModifier.style.contentPadding = 0;
    cursorModifier.style.colorMode = SCITooltipColorMode_Default;
    cursorModifier.style.tooltipColor = [UIColor fromARGBColorCode:0xff6495ed];
    cursorModifier.style.tooltipOpacity = 0.8;
    cursorModifier.style.tooltipBorderWidth = 1;
    cursorModifier.style.tooltipBorderColor = [UIColor fromARGBColorCode:0xffe2460c];
    cursorModifier.style.cursorPen = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xffe2460c] withThickness:0.5];
    cursorModifier.style.axisVerticalTooltipColor = [UIColor fromARGBColorCode:0xffe2460c];
    cursorModifier.style.axisHorizontalTooltipColor = [UIColor fromARGBColorCode:0xffe2460c];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:line1];
        [self.surface.renderableSeries add:line2];
        [self.surface.chartModifiers add:cursorModifier];
        
        [line1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
