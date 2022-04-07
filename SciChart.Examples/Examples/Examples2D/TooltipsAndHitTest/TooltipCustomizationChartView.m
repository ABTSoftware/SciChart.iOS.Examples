//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TooltipCustomizationChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "TooltipCustomizationChartView.h"
#import "SCDDataManager.h"
#import "SCDRandomWalkGenerator.h"
#import <SciChart/SCISeriesTooltipBase+Protected.h>
#import <SciChart/SCISeriesInfoProviderBase+Protected.h>

#pragma mark - Cutsom Tooltips

@interface FirstCustomTooltipXySeriesTooltip : SCIXySeriesTooltip
@end
@implementation FirstCustomTooltipXySeriesTooltip
- (void)internalUpdateWithSeriesInfo:(SCIXySeriesInfo *)seriesInfo {
    NSString *string = NSString.empty;
    string = [string stringByAppendingFormat:@"X: %@\n", seriesInfo.formattedXValue.rawString];
    string = [string stringByAppendingFormat:@"Y: %@\n", seriesInfo.formattedYValue.rawString];
    if (seriesInfo.seriesName != nil) {
        string = [string stringByAppendingFormat:@"%@\n", seriesInfo.seriesName];
    }
    string = [string stringByAppendingString:@"Tooltip Modifier"];
    self.text = string;
    
    [self setTooltipBackground:0xFFE2460C];
    [self setTooltipStroke:0xFFFF4500];
    [self setTooltipTextColor:0xFFFFFFFF];
}
@end

@interface SecondCustomTooltipXySeriesTooltip : SCIXySeriesTooltip
@end
@implementation SecondCustomTooltipXySeriesTooltip
- (void)internalUpdateWithSeriesInfo:(SCIXySeriesInfo *)seriesInfo {
    NSString *string = @"Tooltip Modifier\n";
    if (seriesInfo.seriesName != nil) {
        string = [string stringByAppendingFormat:@"%@\n", seriesInfo.seriesName];
    }
    string = [string stringByAppendingFormat:@"X: %@ ", seriesInfo.formattedXValue.rawString];
    string = [string stringByAppendingFormat:@"Y: %@", seriesInfo.formattedYValue.rawString];
    self.text = string;
    
    [self setTooltipBackground:0xFF6495ED];
    [self setTooltipStroke:0xFF4D81DD];
    [self setTooltipTextColor:0xFFFFFFFF];
}
@end

#pragma mark - Cutsom Info Providers

@interface FirstCustomTooltipSeriesInfoProvider : SCIDefaultXySeriesInfoProvider
@end
@implementation FirstCustomTooltipSeriesInfoProvider
- (id<ISCISeriesTooltip>)getSeriesTooltipInternalWithSeriesInfo:(SCIXySeriesInfo *)seriesInfo modifierType:(Class)modifierType {
    if (modifierType == SCITooltipModifier.class) {
        return [[FirstCustomTooltipXySeriesTooltip alloc] initWithSeriesInfo:seriesInfo];
    } else {
        return [super getSeriesTooltipInternalWithSeriesInfo:seriesInfo modifierType:modifierType];
    }
}
@end
@interface SecondCustomTooltipSeriesInfoProvider : SCIDefaultXySeriesInfoProvider
@end
@implementation SecondCustomTooltipSeriesInfoProvider
- (id<ISCISeriesTooltip>)getSeriesTooltipInternalWithSeriesInfo:(SCIXySeriesInfo *)seriesInfo modifierType:(Class)modifierType {
    if (modifierType == SCITooltipModifier.class) {
        return [[SecondCustomTooltipXySeriesTooltip alloc] initWithSeriesInfo:seriesInfo];
    } else {
        return [super getSeriesTooltipInternalWithSeriesInfo:seriesInfo modifierType:modifierType];
    }
}
@end

static int const PointsCount = 200;

#pragma mark - Chart Initialization

@implementation TooltipCustomizationChartView

- (Class)associatedType { return SCIChartSurface.class; }

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
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF6495ED thickness:2];
    line1.seriesInfoProvider = [FirstCustomTooltipSeriesInfoProvider new];
    
    SCIFastLineRenderableSeries *line2 = [SCIFastLineRenderableSeries new];
    line2.dataSeries = ds2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFE2460C thickness:2];
    line2.seriesInfoProvider = [SecondCustomTooltipSeriesInfoProvider new];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:line1];
        [self.surface.renderableSeries add:line2];
        [self.surface.chartModifiers add:[SCITooltipModifier new]];
        
        [SCIAnimations sweepSeries:line1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:line2 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
