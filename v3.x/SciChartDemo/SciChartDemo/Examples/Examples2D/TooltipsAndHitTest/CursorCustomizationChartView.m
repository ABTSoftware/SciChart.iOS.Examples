//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

#import "CursorCustomizationChartView.h"
#import "SCDDataManager.h"
#import "SCDRandomWalkGenerator.h"
#import <SciChart/SCISeriesTooltipBase+Protected.h>
#import <SciChart/SCISeriesInfoProviderBase+Protected.h>

#pragma mark - Cutsom Tooltip Container

@interface CustomCursorTooltipContainer : SCICursorModifierTooltip
@end
@implementation CustomCursorTooltipContainer
- (void)applyThemeProvider:(id<ISCIThemeProvider>)themeProvider {
    [super applyThemeProvider:themeProvider];
    self.backgroundColor = [UIColor fromARGBColorCode:0xffe2460c];
    self.layer.borderColor = [UIColor fromARGBColorCode:0xffff4500].CGColor;
}
@end

#pragma mark - Cutsom Series Tooltip

@interface CustomCursorXySeriesTooltip : SCIXySeriesTooltip
@end
@implementation CustomCursorXySeriesTooltip
- (void)internalUpdateWithSeriesInfo:(SCIXySeriesInfo *)seriesInfo {
    NSString *string = NSString.Empty;
    if (seriesInfo.seriesName != nil) {
        string = [string stringByAppendingFormat:@"%@\n", seriesInfo.seriesName];
    }
    string = [string stringByAppendingFormat:@"X: %@ ", seriesInfo.formattedXValue.rawString];
    string = [string stringByAppendingFormat:@"Y: %@", seriesInfo.formattedYValue.rawString];
    self.text = string;
    
    [self setTooltipBackground:0xff6495ed];
    [self setTooltipStroke:0xff4d81dd];
    [self setTooltipTextColor:0xffffffff];
}
@end

#pragma mark - Cutsom Info Providers

@interface CustomCursorSeriesInfoProvider : SCIDefaultXySeriesInfoProvider
@end
@implementation CustomCursorSeriesInfoProvider
- (id<ISCISeriesTooltip>)getSeriesTooltipInternalWithSeriesInfo:(SCIXySeriesInfo *)seriesInfo modifierType:(Class)modifierType {
    if (modifierType == SCICursorModifier.class) {
        return [[CustomCursorXySeriesTooltip alloc] initWithSeriesInfo:seriesInfo];
    } else {
        return [super getSeriesTooltipInternalWithSeriesInfo:seriesInfo modifierType:modifierType];
    }
}
@end

static int const PointsCount = 200;

#pragma mark - Chart Initialization

@implementation CursorCustomizationChartView

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    
    SCDRandomWalkGenerator *randomWalkGenerator = [SCDRandomWalkGenerator new];
    SCDDoubleSeries *data1 = [randomWalkGenerator getRandomWalkSeries:PointsCount];
    [randomWalkGenerator reset];
    SCDDoubleSeries *data2 = [randomWalkGenerator getRandomWalkSeries:PointsCount];
    
    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds1.seriesName = @"Series #1";
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds2.seriesName = @"Series #2";
    
    [ds1 appendValuesX:data1.xValues y:data1.yValues];
    [ds2 appendValuesX:data2.xValues y:data2.yValues];
    
    SCIFastLineRenderableSeries *line1 = [SCIFastLineRenderableSeries new];
    line1.dataSeries = ds1;
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xff6495ed thickness:2];
    line1.seriesInfoProvider = [CustomCursorSeriesInfoProvider new];
    
    SCIFastLineRenderableSeries * line2 = [SCIFastLineRenderableSeries new];
    line2.dataSeries = ds2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xffe2460c thickness:2];
    line2.seriesInfoProvider = [CustomCursorSeriesInfoProvider new];
      
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:line1];
        [self.surface.renderableSeries add:line2];
        [self.surface.chartModifiers add:[[SCICursorModifier alloc] initWithTooltipContainer:[CustomCursorTooltipContainer new]]];
        
        [SCIAnimations sweepSeries:line1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:line2 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
